require "colorize"
require_relative "keypress"

class Display
  include Readable

  attr_accessor :board, :notifications

  MOVE_MAP = {
    "DOWN ARROW" => [1, 0],
    "RIGHT ARROW" => [0, 1],
    "UP ARROW" => [-1, 0],
    "LEFT ARROW" => [0, -1],
    "RETURN" => [0, 0]
  }

  def initialize(board)
    @board = board
    @cursor = [7, 0]
    @notifications = {}
  end

  def move_cursor(player_color)
    potential_move = get_move
    until @board.on_board?(potential_move)
      potential_move = get_move
    end
    if @cursor == potential_move
      if good_selection?(potential_move, player_color)
        @board.move_in_process = !@board.move_in_process
        @board.selected_piece = potential_move
      end
    end
    @cursor = potential_move
  end

  def good_selection?(potential_move, player_color)
    if !@board.move_in_process
      if !@board.is_piece?(potential_move)
        @notifications[:error] = "You cannot select an empty place"
        return false
      elsif player_color != @board[*potential_move].color
        @notifications[:error] = "You can only move a #{player_color} piece"
        return false
      elsif @board[*potential_move].all_moves.empty?
        @notifications[:error] = "That piece has no moves available"
        return false
      else
        return true
      end
    else
      if !moves_around_piece(@board.selected_piece).include?(potential_move)
        raise InvalidMove, "That's not a place you can move to. Please try again"
      else
        return true
      end
    end
  end

  def show_captured(players)
    players.each do |player|
      puts
      puts "   #{player.color} has captured: #{player.captured_pieces.join("  ")}"
    end
  end

  def show_notifications
    puts
    @notifications.each do |key, val|
      puts "         #{val}"
    end
  end

  def render(current_player)
    system "clear"
    if @board.move_in_process
      render_around_piece(@board.selected_piece, current_player)
    else
      render_around_piece(@cursor, current_player)
    end
  end

  def render_around_piece(piece, current_player)
    puts
    puts  "         current player is: #{current_player.color}"
    puts
    @board.grid.each_with_index do |row, idx1|
      print "         "
      row.each_with_index do |square, idx2|
        if piece != @cursor && @cursor == [idx1, idx2]
          print square.to_view.colorize(background: :light_black)
        elsif piece == [idx1, idx2]
          print square.to_view.colorize(background: :light_black)
          # debugger
        elsif moves_around_piece(piece).include?([idx1, idx2]) && (@board[*piece].color == current_player.color)
          print square.to_view.colorize(background: :light_yellow)
        elsif (idx1 + idx2).even?
          print square.to_view.colorize(background: :cyan)
        else
          print square.to_view.colorize(background: :light_red)
        end
      end
      puts

    end
  end

  def moves_around_piece(position)
    moves = @board[*position].all_moves
  end

  def get_move
    next_move = show_single_key
    cursor_diff = MOVE_MAP[next_move]
    [@cursor, cursor_diff].transpose.map {|x| x.reduce(:+)}
  end


end
