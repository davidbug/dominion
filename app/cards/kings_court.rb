class KingsCourt < Card

  def starting_count(game)
    10
  end

  def cost(game, turn)
    {
      coin: 7
    }
  end

  def type
    [:action]
  end

  def play(game, clone=false)
    @play_thread = Thread.new {
      ActiveRecord::Base.connection_pool.with_connection do
        prompt_player_response(game)
      end
    }
  end

  def process_action(game, game_player, action)
    play_card_multiple_times(game, game_player, PlayerCard.find(action.response), 3) unless action.response.empty?
  end

  private

  def prompt_player_response(game)
    actions = game.current_player.hand.select(&:action?)
    if actions.count == 0
      @log_updater.custom_message(game.current_player, 'no actions to play', 'have')
    else
      action = TurnActionHandler.send_choose_cards_prompt(game, game.current_player, actions, 'You may choose an action to play three times:', 1, 0)
      TurnActionHandler.process_player_response(game, game.current_player, action, self)
    end
  end

end
