module Steppable
  def get_all_moves(current_position)
    moves = []
    deltas.each do |delta|
#error message goes here
      possible = translate_from_deltas(current_position, delta)
      moves << possible if valid_move?(possible) ||
        is_on_board_and_collided?(possible)
    end
    prune_same_colors(moves)
  end
end
