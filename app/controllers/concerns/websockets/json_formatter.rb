module Websockets::JsonFormatter

  def player_in_game_json(players)
    {
      action: 'player_in_game_error',
      players: players
    }.to_json
  end

  def game_proposal_json(game, player)
    {
      action: 'propose',
      players: game.players,
      cards: game_cards(game, 'kingdom'),
      proposer: current_player,
      is_proposer: is_current_player?(player),
      game_id: game.id
    }.to_json
  end

  def refresh_game_json(game)
    {
      action: 'refresh',
      kingdom_cards: game_cards(game, 'kingdom'),
      victory_cards: game_cards(game, 'victory'),
      treasure_cards: game_cards(game, 'treasure'),
      miscellaneous_cards: [game.curse_card.json]
    }.to_json
  end

  def decline_game_json(player)
    {
      action: 'decline',
      decliner: current_player,
      is_decliner: is_current_player?(player)
    }.to_json
  end

  def timeout_json(players)
    {
      action: 'timeout',
      players: players
    }.to_json
  end

  def accepted_json(game)
    {
      action: 'accepted_game',
      game_id: game.id
    }.to_json
  end

  def accept_received_json
    {
      action: 'accept_received'
    }.to_json
  end

  def player_count_error_json
    {
      action: 'player_count_error'
    }.to_json
  end

  def refresh_lobby_json(players)
    {
      action: 'refresh',
      players: players
    }.to_json
  end

  private

  def is_current_player?(player)
    current_player.id == player.id
  end

  def game_cards(game, type)
    sort_cards(game.send("#{type}_cards")).collect(&:json)
  end

  def sort_cards(cards)
    cards.sort{ |a, b| b.cost[:coin] <=> a.cost[:coin] }
  end

end