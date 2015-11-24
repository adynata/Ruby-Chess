require 'colorize'

class Piece
  attr_accessor :color, :board, :opposite_color, :pos #, :current_position
  COLORS = [:w, :b]

  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
    @opposite_color = COLORS[COLORS.index(@color) - 1]
    # @current_position = [3, 3] only comes from board
  end

  def get_all_moves(current_position)
    raise NotImplementedError
    # puts "Hasn't been defined yet"
  end

  def valid_move?(position, color)
    board.valid_move?(position, color)
    # && !board.dup.in_check?(color)
  end

  def determine_color(el)
    color == :w ? el :  el.colorize(:black)
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
