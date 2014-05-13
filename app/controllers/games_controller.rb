class GamesController < ApplicationController
    @neighbors = { "101" => ["102", "106", "506"],
                    "102" => ["101", "106", "107", "109"],
                    "103"=> ["104", "109", "204"],
                    "104" => ["103", "108", "107", "109"],
                    "105" => ["106", "107", "108","502"],
                    "106" => ["101", "102", "105", "107"],
                    "107" => ["102", "104", "105", "106", "108", "109"],
                    "108" => ["104", "105", "107"],
                    "109" => ["102", "103", "104", "107"]
                    }
    
    
    def join
    @game = getQueuedGame
    @player = Player.create
    @player.update(game_id: @game.id)
    @game.update(num_players: @game.num_players + 1)
    if (@game.num_players == 1)
      $firstPlayer = @player.id
    end
    unless $lastPlayer.nil?
      $lastPlayer.update(next_player: @player.id )
    end
    @gamechannel = "game-channel-#{@game.id}"

    if (@game.num_players >=3)
      @player.update(next_player: $firstPlayer)
      @game.update(game_state: 0)
      @game.update(turn: $firstPlayer)
      Pusher[@gamechannel].trigger('state', {player_id: @game.turn})
      $queuedGame = $lastPlayer = $firstPlayer = nil;
    else
      Pusher[@gamechannel].trigger('count', {amount:@game.num_players})
    end
    $lastPlayer = @player
  end

  def select
     render nothing: true
     getContext
     if (@player.id == @game.turn)
       @game.update(turn: @player.next_player)
         Pusher[@gamechannel].trigger('state', {player_id:@player.next_player})
        end
  end

    def isNeighbor?(geostate1, geostate2)
        if @neigbors[geostate1.to_s].include?(geostate2.to_s)
            return true
        else
            return false
        end
    end
    
  def getQueuedGame
    if ($queuedGame.nil?)
      $queuedGame = Game.create
      $queuedGame.update(num_players: 0, game_state: -1)
    end
    $queuedGame
  end

  def getContext
     @game = Game.find_by(id: params[:game_id])
     @player = Player.find_by(id: params[:player_id])
     @gamechannel = "game-channel-#{@game.id}"
  end
end
