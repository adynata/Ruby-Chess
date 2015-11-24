module Steppable
  def get_all_moves(current_position)
    # puts 'here steppable'
    moves = []

    # return [[[1,2], [2,3]]]

    deltas.each do |delta|
      possible = translate_from_deltas(current_position, delta)
      if valid_move?(possible, color) || (is_on_board_and_collided?(possible) &&  board[*possible].color == opposite_color)
        # p "opposite_color #{opposite_color}"
        # p board[*possible].color
        # &&
      # board[*possible].color == opposite_color)
        # p possible
        moves << possible
      end
      # moves << possible
#
    end
    # prune_same_colors(moves)
    moves
  end
end
