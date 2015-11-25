require_relative 'board'
require_relative 'player'
require_relative 'display'

require 'byebug'



class Game
  attr_accessor :board, :notifications, :display

  def initialize
    @board = Board.new
    @players = [Player.new(:white), Player.new(:black)]
    @display = Display.new(@board)
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
      valid_moves = display.moves_around_piece(start_pos)
      end_pos = board.selected_piece
      until valid_moves.include?(end_pos)
        get_end_pos
        end_pos = board.selected_piece
        if end_pos == start_pos

        end
      end
      board.move(current_player.color, start_pos, end_pos)
    rescue StandardError => e
      @display.notifications[:error] = e.message
      retry
    end
    @players.rotate!
    notify_players

  end

  def get_start_pos
    begin
      reset!
      until board.move_in_process
        display.render(current_player)
        display.move_cursor(current_player.color)
      end
    rescue InvalidMove
      @display.notifications[:error] = "Invalid move"
      retry
    end
  end

  def get_end_pos
    begin
      while board.move_in_process
        display.render(current_player)
        display.move_cursor(current_player.color)
      end
    rescue InvalidMove
      @display.notifications[:error] = "Hey! That piece can't move there."
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
    display.notifications.delete(:error)
  end

  def uncheck!
    display.notifications.delete(:check)
  end

  def set_check!
    display.notifications[:check] = "Board is in check!"
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
