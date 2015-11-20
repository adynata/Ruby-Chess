require_relative 'steppable'
require_relative 'pieces'

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
    determine_color(" ♘ ")
  end

  def deltas
    KNIGHT_DELTAS
  end

end
