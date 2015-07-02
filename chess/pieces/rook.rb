require_relative 'slideable'
require_relative 'pieces'

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
    determine_color(" ♖ ")
  end

end
