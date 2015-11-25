require_relative 'steppable'
require_relative 'pieces'

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
    determine_color(" ♚ ")
  end
end
