class MixedGameCard < ActiveRecord::Base
  belongs_to :game_card
  belongs_to :card

  scope :ordered, ->{ order 'card_order' }

  def kingdom?
    card.kingdom?
  end

  def victory?
    card.victory?
  end

  def treasure?
    card.treasure?
  end

  def supply?
    card.supply?
  end

  def treasure_card?
    card.treasure_card?
  end

  def victory_card?
    card.victory_card?
  end

  def attack_card?
    card.attack_card?
  end

  def action_card?
    card.action_card?
  end

  def belongs_to_set?(set)
    card.belongs_to_set?(set)
  end

  def type_class
    card.type_class
  end

  def name
    card.name
  end

  def calculated_cost(game_record, turn)
    card.calculated_cost(game_record, turn)
  end

  def costs_less_than?(coin, potion)
    game = game_card.game
    card_cost = calculated_cost(game, game.current_turn)
    (card_cost[:potion].nil? || card_cost[:potion] <= potion) && card_cost[:coin] < coin
  end

  def costs_same_as?(cost)
    game = game_card.game
    card_cost = calculated_cost(game, game.current_turn)
    card_cost[:potion] == cost[:potion] && card_cost[:coin] == cost[:coin]
  end

end
