#===============================================================================
# Plugin: Shiny Egg Icons & Summary Display
# Author: Goose
# Essentials Version: 21.1
#===============================================================================

class PokemonIconSprite < Sprite
  alias shinyegg_pokemon_eq pokemon=
  def pokemon=(pkmn)
    shinyegg_pokemon_eq(pkmn)
    return if !pkmn

    if pkmn.egg? && pkmn.shiny?
      self.tone = Tone.new(-40, 0, 80)   # Blue tint
    else
      self.tone = Tone.new(0, 0, 0)
    end
  end
end


#===============================================================================
# Shiny Egg Summary Sprite
#===============================================================================

class PokemonSummary_Scene
  alias shinyegg_drawPage drawPage
  def drawPage(page)
    if @sprites["pokemon"] && @pokemon
      @sprites["pokemon"].setPokemonBitmap(@pokemon)

      # Apply a blue tint if the Pokémon is a shiny egg
      if @pokemon.egg? && @pokemon.shiny?
        @sprites["pokemon"].tone = Tone.new(-40, 0, 80)  # bluish tint
      else
        @sprites["pokemon"].tone = Tone.new(0, 0, 0)  # normal
      end
    end

    shinyegg_drawPage(page)
  end
end

#========================================================================
# Box Icon Sprite
#========================================================================

class PokemonBoxIcon < IconSprite
  alias shinyegg_refresh refresh
  def refresh
    shinyegg_refresh
    return unless @pokemon
    if @pokemon.egg? && @pokemon.shiny?
      self.tone = Tone.new(-40, 0, 80)  # Minty-cyan tint
    else
      self.tone = Tone.new(0, 0, 0)
    end
  end
end

#========================================================================
# Box Summary Sprite
#========================================================================

class PokemonStorageScene
  alias shinyegg_overlay_tint pbUpdateOverlay
  def pbUpdateOverlay(selection, party = nil)
    shinyegg_overlay_tint(selection, party)
    # Apply tint to the left-side preview if it's a shiny egg
    sprite = @sprites["pokemon"]
    if sprite && !sprite.disposed? && sprite.visible
      pkmn = nil
      if @screen.pbHeldPokemon
        pkmn = @screen.pbHeldPokemon
      elsif selection >= 0
        pkmn = (party) ? party[selection] : @storage[@storage.currentBox, selection]
      end
      if pkmn&.egg? && pkmn.shiny?
        sprite.tone = Tone.new(-40, 0, 80)
      else
        sprite.tone = Tone.new(0, 0, 0)
      end
    end
  end
end
