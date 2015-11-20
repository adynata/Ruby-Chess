require_relative 'pieces'

class Pawn < Piece
  attr_accessor :moved

  def initialize(color, board)
    super
    @moved = false
  end

  def to_view
    determine_color(" ♙ ")
  end

  def get_all_moves(current_position)
    mover = color == :w ? -1 : 1
    front_check(current_position, mover) + wing_check(current_position, mover)
  end

  def front_check(pos, mover)
    moves = []
    move = [pos[0] + mover, pos[1]]
    unless !board.on_board?(move) || board.is_piece?(move)
      moves << move
      moves << [pos[0] + mover * 2, pos[1]] unless moved
    end
    moves
  end

  def wing_check(pos, mover)
    moves = [[pos[0] + mover, pos[1] - 1], [pos[0] + mover, pos[1] + 1]]
    moves.select do |move|
      is_on_board_and_collided?(move) &&
      board[*move].color == opposite_color
    end
  end
end
