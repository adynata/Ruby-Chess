require_relative 'slideable'
require_relative 'pieces'

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
    determine_color(" ♛ ")
  end


end
