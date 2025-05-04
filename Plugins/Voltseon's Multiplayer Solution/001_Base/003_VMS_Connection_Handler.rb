module VMS
  require 'socket'
  require "zlib"

  def self.join(id=-1)
    if id == -1
      VMS.log("No ID specified", true)
      return
    end
    if !$game_temp.vms[:socket].nil?
      VMS.log("Already connected to a server")
      return
    end
    begin
      socket = VMS::USE_TCP ? TCPSocket.new(VMS::HOST, VMS::PORT) : UDPSocket.new.tap { |s| s.connect(VMS::HOST, VMS::PORT) }
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET
      VMS.log("Server is not active", true)
    rescue => e
      VMS.log("Failed to connect to server: #{e}", true)
    ensure
      return if socket.nil?
    end
    $game_temp.vms[:cluster] = id
    $game_temp.vms[:socket] = socket
    VMS.send_message(["connect", VMS.generate_player_data])
    VMS.log("Connected to server")
  end

  def self.leave(show_message = true)
    return if $game_temp.vms[:socket].nil?
    VMS.clear_events
    VMS.send_message(["disconnect", VMS.generate_player_data])
    $game_temp.vms[:socket].close
    System.set_window_title(System.game_title) if VMS::SHOW_PING
    $game_temp.vms[:socket] = nil
    $game_temp.vms[:cluster] = -1
    $game_temp.vms[:ping_log] = []
    $game_temp.vms[:time_since_last_message] = 0
    $game_temp.vms[:ping_stamp] = 0
    $game_temp.vms[:players] = {}
    $game_temp.vms[:online_variables] = {}
    VMS.log("Disconnected from server") if show_message
    VMS.message(VMS::DISCONNECTED_MESSAGE) if show_message && !VMS::DISCONNECTED_MESSAGE.to_s.empty?
  end

  def self.update
    return if $game_temp.vms[:socket].nil?
    if VMS::SHOW_PING
      $game_temp.vms[:ping_log].push((VMS.ping * 500).round)
      $game_temp.vms[:ping_log].shift if $game_temp.vms[:ping_log].size > 50
      ping = [$game_temp.vms[:ping_log].sum / $game_temp.vms[:ping_log].size, 0].max
      System.set_window_title(System.game_title + " (#{ping}ms)")
    end
    begin
      if VMS::TICK_RATE == 0 || Graphics.frame_count % (60 / VMS::TICK_RATE) == 0
        send_data = VMS.generate_player_data
        send_data[:follower] = {
          species: $follower_pokemon&.species,
          form: $follower_pokemon&.form,
          shiny: $follower_pokemon&.shiny?
        }
        own_player = VMS.get_self
        update_data = own_player.nil? ? send_data : send_data.reject do |key, value|
          key != :state && key != :cluster_id && key != :id && key != :heartbeat &&
          ((!value.is_a?(Array) && own_player.instance_variable_get("@" + key.to_s) == value) ||
           (value.is_a?(Array) && VMS.array_compare(own_player.instance_variable_get("@" + key.to_s), value)))
        end
        VMS.send_message(["update", update_data])
      end
      data = $game_temp.vms[:socket].read_nonblock(65536, exception: false)
      if data == :wait_readable || data == :wait_writable || data.nil?
        $game_temp.vms[:time_since_last_message] += Graphics.delta
        VMS.leave if $game_temp.vms[:time_since_last_message] > VMS::TIMEOUT_SECONDS
        return
      end
      $game_temp.vms[:time_since_last_message] = 0
      data = Marshal.load(Zlib::Inflate.inflate(data))
      if data.is_a?(Symbol)
        VMS.leave(false)
        return
      end
      if data[0] == :disconnect_player
        id = data[1]
        player = VMS.get_player(id)
        return if player.nil?
        Rf.delete_event(player.rf_event) if VMS.event_deletion_possible?(player)
        $game_temp.vms[:players].delete(id)
        return
      end
      VMS.process(data)
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET
      VMS.leave(false)
    rescue => e
      VMS.log("Failed to communicate with server: #{e}", true)
      VMS.leave
    end
    VMS.get_players.each do |player|
      next if player.id == $player.id
      VMS.check_timeout(player)
      VMS.check_interaction(player) if $game_temp.vms[:state][0] == :idle && VMS.interaction_possible?
    end
  end

  def self.process(data)
    VMS.sync_seed if VMS::SEED_SYNC && $game_temp.vms[:battle_player].nil?
    data.each do |pl|
      if pl[0] == :online_variables
        $game_temp.vms[:online_variables] = pl[1]
        next
      end
      id = pl["id"]
      player = $game_temp.vms[:players][id] ||= VMS::Player.new(id, "", 0)
      is_self = id == $player.id
      $game_temp.vms[:ping_stamp] = pl["heartbeat"] if is_self
      new_packet = pl["heartbeat"] <= player.heartbeat - VMS::ADDED_DELAY
      next if !VMS::HANDLE_MORE_PACKETS && new_packet
      player.update(pl)
      player.is_new = new_packet
      next unless VMS::SHOW_SELF if is_self
      if player.rf_event.nil? || player.rf_event[:event].erased?
        player.rf_event = VMS.create_event(player.map_id, id) if $map_factory.areConnected?(player.map_id, $game_map.map_id)
      elsif $map_factory.areConnected?(player.map_id, $game_map.map_id)
        if player.rf_event[:event].map_id != player.map_id
          Rf.delete_event(player.rf_event) if VMS.event_deletion_possible?(player)
          player.rf_event = VMS.create_event(player.map_id, id)
        end
      else
        Rf.delete_event(player.rf_event) if VMS.event_deletion_possible?(player)
        player.rf_event = nil
      end
      VMS.handle_player(player)
    end
  end

  def self.clear_events
    VMS.get_players.each do |player|
      next unless VMS.event_deletion_possible?(player)
      Rf.delete_event(player.rf_event)
      player.rf_event = nil
    end
  end

  def self.clean_up_events
    return unless $game_map
    $game_map.events.each_value do |event|
      next if event.nil? || event.erased?
      next unless event.name&.include?("vms_player")
      id = event.name.gsub("vms_player_", "").to_i
      player = VMS.get_player(id)
      if player.nil? || !$map_factory.areConnected?(player.map_id, $game_map.map_id)
        event.character_name = ""
        event.through = true
        event.erase
      end
    end
  end

  def self.send_message(message)
    return if $game_temp.vms[:socket].nil?
    message = Zlib::Deflate.deflate(Marshal.dump(message), Zlib::BEST_SPEED)
    $game_temp.vms[:socket].send(message, 0)
  end

  def self.generate_player_data
    party = $player.party.map { |pkmn| VMS.hash_pokemon(pkmn) }
    {
      cluster_id: $game_temp.vms[:cluster] || -1,
      id: $player.id,
      heartbeat: Time.now,
      game_name: System.game_title,
      game_version: Settings::GAME_VERSION,
      online_variables: $game_temp.vms[:online_variables],
      party: party,
      name: $player.name,
      trainer_type: $player.trainer_type,
      map_id: $game_map.map_id,
      x: $game_player.x,
      y: $game_player.y,
      real_x: $game_player.real_x,
      real_y: $game_player.real_y,
      direction: $game_player.direction,
      pattern: $game_player.pattern,
      graphic: $game_player.character_name,
      offset_x: $game_player.x_offset,
      offset_y: $game_player.y_offset,
      opacity: $game_player.opacity,
      stop_animation: $game_player.step_anime,
      animation: ($scene.is_a?(Scene_Map) && $scene.spriteset) ? $scene.spriteset.getAnimationSprites : nil,
      jump_offset: $game_player.screen_y_ground - $game_player.screen_y - $game_player.y_offset,
      jumping_on_spot: $game_player.jumping_on_spot,
      surfing: $PokemonGlobal.surfing,
      diving: $PokemonGlobal.diving,
      surf_base_coords: $game_temp.surf_base_coords || [nil, nil],
      state: $game_temp.vms[:state],
      busy: !VMS.interaction_possible?
    }
  end
end
