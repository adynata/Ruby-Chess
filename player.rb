require_relative 'display'

class Player
  attr_reader :color
  attr_accessor :captured_pieces

  def initialize(color)
    @color = color
    @captured_pieces = []
  end

  def add_to_captured_pieces(piece)
    @captured_pieces << piece
  end

end
