module Village

  def starting_count(game)
    10
  end

  def cost
    {
      coin: 3
    }
  end

  def type
    [:action]
  end

  def play(game)
    @card_drawer = CardDrawer.new(game.current_player)
    @card_drawer.draw(1)
    game.current_turn.add_actions(2)
  end

  def log(game, player)
    locals = {
      get_text: '+2 actions',
      card_drawer: @card_drawer
    }
    render_play_card game, player, locals
  end
end
