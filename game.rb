require_relative 'board'
require_relative 'player'
require 'byebug'



class Game
  attr_accessor :board, :notifications

  def initialize
    @board = Board.new
    @players = [Player.new(:w), Player.new(:b)]
    @notifications = {}
  end


  def play
    until checkmate?
      play_turn
    end
    puts "#{current_player} is checkmated."
    nil

  end

  def play_turn
    begin
      get_start_pos
      start_pos = board.selected_piece
      valid_moves = board.moves_around_piece(start_pos)
      end_pos = board.selected_piece
      until valid_moves.include?(end_pos)
        get_end_pos
        end_pos = board.selected_piece
      end
      board.move(current_player.color, start_pos, end_pos)
    rescue StandardError => e
      notifications[:error] = e.message
      retry
    end
    @players.rotate!
    notify_players


  end

  def get_start_pos
    begin
      until board.move_in_process
        board.render(@notifications, current_player)
        board.move_cursor(current_player.color)
      end
    rescue InvalidMove
      raise "Invalid move"
      retry
    end
  end

  def get_end_pos
    begin
      while board.move_in_process
        board.render(@notifications, current_player)
        board.move_cursor(@players.first.color)
      end
    rescue InvalidMove
      puts "Hey! That piece can't move there."
      sleep(1)
      retry
    end
  end

  def checkmate?
    @board.checkmate?(current_player)
  end

  def current_player
    @players.first
  end

  def reset!
    @notifications.delete(:error)
  end

  def uncheck!
    @notifications.delete(:check)
  end

  def set_check!
    @notifications[:check] = "Check!"
  end

  def notify_players
  if board.in_check?(current_player.color)
    set_check!
  else
    uncheck!
  end
end

end

Game.new.play
