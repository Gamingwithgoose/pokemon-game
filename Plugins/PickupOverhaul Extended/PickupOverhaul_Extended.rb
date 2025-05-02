#===============================================================================
# Battle Pickup Advanced (for Essentials 21.1)
#===============================================================================
PluginManager.register({
  :name    => "Battle Pickup Advanced",
  :version => "1.3",
  :credits => ["Goose"]
})

#-------------------------------------------------------------------------------
# Function: Get Pickup Item Based on Pokémon Level
#-------------------------------------------------------------------------------
def get_pickup_item(pokemon)
  lvl = pokemon.level
  pool = []
  
  if lvl <= 10
    pool = [:POTION, :ANTIDOTE, :PARLYZHEAL, :AWAKENING]
  elsif lvl <= 20
    pool = [:SUPERPOTION, :GREATBALL, :ESCAPEROPE, :REPEL]
  elsif lvl <= 40
    pool = [:HYPERPOTION, :ULTRABALL, :REVIVE, :FIRESTONE, :WATERSTONE, :THUNDERSTONE, :LEAFSTONE]
  elsif lvl <= 60
    pool = [:FULLRESTORE, :FULLHEAL, :RARECANDY, :DUSKSTONE, :DAWNSTONE, :SHINYSTONE, :SUNSTONE, :MOONSTONE]
  else # lvl 61+
    pool = [:FULLRESTORE, :RARECANDY, :LEFTOVERS, :CHOICEBAND, :PPUP]
    pool += [:MASTERBALL] if rand(100) < 5   # 5% chance Master Ball
  end

  return pool.sample
end

#-------------------------------------------------------------------------------
# Extend Battle class (not module)
#-------------------------------------------------------------------------------
class Battle
  alias pickup_end_of_battle pbEndOfBattle

  def pbEndOfBattle(*args)
    ret = pickup_end_of_battle(*args)   # Original method first
    $player.party.each do |pkmn|
      next if !pkmn || pkmn.egg? || pkmn.hp <= 0
      next if !pkmn.hasAbility?(:PICKUP)
      next if rand(10) > 0  # 10% chance base

      item = get_pickup_item(pkmn)
      next if !item
      if $bag.add(item)
        pbMessage(_INTL("\\me[Item get]{1} picked up a {2} after the battle!", pkmn.name, GameData::Item.get(item).name))
      end
    end
    return ret
  end
end
