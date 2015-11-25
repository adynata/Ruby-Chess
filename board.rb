require_relative 'pieces/piece_junction'
require_relative 'keypress'

# require 'colorize'

class InvalidMove < StandardError
end

class Board
  # attr_reader
  attr_accessor :cursor, :move_in_process, :selected_piece, :grid

  include Readable

  MOVE_MAP = {
    "DOWN ARROW" => [1, 0],
    "RIGHT ARROW" => [0, 1],
    "UP ARROW" => [-1, 0],
    "LEFT ARROW" => [0, -1],
    "RETURN" => [0, 0]
  }

  def initialize(fill_board = true)
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    @cursor = [7, 0]
    @move_in_process = false
    populate_board if fill_board
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, mark)
    @grid[row][col] = mark
  end


  def populate_board
    p "populating board"
    grid[0] = populate_royalty(:black, 0)
    grid[1] = populate_pawns(:black, 1)
    grid[6] = populate_pawns(:white, 6)
    grid[7] = populate_royalty(:white, 7)
  end

  def populate_royalty(color, row)
    [
      Rook.new(color, self, [row, 0]),
      Knight.new(color, self, [row, 1]),
      Bishop.new(color, self, [row, 2]),
      Queen.new(color, self, [row, 3]),
      King.new(color, self, [row, 4]),
      Bishop.new(color, self, [row, 5]),
      Knight.new(color, self, [row, 6]),
      Rook.new(color, self, [row, 7])
    ]
  end

  def populate_pawns(color, row)
    arr = []
    0.upto(7) do |col|
      arr << Pawn.new(color, self, [row, col])
    end

    arr
    # Array.new(8) { Pawn.new(color, self) }
  end

  def move_cursor(player_color)
    potential_move = get_move
    until on_board?(potential_move)
      potential_move = get_move
    end
    if @cursor == potential_move
      raise InvalidMove unless good_selection?(potential_move, player_color)
      @move_in_process = !@move_in_process
      @selected_piece = potential_move
    end
    @cursor = potential_move
  end

  def good_selection?(potential_move, player_color)
    if !@move_in_process
      is_piece?(potential_move) && player_color == self[*potential_move].color
    else
      moves_around_piece(@selected_piece).include?(potential_move)
    end
  end

  def move(color, start_pos, end_pos)

    piece = self[*start_pos]
    raise 'from position is empty' if piece.is_a?(EmptySquare)
    if piece.color != color
      raise "you can only move your own piece"
    elsif !piece.all_moves.include?(end_pos)
      raise "you're not permitted to put your piece there"
    elsif !piece.valid_moves.include?(end_pos)
      raise "you can't move into check"
    end

    move_piece!(start_pos, end_pos)
  end

  def move_piece!(start_pos, end_pos)
    # debugger
    piece = self[*start_pos]
    end_piece = self[*end_pos]
    raise 'piece cannot move like that' unless piece.all_moves.include?(end_pos)
    self[*start_pos] = EmptySquare.new
    self[*end_pos] = piece
    piece.pos = end_pos
    if piece.is_a?(Pawn)
      piece.moved = true
    end

  end



  def find_king(color)

    pieces.each do |piece|
      if ((piece.class == King) && (piece.color == color))
        return piece.pos
      end
    end

    raise 'no king on board'

  end

  def in_check?(color)
    # return false
    king_pos = find_king(color)
    pieces.each do |piece|
      # debugger

      moves = []
      moves = piece.all_moves
      if moves.include?(king_pos)
        # puts "#{color}: you're in check"
        return true
      end

    end
    false
  end

  def checkmate?(current_player)
    color = current_player.color
    return false unless in_check?(color)
    pieces.select { |p| p.color == color }.all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def on_board?(potential_move)
    # p potential_move
    potential_move.all? { |pos| pos.between?(0, 7) }
  end

  def valid_move?(potential_move, color)
    on_board?(potential_move) && (!is_piece?(potential_move) )
  end

  def pieces
    grid.flatten.reject { |piece| piece.color == false }
  end

  def dup
    new_board = Board.new(false)

    pieces.each do |piece|
      dup_piece = piece.class.new(piece.color, new_board, piece.pos)
      new_board.grid[piece.pos[0]][piece.pos[1]] = dup_piece
    end
    new_board
  end

  def is_piece?(position)
    !self[*position].is_a?(EmptySquare)
  end

  def get_move
    next_move = show_single_key
    cursor_diff = MOVE_MAP[next_move]
    [cursor, cursor_diff].transpose.map {|x| x.reduce(:+)}
  end

  def render(notifications, current_player)
    system "clear"
    if move_in_process
      render_around_piece(selected_piece)
      notifications.each do |key, val|
        puts "      #{val}"
      end
      puts "      current player is: #{current_player.color}"
    else
      render_around_piece(cursor)
      notifications.each do |key, val|
        puts "      #{val}"
      end
      puts "      current player is: #{current_player.color}"
    end
  end

  def render_around_piece(piece)
    puts
    puts
    grid.each_with_index do |row, idx1|
      print "      "
      row.each_with_index do |square, idx2|
        if piece != cursor && cursor == [idx1, idx2]
          print square.to_view.colorize(background: :green)
        elsif piece == [idx1, idx2]
          print square.to_view.colorize(background: :green)
          # debugger
        elsif moves_around_piece(piece).include?([idx1, idx2])
          # p '2nd elsif'
          print square.to_view.colorize(background: :light_green)
        elsif (idx1 + idx2).even?
          print square.to_view.colorize(background: :blue)
        else
          print square.to_view.colorize(background: :light_red)
        end
      end
      puts

    end
  end



  def moves_around_piece(position)
    moves = self[*position].all_moves
  end
end
