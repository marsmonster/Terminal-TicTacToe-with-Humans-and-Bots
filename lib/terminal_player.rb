require 'player.rb'

# Implements a terminal player for Tic Tac Toe
class TerminalPlayer < Player
  def set_symbol
    puts "\n    What symbol would you like to use?\n"
    @symbol = gets.chomp
  end

  def set_player_name
    puts "\n    What's your name?\n"
    @name = gets.chomp
  end

  def get_move(board, _)
    puts "    #{@name}, please make a move!\n\n"
    valid = false
    until valid
      input = gets.chomp.split('', 2).map(&:to_i)
      valid = validate(input, board)
    end
    input.map! { |e| e - 1 }
  end

  private

  def validate(input, board)
    cell_name = [1, 2, 3]
    if cell_name.include?(input[0]) && cell_name.include?(input[1])
      return true if board.board[input[0] - 1][input[1] - 1] == :empty

      puts "\n    The field is already taken! Please enter a new field!"
    else
      puts "\n    Please use a valid field code like '11', '23' etc.!"
    end
    false
  end

end
