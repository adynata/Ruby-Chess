require 'colorize'

class Piece
  attr_accessor :color, :board, :opposite_color #, :current_position
  COLORS = [:w, :b]

  def initialize(color, board)
    @color = color
    @board = board
    @opposite_color = COLORS[COLORS.index(@color) - 1]
    # @current_position = [3, 3] only comes from board
  end

  def get_all_moves(current_position)
    raise NotImplementedError
    # puts "Hasn't been defined yet"
  end

  def valid_move?(pos)
    board.valid_move?(pos)
    board.in_check?(color)
  end

  def determine_color(el)
    color == :w ? el :  el.colorize(:black)
  end

  def prune_same_colors(moves)
    moves.select do |coord|
      @board[*coord].color == opposite_color || !@board[*coord].color #references emptysquare
    end
  end

  def is_on_board_and_collided?(positions)
    board.on_board?(positions) && board.is_piece?(positions)
  end

  def translate_from_deltas(current_position, delta)
    [current_position, delta].transpose.map {|x| x.reduce(:+)}
  end
end
