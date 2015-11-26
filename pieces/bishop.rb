require_relative 'slideable'
require_relative 'pieces'

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
    determine_color(" ♝ ")
  end

end
