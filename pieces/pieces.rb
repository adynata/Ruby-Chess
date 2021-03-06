require 'colorize'

class Piece
  attr_accessor :color, :board, :opposite_color, :pos #, :current_position
  COLORS = [:white, :black]

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @opposite_color = COLORS[COLORS.index(@color) - 1]
    # @current_position = [3, 3] only comes from board
  end

  def all_moves
    raise NotImplementedError
  end

  def valid_moves
    all_moves.reject { |to_pos| move_into_check?(to_pos) }
  end

  def valid_move?(position, color)
    # puts "piece valid move"
    board.valid_move?(position, color)
    # && !board.dup.in_check?(color)
  end

  def move_into_check?(to_pos)
    test_board = board.dup
    test_board.move_piece!(pos, to_pos)
    test_board.in_check?(color)
  end

  def determine_color(el)
    color == :white ? el.colorize(:white) :  el.colorize(:black)
  end

  def prune_same_colors(moves)
    p moves
    moves.select do |coord|
      p coord
      p @board.grid[1][2].color
      # debugger
      # p opposite_color
      # p color
      # p idx1 = coord[0]
      # p idx2 = coord[1]
      # p @board.grid[idx1][idx2]
      if @board.grid[coord[0]][coord[1]]
        @board.grid[*coord[0]][*coord[1]] == opposite_color || !@board.grid[*coord[0]][*coord[1]]
      end
      # p coord #references emptysquare
    end
  end

  def is_on_board_and_collided?(positions)
    board.on_board?(positions) && board.is_piece?(positions)
  end

  def translate_from_deltas(current_position, delta)
    [current_position, delta].transpose.map {|x| x.reduce(:+)}
  end
end
