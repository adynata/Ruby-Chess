class EmptySquare
  attr_reader :color

  def initialize
    @color = false
  end


  def to_view
    "   "
  end

  def all_moves
    []
  end
end
