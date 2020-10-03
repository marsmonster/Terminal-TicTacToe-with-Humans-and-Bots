require 'player.rb'

# Implements a bot player for Tic Tac Toe
class BotPlayer < Player
  @@nr_of_bots = 0

  def initialize
    super
    @@nr_of_bots += 1
  end

  def set_symbol
    @symbol
  end

  def set_player_name
    read_bots_file
    @name
  end

  def read_bots_file
    bot_names_symbols = IO.readlines('bot_names.txt', chomp: true)
    selection = bot_names_symbols.select.with_index do |_, indx|
      indx % 2 == (@@nr_of_bots - 1)
    end
    name_and_symbol = selection.sample(1)[0].split(',')
    @name = name_and_symbol[1]
    @symbol = name_and_symbol[0]
  end

  def get_move(board, player_id)
    sleep 1
    puts "\n    #{@name}'s move:\n"
    cell = two_in_row(board, player_id, 2)
    return cell unless cell.nil?

    cell = two_in_row(board, player_id, 0)
    return cell unless cell.nil?

    return [1, 1] if board.board[1][1] == :empty

    possibilities = []
    [0, 1, 2].each do |i|
      [0, 1, 2].each do |j|
        possibilities.push([i, j]) if board.board[i][j] == :empty
      end
    end
    possibilities.sample(1)[0]
  end

  private

  def check_move(board, row, player_id, nr_of_occ)
    indxs = board.find_index_for_ids(row, [player_id, :empty])
    return indxs[1][0] if indxs[0].length == nr_of_occ && indxs[1].length == 1

    nil
  end

  def two_in_row(board, player_id, nr_of_occ)
    diag1_ind = check_move(board, board.diag1, player_id, nr_of_occ)
    return [diag1_ind, diag1_ind] unless diag1_ind.nil?

    diag2_ind = check_move(board, board.diag2, player_id, nr_of_occ)
    unless diag2_ind.nil?
      return [2, 0] if diag2_ind == 0

      return [1, 1] if diag2_ind == 1

      return [0, 2]
    end
    [0, 1, 2].each do |i|
      row_ind = check_move(board, board.row(i), player_id, nr_of_occ)
      return [i, row_ind] unless row_ind.nil?
    end
    [0, 1, 2].each do |i|
      col_ind = check_move(board, board.column(i), player_id, nr_of_occ)
      return [col_ind, i] unless col_ind.nil?
    end
    nil
  end
end
