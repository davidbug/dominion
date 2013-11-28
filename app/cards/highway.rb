class Highway < Card

  def starting_count(game)
    10
  end

  def cost(game, turn)
    {
      coin: 5
    }
  end

  def type
    [:action]
  end

  def play(game, clone=false)
    card_drawer = CardDrawer.new(game.current_player)
    card_drawer.draw(1)
    game.current_turn.add_actions(1)
    game.current_turn.add_global_discount(1) unless clone
    @log_updater.get_from_card(game.current_player, '+1 action')
  end

end
