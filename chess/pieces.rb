# require_relative 'board'

class EmptySquare
  def initialize
  end

  def to_view
    "   "
  end
end

class Piece
  attr_accessor :color, :board, :current_position
  def initialize(color, board)
    @color = color
    @board = board
    @current_position = [0, 0]
  end

  def get_all_moves
    puts "Hasn't been defined yet"
  end

  def valid_move?(pos)
    board.move_valid?(pos)
  end
end

module Slideable

  def get_all_moves
    moves = []
    deltas.each do |move|
      # raise "Invalid delta" if move.nil?
      possible = [current_position, move].transpose.map {|x| x.reduce(:+)}

      while valid_move?(possible)
        moves << possible
        possible = [moves.last, move].transpose.map {|x| x.reduce(:+)}
      end
    end
    moves
  end

end

module Steppable

  def get_all_moves
    moves = []
    deltas.each do |move|
#error message goes here
      possible = [current_position, move].transpose.map {|x| x.reduce(:+)}
      moves << possible if valid_move?(possible)
    end
    moves
  end

end

class Rook < Piece
  ROOK_DELTAS = [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1]
  ]
  include Slideable
  def deltas
    ROOK_DELTAS
  end

  def to_view
    " ♖ "
  end

end

class Bishop < Piece
  include Slideable

  BISHOP_DELTAS = [
    [1, 1],
    [-1, 1],
    [-1, -1],
    [1, -1]
  ]
  def deltas
    BISHOP_DELTAS
  end

  def to_view
    " ♗ "
  end

end

class Queen < Piece
  include Slideable
  QUEEN_DELTAS = [
    [1, 1],
    [-1, 1],
    [-1, -1],
    [1, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1]
  ]

  def deltas
    QUEEN_DELTAS
  end

  def to_view
    " ♕ "
  end


end

class King < Piece
  include Steppable

  KING_DELTAS = [
    [1, 1],
    [-1, 1],
    [-1, -1],
    [1, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1]
  ]

  def deltas
    KING_DELTAS
  end

  def to_view
    " ♔ "
  end
end

class Knight < Piece
  include Steppable

  KNIGHT_DELTAS =  [
    [1, 2],
    [2, 1],
    [-1, -2],
    [-2, -1],
    [-1, 2],
    [-2, 1],
    [1, -2],
    [2, -1]
  ]
  def to_view
    " ♘ "
  end

  def deltas
    KNIGHT_DELTAS
  end

end

# module Rookable

#
# end
#
# module Bishopable

# end
