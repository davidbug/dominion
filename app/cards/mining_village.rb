class MiningVillage < Card

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
    CardDrawer.new(game.current_player).draw(1)
    game.current_turn.add_actions(2)
    @log_updater.get_from_card(game.current_player, '+2 actions')
    unless clone
      @play_thread = Thread.new {
        ActiveRecord::Base.connection_pool.with_connection do
          trash_card(game)
        end
      }
    end
  end

  def trash_card(game)
    options = [
      { text: 'Yes', value: 'yes' },
      { text: 'No', value: 'no' }
    ]
    action = TurnActionHandler.send_choose_text_prompt(game, game.current_player, options, "Trash Mining Village?".html_safe, 1, 1)
    TurnActionHandler.process_player_response(game, game.current_player, action, self)
  end

  def process_action(game, game_player, action)
    if action.response == 'yes'
      mining_village = game.current_player.find_card_in_play('mining_village')
      CardTrasher.new(game.current_player, [mining_village]).trash
      game.current_turn.add_coins(2)
      @log_updater.get_from_card(game.current_player, '+$2')
      ActiveRecord::Base.connection.clear_query_cache
      TurnActionHandler.refresh_game_area(game, game_player.player)
    end
  end
end
