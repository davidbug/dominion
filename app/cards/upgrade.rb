class Upgrade < Card

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
    CardDrawer.new(game.current_player).draw(1)
    game.current_turn.add_actions(1)
    @log_updater.get_from_card(game.current_player, '+1 action')

    hand = game.current_player.hand
    if hand.count == 0
      @log_updater.custom_message(game.current_player, 'nothing to trash', 'have')
    else
      @play_thread = Thread.new {
        ActiveRecord::Base.connection_pool.with_connection do
          action = TurnActionHandler.send_choose_cards_prompt(game, game.current_player, hand, 'Choose a card to trash:', 1, 1, 'trash')
          TurnActionHandler.process_player_response(game, game.current_player, action, self)
          ActiveRecord::Base.connection.clear_query_cache
          TurnActionHandler.refresh_game_area(game, game.current_player.player)
        end
      }
    end
  end

  def process_action(game, game_player, action)
    if action.action == 'trash'
      trashed_card = PlayerCard.find action.response
      cost = trashed_card.calculated_cost(game, game.current_turn)

      CardTrasher.new(game_player, [trashed_card]).trash('hand')
      available_cards = game.cards_equal_to({coin: cost[:coin]+1, potion: cost[:potion]})

      if available_cards.count == 0
        @log_updater.custom_message(nil, 'But there are no available cards to gain')
      elsif available_cards.count == 1
        CardGainer.new(game, game_player, available_cards.first.name).gain_card('discard')
      else
        action = TurnActionHandler.send_choose_cards_prompt(game, game.current_player, available_cards, 'Choose a card to gain:', 1, 1, 'gain')
        TurnActionHandler.process_player_response(game, game.current_player, action, self)
      end
    elsif action.action = 'gain'
      card = GameCard.find action.response
      CardGainer.new(game, game_player, card.name).gain_card('discard')
    end
  end

end
