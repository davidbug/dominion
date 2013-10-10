module Adventurer

  def starting_count(game)
    10
  end

  def cost(game, turn)
    {
      coin: 6
    }
  end

  def type
    [:action]
  end

  def play(game, clone=false)
    reveal(game)
    discard_revealed(game)
  end

  private

  def reveal(game)
    @revealed = []
    @treasures = []

    reveal_cards(game, game.current_player)
    @log_updater.reveal(game.current_player, @revealed, 'deck')
  end

  def process_revealed_card(card)
    if card.treasure?
      @treasures << card
      card.update_attribute :state, 'hand'
    else
      card.update_attribute :state, 'revealed'
    end
    @treasures.count == 2
  end

  def discard_revealed(game)
    revealed_cards = game.current_player.player_cards.revealed
    @log_updater.put(game.current_player, @treasures, 'hand', false)
    CardDiscarder.new(game.current_player, revealed_cards).discard
  end

  def reveal_finished?(game, player)
    @treasures.count == 2 || game.current_player.empty_discard?
  end

end
