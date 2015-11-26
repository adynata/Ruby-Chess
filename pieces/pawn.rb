require_relative 'pieces'

class Pawn < Piece
  attr_accessor :moved

  def initialize(color, board, pos)
    super
    @moved = false
  end

  def to_view
    determine_color(" ♟ ")
  end


  def all_moves
    # puts "get all moves"
    mover = color == :white ? -1 : 1
    # return [[5,4]]
    # front_check(current_position, mover)
    front_check(mover) + wing_check(mover)
  end

  def front_check(mover)
    moves = []
    move = [pos[0] + mover, pos[1]]
    unless !board.on_board?(move) || board.is_piece?(move)
      moves << move
      moves << [pos[0] + mover * 2, pos[1]] unless moved
    end
    moves
  end

  def wing_check(mover)
    moves = [[pos[0] + mover, pos[1] - 1], [pos[0] + mover, pos[1] + 1]]
    moves.select do |move|
      is_on_board_and_collided?(move) &&
      board[*move].color == opposite_color
    end
  end
end
