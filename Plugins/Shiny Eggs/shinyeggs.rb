#===============================================================================
# Shiny Egg Display Plugin for Pokémon Essentials v21.1
# Shows different PNGs for shiny and non-shiny eggs in party and summary screens.
# No icon movement or placement changes.
#===============================================================================

# Override icon loader to swap egg icon if shiny
module GameData
  class Species
    class << self
      alias shinyegg_icon_bitmap_from_pokemon icon_bitmap_from_pokemon unless method_defined?(:shinyegg_icon_bitmap_from_pokemon)

      def icon_bitmap_from_pokemon(pkmn)
        if pkmn&.egg?
          path = pkmn.shiny? ? "Graphics/Pokemon/Eggs/000shiny_icon.png" : "Graphics/Pokemon/Eggs/000_icon.png"
          return Bitmap.new(path) if pbResolveBitmap(path)
          echoln "[ShinyEggs] Missing icon file: #{path}.png"
          return Bitmap.new(64, 64)
        end
        shinyegg_icon_bitmap_from_pokemon(pkmn)
      end
    end
  end
end

# Override summary screen sprite for shiny eggs
class PokemonSummary_Scene
  alias shinyegg_drawPage drawPage
  def drawPage(page)
    shinyegg_drawPage(page)
    return unless @pokemon&.egg?
    path = @pokemon.shiny? ? "Graphics/Pokemon/Eggs/000Shiny.png" : "Graphics/Pokemon/Eggs/000.png"
    if File.exist?(path)
        @sprites["pokemon"].bitmap = Bitmap.new(path)
    else
      echoln "[ShinyEggs] Missing summary sprite: #{path}"
    end
  end
end
