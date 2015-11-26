require_relative 'board'
require_relative 'player'

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
    puts "#{current_player.color} is checkmated."
  end

  def play_turn
    # if !@display.notifications[:message]
    #   reset!
    # end
    begin
      get_start_pos
      start_pos = board.selected_piece
      valid_moves = display.moves_around_piece(start_pos)
      end_pos = board.selected_piece
      until valid_moves.include?(end_pos)
        get_end_pos
        end_pos = board.selected_piece
      end
      if board[*end_pos].color
        current_player.add_to_captured_pieces(board[*end_pos].to_view)
      end
      board.move(current_player.color, start_pos, end_pos)
    rescue InvalidMove => e
      @display.notifications[:message] = e.message
      retry
    end
    @players.rotate!
    notify_players

  end

  def get_start_pos

    reset!
    # reset_check!

    begin
      until board.move_in_process
        display.render(current_player)
        display.show_captured(@players)
        display.show_notifications
        display.move_cursor(current_player.color)
      end
    rescue InvalidSelection
      retry
    end
  end

  def get_end_pos
    reset!
    reset_check!
    begin
      while board.move_in_process
        display.render(current_player)
        display.show_captured(@players)
        display.show_notifications
        display.move_cursor(current_player.color)
      end
    rescue InvalidSelection => e
      @display.notifications[:error] = e.message
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

  def reset_check!
    display.notifications.delete(:message)
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
    # reset_check!
  end

end

Game.new.play
