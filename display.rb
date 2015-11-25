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
      raise InvalidMove unless good_selection?(potential_move, player_color)
      @board.move_in_process = !@board.move_in_process
      @board.selected_piece = potential_move
    end
    @cursor = potential_move
  end

  def good_selection?(potential_move, player_color)
    if !@board.move_in_process
      @board.is_piece?(potential_move) && player_color == @board[*potential_move].color
    else
      moves_around_piece(@board.selected_piece).include?(potential_move)
    end
  end

  def render(current_player)
    system "clear"
    if @board.move_in_process
      render_around_piece(@board.selected_piece, current_player)
      puts @notifications
      @notifications.each do |key, val|
        puts "         #{val}"
      end
    else
      render_around_piece(@cursor, current_player)
      puts @notifications
      @notifications.each do |key, val|
        puts "         #{val}"
      end
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
