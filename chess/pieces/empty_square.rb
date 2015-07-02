class EmptySquare
  attr_reader :color

  def initialize
    @color = false
  end


  def to_view
    "   "
  end

  def get_all_moves(current_position)
    []
  end
end
