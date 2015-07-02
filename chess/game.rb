require_relative 'board'
require_relative 'player'
require 'byebug'



class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @players = [Player.new(:w), Player.new(:b)]
  end


  def play
    until game_won?
      play_turn
    end

  end

  def play_turn
    begin
      get_start_pos
      start_pos = board.selected_piece
      valid_moves = board.moves_around_piece(start_pos)
      # get_end_pos
      end_pos = board.selected_piece
      until valid_moves.include?(end_pos)
        get_end_pos
        end_pos = board.selected_piece
      end

      board.move(start_pos, end_pos)
    rescue InvalidMove
      puts "Check"
      retry
    end
    @players.rotate!


  end

  def get_start_pos
    begin
      until board.move_in_process
        board.render
        board.move_cursor(current_player.color)
      end
    rescue InvalidMove
      puts "Hey! That's not a piece."
      sleep(1)
      retry
    end
  end

  def get_end_pos
    begin
      while board.move_in_process
        board.render
        board.move_cursor(@players.first.color)
      end
    rescue InvalidMove
      puts "Hey! That piece can't move there."
      sleep(1)
      retry
    end
  end

  def game_won?
    false
  end

  def current_player
    @players.first
  end

end

Game.new.play
