require_relative 'pieces/piece_junction'
require_relative 'keypress'

class InvalidMove < StandardError
end

class InvalidSelection < StandardError
end

class Board
  attr_accessor :cursor, :move_in_process, :selected_piece, :grid

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
  end

  def move(color, start_pos, end_pos)
    piece = self[*start_pos]
    if !(piece.valid_moves.include?(end_pos))
      raise InvalidMove, "you can't move into check"
    end
    move_piece!(start_pos, end_pos)
  end

  def move_piece!(start_pos, end_pos)
    piece = self[*start_pos]
    end_piece = self[*end_pos]
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
    king_pos = find_king(color)
    pieces.each do |piece|
      moves = []
      moves = piece.all_moves
      if moves.include?(king_pos)
        return true
      end
    end
    false
  end

  def checkmate?(current_player)

    color = current_player.color

    return false unless in_check?(color)
    all_pieces_of_current_player = pieces.select { |piece| piece.color == color }
    all_pieces_of_current_player.all? { |piece| piece.valid_moves.empty? }
  end

  def on_board?(potential_move)
    potential_move.all? { |pos| pos.between?(0, 7) }
  end

  def valid_move?(potential_move, color)
    on_board?(potential_move) && (!is_piece?(potential_move) )
  end

  def pieces
    grid.flatten.reject { |piece| !piece.color }
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
    self[*position].color
  end


end
