require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @players = [Player.new, Player.new]
    @pieces = []
  end


  def play
    until game_won?
      play_turn
    end

  end

  def play_turn
    board.render
    board.move_cursor
  end

  def game_won?
    false
  end

end

Game.new.play
