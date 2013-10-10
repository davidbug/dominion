module SeaHag

  def starting_count(game)
    10
  end

  def cost(game, turn)
    {
      coin: 4
    }
  end

  def type
    [:action, :attack]
  end

  def play(game, clone=false)
  end

  def attack(game, players)
    players.each do |player|
      discard_top_card(game, player)
      give_card_to_player(game, player, 'curse', 'deck')
    end
  end

  def discard_top_card(game, player)
    player.shuffle_discard_into_deck if player.needs_reshuffle?
    unless player.empty_deck?
      card = player.player_cards.deck.first
      CardDiscarder.new(player, [card]).discard('deck')
    end
  end

end
