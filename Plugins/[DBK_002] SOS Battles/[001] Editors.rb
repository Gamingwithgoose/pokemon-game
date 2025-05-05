#===============================================================================
# Fix for SOS Battles Plugin - Enable random forms in debug SOS encounters
#===============================================================================
MenuHandlers.add(:battle_debug_menu, :add_new_foe, {
  "name"        => _INTL("Add new foe"),
  "parent"      => :battlers,
  "description" => _INTL("Add or replace a foe on the opposing side."),
  "effect"      => proc { |battle|
    cmd = 0
    cmds = []
    indecies = [1, 3, 5]
    size = battle.pbSideSize(1)
    3.times do |i|
      next if i > size
      idx = indecies[i]
      b = battle.battlers[idx]
      name = (b) ? b.name : "---"
      owner = (!b) ? "" : (b.wild?) ? "(Wild)" :  "(#{battle.pbGetOwnerName(b.index)})"
      cmds.push(_INTL("[{1}] {2} {3}", idx, name, owner))
    end
    loop do
      cmd = pbMessage("\ts[]" + _INTL("Choose an index for the new foe."), cmds, -1, nil, cmd)
      break if cmd < 0
      if battle.trainerBattle?
        trainerdata = pbListScreen(_INTL("CHOOSE A TRAINER"), TrainerBattleLister.new(0, false))
        break if !trainerdata
        slot = cmd + 1
        if size < 3 && slot > size 
          battle.sideSizes[1] = slot
        end
        trainer = pbLoadTrainer(trainerdata[0], trainerdata[1], trainerdata[2])
        EventHandlers.trigger(:on_trainer_load, trainer)
        idxTrainer = cmd
        idxTrainer = cmd - 1 if !battle.opponent[cmd - 1]
        battle.opponent[idxTrainer] = trainer
        battle.items[idxTrainer] = trainer.items
        pokemon = trainer.party.first
        idxBattler = indecies[cmd]
        fullUpdate = battle.battlers[idxBattler].nil?
        battle.pbInitializeNewBattler([idxBattler, pokemon], [idxTrainer, trainer], fullUpdate)
        battle.scene.pbQuickJoin(idxBattler, idxTrainer)
        owner = "(#{trainer.full_name})"
      else
        species = pbChooseSpeciesList
        break if !species
        speciesName = GameData::Species.get(species).name
        params = ChooseNumberParams.new
        params.setRange(1, GameData::GrowthRate.max_level)
        params.setDefaultValue(5)
        level = pbMessageChooseNumber(
          "\ts[]" + _INTL("Set {1}'s level (max. {2}).", speciesName, params.maxNumber), params
        )
        break if !level
        slot = cmd + 1
        size = battle.pbSideSize(1)
        if size < 3 && slot > size 
          battle.sideSizes[1] = slot
        end

        # Generate Pokémon and assign a random form
        pokemon = pbGenerateWildPokemon(species, level)
        form_data = GameData::Species.each(pokemon.species).select do |s|
          !s.form_name.empty?
        end
        form_pool = form_data.map(&:form)
        form_pool << 0 if !form_pool.include?(0)  # Ensure base form is included
        pokemon.form = form_pool.sample if form_pool.length > 0

        idxBattler = indecies[cmd]
        fullUpdate = battle.battlers[idxBattler].nil?
        battle.pbInitializeNewBattler([idxBattler, pokemon], [], fullUpdate)
        battle.scene.pbQuickJoin(idxBattler)
        owner = "(Wild)"
      end
      cmds.push(_INTL("[{1}] ---", indecies.last)) if slot == 2 && cmds.length < 3
      cmds[cmd] = _INTL("[{1}] {2} {3}", idxBattler, pokemon.name, owner)
    end
  }
})
