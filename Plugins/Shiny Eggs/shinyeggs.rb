#===============================================================================
# Plugin: Shiny Egg Icons & Summary Display
# Author: Goose
# Essentials Version: 21.1
#===============================================================================

module GameData
  class Species
    class << self
      alias shinyegg_icon_filename_from_pokemon icon_filename_from_pokemon unless method_defined?(:shinyegg_icon_filename_from_pokemon)

      def icon_filename_from_pokemon(pkmn)
        return shinyegg_icon_filename_from_pokemon(pkmn) unless pkmn&.egg?
        return pkmn.shiny? ? "Graphics/Pokemon/Eggs/000shiny_icon" : "Graphics/Pokemon/Eggs/000_icon"
      end
    end
  end
end

#===============================================================================
# Shiny Egg Summary Sprite and Icon Display Fix
# Pokémon Essentials v21.1 Compatible
#===============================================================================
class PokemonSprite < Sprite
  alias shinyegg_setPokemonBitmap setPokemonBitmap unless method_defined?(:shinyegg_setPokemonBitmap)

  def setPokemonBitmap(pkmn, back = false)
    if pkmn&.egg?
      path = pkmn.shiny? ? "Graphics/Pokemon/Eggs/000Shiny.png" : "Graphics/Pokemon/Eggs/000.png"
      if File.exist?(path)
        self.bitmap&.dispose
        self.bitmap = Bitmap.new(path)
        self.mirror = false
        # Offset position to fit better in summary screen
        self.x -= 50   # move left
        self.y -= 50   # move up
        return
      else
        echoln "[ShinyEggs] Missing summary image: #{path}"
      end
    end
    shinyegg_setPokemonBitmap(pkmn, back)
  end
end