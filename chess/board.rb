require_relative 'pieces'
require_relative 'keypress'
require 'byebug'

require 'colorize'

class Board
  attr_reader :grid
  attr_accessor :cursor

  include Readable

  MOVE_MAP = {
    "DOWN ARROW" => [1, 0],
    "RIGHT ARROW" => [0, 1],
    "UP ARROW" => [-1, 0],
    "LEFT ARROW" => [0, -1],
    "RETURN" => [0, 0]
  }

  def initialize
    @grid = Array.new(8) {Array.new(8) {EmptySquare.new} }
    @cursor = [0, 0]
    populate_board
  end

  def populate_board
    grid[0] = populate_royalty(:b)
    grid[1] = populate_pawns(:b)
    grid[6] = populate_pawns(:w)
    grid[7] = populate_royalty(:w)
  end

  def populate_royalty(color)
    [
      Rook.new(color, self),
      Knight.new(color, self),
      Bishop.new(color, self),
      Queen.new(color, self),
      King.new(color, self),
      Bishop.new(color, self),
      Knight.new(color, self),
      Rook.new(color, self)
    ]
  end

  def populate_pawns(color)
    Array.new(8) { Pawn.new(color, self) }
  end

  def move_cursor
    # system "clear"
    # set_cursor_to_default
    potential_move = get_move
    until move_valid?(potential_move)
      potential_move = get_move
    end
    system "clear"
    @cursor = potential_move
  end

  def move_valid?(potential_move)
    potential_move.all? { |pos| pos.between?(0, 7) }
  end

  def get_move
    # debugger
    next_move = show_single_key
    cursor_diff = MOVE_MAP[next_move]
    # debugger
    [cursor, cursor_diff].transpose.map {|x| x.reduce(:+)}
  end

  def render
    grid.each_with_index do |row, idx1|
      row.each_with_index do |square, idx2|
        if cursor == [idx1, idx2]
          print square.to_view.colorize(background: :magenta)
        elsif (idx1 + idx2).even?
          print square.to_view.colorize(background: :blue)
        else
          print square.to_view.colorize(background: :yellow)
        end
      end
      puts
    end
  end
end
#
# p Knight.new(:white, Board.new).get_all_moves
# p King.new(:white, Board.new).get_all_moves
