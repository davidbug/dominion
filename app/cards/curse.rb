class Curse < Card

  def starting_count(game)
    case game.player_count
    when 1
      10
    when 2
      10
    when 3
      20
    when 4
      30
    end
  end

  def cost(game, turn)
    {
      coin: 0
    }
  end

  def type
    [:curse]
  end

  def value(deck)
    -1
  end

  def results(player)
    card_html
  end
end
