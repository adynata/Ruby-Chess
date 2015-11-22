module Steppable
  def get_all_moves(current_position)
    p 'here'
    moves = []
    deltas.each do |delta|
      # debugger
#error message goes here
      possible = translate_from_deltas(current_position, delta)
      # p possible
      if valid_move?(possible)
        p 'valid_move?'
        # || is_on_board_and_collided?(possible)
        moves << possible
      end
    end
    p moves
    moves
    # prune_same_colors(moves)
  end
end
