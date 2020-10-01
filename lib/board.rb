# Implements the board for Tic Tac Toe
class Board
  attr_reader :board

  def initialize
    reset
  end

  def reset
    @board = [
      [:empty, :empty, :empty],
      [:empty, :empty, :empty],
      [:empty, :empty, :empty]
    ]
  end

  def show_board(symbol_pl1, symbol_pl2)
    board = @board.clone.map do |row|
      row.map do |cell|
        case cell
        when :empty then ' '
        when :p1 then symbol_pl1
        when :p2 then symbol_pl2
        end
      end
    end
    puts [
      "\n           1   2   3 \n\n",
      "      1    #{board[0][0]} | #{board[0][1]} | #{board[0][2]} \n",
      "          ---|---|---\n",
      "      2    #{board[1][0]} | #{board[1][1]} | #{board[1][2]} \n",
      "          ---|---|---\n",
      "      3    #{board[2][0]} | #{board[2][1]} | #{board[2][2]} \n\n"
    ]
  end

  def update_board(player_id, cell)
    @board[cell[0]][cell[1]] = player_id
  end

  def find_index_for_ids(row, arr_of_ids)
    result = Array.new(arr_of_ids.length) { [] }
    arr_of_ids.each_with_index do |id, index|
      row.each_with_index do |element, nr|
        result[index].push(nr) if element == id
      end
    end
    result
  end

  def column(col_nr)
    [@board[0][col_nr], @board[1][col_nr], @board[2][col_nr]]
  end

  def row(row_nr)
    [@board[row_nr][0], @board[row_nr][1], @board[row_nr][2]]
  end

  def diag1
    [@board[0][0], @board[1][1], @board[2][2]]
  end

  def diag2
    [@board[2][0], @board[1][1], @board[0][2]]
  end

  def symbols_in_row(player_id, number)
    [0, 1, 2].each do |i|
      return true if column(i).count(player_id) == number
      return true if row(i).count(player_id) == number
    end
    return true if diag1.count(player_id) == number
    return true if diag2.count(player_id) == number

    false
  end
end
