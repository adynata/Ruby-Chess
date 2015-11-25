module Slideable




  def all_moves
    # puts "get all moves slideable"
    moves = []
    deltas.each do |delta|
      # raise "Invalid delta" if move.nil?
      possible = translate_from_deltas(pos, delta)
      # p valid_move?(possible, color)

      while valid_move?(possible, color) ||
        (is_on_board_and_collided?(possible) &&  board[*possible].color == opposite_color) do
          # debugger
        moves << possible
        break if is_on_board_and_collided?(possible) &&  board[*possible].color == opposite_color
        active_position = possible
        possible = translate_from_deltas(active_position, delta)
      end
      # debugger
      # moves << possible if is_on_board_and_collided?(possible)
    end

    moves
    # prune_same_colors(moves)
  end
end
