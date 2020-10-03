require 'board.rb'
require 'bot_player.rb'
require 'terminal_player.rb'

# Implements the game Tic Tac Toe
class Game
  INSTRUCT_1 = %(
    Instruction:
    ------------

    Before you start a match make sure to determine names,
    symbols and species of the two players.
    You can choose between HUMAN and BOT.

    As soon as the game starts, the specified player
    chooses his/her/its cell of the board by typing in
    the 2-digit cells' code.

    The cells' code consists of two numbers ranging from 1 to 3.
    The first number specifies the chosen row,
    the second number the chosen column
  ).freeze

  INSTRUCT_2 = %(
    For example 23 represents the middle cell of the right column.
    Do not add any whitespaces between the two digits!
    ------------

    Ready to start?

    To start, press ENTER
    to quit, type 'exit' then press ENTER
    ------------).freeze

  STARTPHRASE = %(
    Nice, Let's start! First, define your players!
  ).freeze

  INSERT_PLAYER1 = %(
    Player 1 is: ___ \(Type 'h' for Human or 'b' for Bot, then press ENTER\)
  ).freeze

  INSERT_PLAYER2 = %(
    Player 2 is: ___ \(Type 'h' for Human or 'b' for Bot, then press ENTER\)
  ).freeze

  TRY_AGAIN = %(
    Please make sure you press the letter 'h' for Human and 'b' for Bot!
    Just try again:
  ).freeze

  BYE = %(
    Thank you for playing.
    Have a nice day!
    ------------).freeze

  TIE = %(
    It's a tie!
  ).freeze

  NEXT_ROUND = %(
    Press ENTER if you want to play another round!
    Else just type 'exit' + ENTER

    ------------).freeze

  def initialize
    @board = Board.new
    @winner = nil
    @wins_player1 = 0
    @wins_player2 = 0
    @ties = 0
  end

  def mainmenu
    puts INSTRUCT_1
    @board.show_board(' ', ' ')
    puts INSTRUCT_2
    if gets.chomp.downcase != ''
      puts BYE
    else
      puts STARTPHRASE
      players = select_players_menu
      exit = false
      until exit
        run(players[0], players[1])
        evaluate_game
        show_stats
        puts NEXT_ROUND
        if gets.chomp.downcase != ''
          exit = true
          puts BYE
        else
          @board.reset
          @players = [[@players[1][0], :p1], [@players[0][0], :p2]]
          players[1], players[0] = players[0], players[1]
        end
      end
    end
  end

  def select_players_menu
    puts INSERT_PLAYER1
    player1 = setup_player(gets.chomp.downcase)
    puts INSERT_PLAYER2
    player2 = setup_player(gets.chomp.downcase)
    [player1, player2]
  end

  def run(player1, player2)
    set_players(player1, player2)
    @board.show_board(' ', ' ')
    end_of_game = false
    round = 1
    until end_of_game
      @players.each do |player|
        cell = player[0].get_move(@board, player[1])
        @board.update_board(player[1], cell)
        @board.show_board(@players[0][0].symbol, @players[1][0].symbol)
        if @board.symbols_in_row(player[1], 3)
          @winner = player[1]
          end_of_game = true
          break
        elsif round == 9
          end_of_game = true
          break
        end
        round += 1
      end
    end
  end

  def show_stats
    puts %(
    -------------------------------------------------------

                ________Your STATS_______

      #{@players[0][0].name}:   WINS: #{@wins_player1}
      #{@players[1][0].name}:   WINS: #{@wins_player2}
      Number of TIES: #{@ties}


    -------------------------------------------------------)
  end

  private

  def build_player(input)
    valid = false
    until valid
      valid = validate_species(input)
      unless valid
        puts TRY_AGAIN
        input = gets.chomp.downcase
      end
    end
    input == 'b' ? BotPlayer.new : TerminalPlayer.new
  end

  def validate_species(input)
    return true if input == 'b' || input == 'h'

    false
  end

  def set_players(player1, player2)
    @players = [[player1, :p1], [player2, :p2]]
  end

  def setup_player(input)
    player = build_player(input)
    player.set_player_name
    player.set_symbol
    player
  end

  def evaluate_game
    if @winner.nil?
      @ties += 1
      puts TIE
    elsif @winner == @players[0][1]
      @wins_player1 += 1
      puts "\n\n    Congratulations #{@players[0][0].name}, you win!\n"
    elsif @winner == @players[1][1]
      @wins_player2 += 1
      puts "\n\n    Congratulations #{@players[1][0].name}, you win!\n"
    end
  end
end
