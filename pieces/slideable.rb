module Slideable
  def get_all_moves(current_position)
    # puts "get all moves slideable"
    moves = []
    deltas.each do |delta|
      # raise "Invalid delta" if move.nil?
      possible = translate_from_deltas(current_position, delta)

      # debugger
      if valid_move?(possible)
        # debugger
        moves << possible
        possible = translate_from_deltas(moves.last, delta)
      end
      # debugger
      moves << possible if is_on_board_and_collided?(possible)
    end
    prune_same_colors(moves)
  end
end
