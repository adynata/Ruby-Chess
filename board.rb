require_relative 'pieces/piece_junction'
require_relative 'keypress'

# require 'colorize'

class InvalidMove < StandardError
end

class Board
  # attr_reader
  attr_accessor :cursor, :move_in_process, :selected_piece, :grid

  include Readable

  MOVE_MAP = {
    "DOWN ARROW" => [1, 0],
    "RIGHT ARROW" => [0, 1],
    "UP ARROW" => [-1, 0],
    "LEFT ARROW" => [0, -1],
    "RETURN" => [0, 0]
  }

  def initialize(fill_board = true)
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    @cursor = [7, 0]
    @move_in_process = false
    populate_board if fill_board
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, mark)
    @grid[row][col] = mark
  end


  def populate_board
    p "populating board"
    grid[0] = populate_royalty(:b, 0)
    grid[1] = populate_pawns(:b, 1)
    grid[6] = populate_pawns(:w, 6)
    grid[7] = populate_royalty(:w, 7)
  end

  def populate_royalty(color, row)
    [
      Rook.new(color, self, [row, 0]),
      Knight.new(color, self, [row, 1]),
      Bishop.new(color, self, [row, 2]),
      Queen.new(color, self, [row, 3]),
      King.new(color, self, [row, 4]),
      Bishop.new(color, self, [row, 5]),
      Knight.new(color, self, [row, 6]),
      Rook.new(color, self, [row, 7])
    ]
  end

  def populate_pawns(color, row)
    arr = []
    0.upto(7) do |col|
      arr << Pawn.new(color, self, [row, col])
    end

    arr
    # Array.new(8) { Pawn.new(color, self) }
  end

  def move_cursor(player_color)
    # system "clear"
    # set_cursor_to_default
    potential_move = get_move
    # debugger
    until on_board?(potential_move)
      potential_move = get_move
    end
    if @cursor == potential_move
      raise InvalidMove unless good_selection?(potential_move, player_color)
      @move_in_process = !@move_in_process
      @selected_piece = potential_move
    end
    @cursor = potential_move
  end

  def good_selection?(potential_move, player_color)
    if !@move_in_process
      is_piece?(potential_move) && player_color == self[*potential_move].color
    else
      moves_around_piece(@selected_piece).include?(potential_move)
    end
  end

  def move_back(original_position, new_position, end_piece)
    piece = self[*new_position]
    self[*new_position] = end_piece
    self[*original_position] = piece
  end

  def move(start_pos, end_pos)
    piece = self[*start_pos]
    color = piece.color
    # opposite_color = piece.opposite_color
    end_piece = self[*end_pos]
    self[*start_pos] = EmptySquare.new
    self[*end_pos] = piece

    if in_check?(color)
      move_back(start_pos, end_pos, end_piece)
      raise InvalidMove
      #rotate players again
    end

    if piece.is_a?(Pawn)
      piece.moved = true
    end
  end

  def find_king(color)
    # debugger
    grid.each_with_index do |row, idx1|
      row.each_with_index do |space, idx2|
        return [idx1, idx2] if space.is_a?(King) && space.color == color
      end
    end
    raise 'no king on board :('
  end

  def in_check?(color)
    # p "in check?"
    king_pos = find_king(color)

    # debugger

    pieces.any? do |p|
      # p.color != color &&
      # debugger
      p.get_all_moves(p.pos).include?(king_pos)
    end
    puts "through loop"
    # grid.each do |row|
    #   # p row
    #   row.each do |piece|
    #     p "piece = #{piece}"
    #     if piece.get_all_moves(piece.pos).include?(king_pos)
    #       puts "#{color}: you're in check"
    #       return true
    #     end
    #   end
    # end
    true
  end

  def on_board?(potential_move)
    # p potential_move
    potential_move.all? { |pos| pos.between?(0, 7) }
  end

  def valid_move?(potential_move, color)
    # p 'board valid move'
    # debugger
    on_board?(potential_move) && !is_piece?(potential_move) && !dup.in_check?(color)
  end

  def pieces
    grid.flatten.reject { |piece| piece.color == false }
  end

  def dup
    new_board = Board.new(false)
    new_board.grid = grid
    new_board
    # dup.grid = grid
  end

  def is_piece?(position)
    !self[*position].is_a?(EmptySquare)
  end

  def get_move
    next_move = show_single_key
    cursor_diff = MOVE_MAP[next_move]
    [cursor, cursor_diff].transpose.map {|x| x.reduce(:+)}
  end

  def render
    system "clear"
    if move_in_process
      render_around_piece(selected_piece)
    else
      render_around_piece(cursor)
    end
  end

def render_around_piece(piece)
  grid.each_with_index do |row, idx1|
    row.each_with_index do |square, idx2|
      if piece != cursor && cursor == [idx1, idx2]
        print square.to_view.colorize(background: :red)
      elsif piece == [idx1, idx2]
        print square.to_view.colorize(background: :magenta)
        # debugger
      elsif moves_around_piece(piece).include?([idx1, idx2])
        # p '2nd elsif'
        print square.to_view.colorize(background: :green)
      elsif (idx1 + idx2).even?
        print square.to_view.colorize(background: :blue)
      else
        print square.to_view.colorize(background: :yellow)
      end
    end
    puts
  end
end



  def moves_around_piece(position)
    self[*position].get_all_moves(position).flatten(1)
  end
end
#
# p Knight.new(:white, Board.new).get_all_moves
# p King.new(:white, Board.new).get_all_moves
