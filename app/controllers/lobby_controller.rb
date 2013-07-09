class LobbyController < ApplicationController
  include Tubesock::Hijack, Websockets::Lobby::Propose, Websockets::Lobby::Accept, Websockets::Lobby::Decline

  skip_before_filter :unset_lobby_status
  before_filter :authenticate_player!

  def update
    set_lobby_status
    hijack do |tubesock|
      ApplicationController.lobby[current_player.id] = tubesock
      tubesock.onopen do
        refresh_lobby
      end
      tubesock.onmessage do |data|
        unless data == 'tubesock-ping'
          data = JSON.parse data
          if data['action'] == 'propose'
            propose_game(data)
          elsif data['action'] == 'accept'
            accept_game(data)
          elsif data['action'] == 'decline'
            decline_game(data)
          end
        end
      end
    end
  end

end
