module Steppable
  def get_all_moves(current_position)
    # p 'here steppable'
    moves = []
    deltas.each do |delta|

      possible = translate_from_deltas(current_position, delta)

      if valid_move?(possible)
        # p 'valid_move'
        # || is_on_board_and_collided?(possible)
        moves << possible
      end

    end

    moves
    # prune_same_colors(moves)
  end
end
