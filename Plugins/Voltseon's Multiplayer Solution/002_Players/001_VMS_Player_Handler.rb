module VMS
  # Usage: VMS.interact_with_player(id #<Integer>) (interacts with the specified player)
  def self.interact_with_player(id)
    return unless VMS.is_connected? # Not connected
    # Get player
    player = VMS.get_player(id)
    return if player.nil? # Player doesn't exist
    player_name = player.name
    # Check state
    case player.state[0]
    when :idle
      VMS.send_interaction(player)
    when :interact_receive
      if player.state[1] == $player.id # Other player is interacting with us
        VMS.send_interaction(player)
      else # The other player is interacting with someone else
        VMS.message(_INTL(VMS::ALREADY_INTERACTING_MESSAGE, player_name))
      end
    when :interact_send
      if player.state[1] == $player.id # Other player is interacting with us
        VMS.check_interaction(player)
      else # The other player is interacting with someone else
        VMS.message(_INTL(VMS::ALREADY_INTERACTING_MESSAGE, player_name))
      end
    when :battle
      VMS.message(_INTL(VMS::IN_A_BATTLE_MESSAGE, player_name))
    when :trade
      VMS.message(_INTL(VMS::IN_A_TRADE_MESSAGE, player_name))
    end
  end

  # ... All other methods stay unchanged until handle_player ...

  # Usage: VMS.handle_player(player #<VMS::Player>) (handles the specified player)
  def self.handle_player(player)
    # Update party
    VMS.update_party(player)
    # Sync animations
    VMS.sync_animations(player) if player.is_new
    # No event
    return if player.rf_event.nil?
    event = player.rf_event[:event]

    # === Base player updates ===
    event.x = player.x
    event.y = player.y
    event.direction = player.direction
    event.pattern = player.pattern
    event.character_name = player.graphic
    event.opacity = player.opacity
    event.step_anime = player.stop_animation
    event.through = VMS::THROUGH
    event.jumping_on_spot = player.jumping_on_spot
    event.x_offset = player.offset_x
    event.y_offset = player.offset_y - player.jump_offset

    # === Follower display ===
    if player.follower && player.follower[:species]
      species = player.follower[:species].to_s
      folder = player.follower[:shiny] ? "Followers shiny" : "Followers"
      path = "Graphics/Characters/#{folder}/#{species}"

      if File.exist?("#{path}.png")
        if !event.instance_variable_defined?(:@follower_sprite)
          sprite = Sprite.new
          sprite.bitmap = Bitmap.new("#{path}.png")
          sprite.z = event.screen_z(nil) - 1
          event.instance_variable_set(:@follower_sprite, sprite)
        end

        follower_sprite = event.instance_variable_get(:@follower_sprite)
        follower_sprite.x = event.screen_x - 32
        follower_sprite.y = event.screen_y
        follower_sprite.visible = true
      end
    else
      if event.instance_variable_defined?(:@follower_sprite)
        sprite = event.instance_variable_get(:@follower_sprite)
        sprite.dispose
        event.remove_instance_variable(:@follower_sprite)
      end
    end

    # === Smooth the event's movement ===
    real_distance = Math.sqrt((event.real_x - player.real_x)**2 + (event.real_y - player.real_y)**2)
    if VMS::SMOOTH_MOVEMENT && real_distance < VMS::SNAP_DISTANCE
      event.real_x = Math.lerp(event.real_x, player.real_x, VMS::SMOOTH_MOVEMENT_ACCURACY)
      event.real_y = Math.lerp(event.real_y, player.real_y, VMS::SMOOTH_MOVEMENT_ACCURACY)
    else
      event.real_x = player.real_x
      event.real_y = player.real_y
    end

    # === Hide if out of range ===
    distance = $map_factory.getRelativePos($game_map.map_id, $game_player.x, $game_player.y, player.map_id, player.x, player.y)
    distanceNorm = Math.sqrt(distance[0] ** 2 + distance[1] ** 2)
    if distance[0].abs > VMS::CULL_DISTANCE || distance[1].abs > VMS::CULL_DISTANCE || distanceNorm > VMS::CULL_DISTANCE
      event.opacity = 0
    end

    event.calculate_bush_depth
    event.refresh
  end
end
