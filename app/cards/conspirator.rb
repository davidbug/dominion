class Conspirator < Card

  def starting_count(game)
    10
  end

  def cost(game, turn)
    {
      coin: 4
    }
  end

  def type
    [:action]
  end

  def play(game, clone=false)
    game.current_turn.add_coins(2)
    get_message = '+$2'
    actions_in_play = game.current_turn.played_actions
    if actions_in_play > 2
      card_drawer = CardDrawer.new(game.current_player)
      card_drawer.draw(1)
      game.current_turn.add_actions(1)
      get_message += ' and +1 action'
    end
    @log_updater.get_from_card(game.current_player, get_message)
  end

end
