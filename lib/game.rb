require 'board.rb'
require 'bot_player.rb'
require 'terminal_player.rb'

# Implements the game Tic Tac Toe
class Game
  INSTRUCT_1 = "\nInstruction:\n------------ \n\nTo play, first determine who is Player1 and who is Player2.  \n\nWhen called, the specified player chooses his/her/its next field by typing in the 2-digit cells' code.\n\nThe cells' code consists of two numbers from 1 to 3. The first number specifies the chosen row, the second number the chosen column\n".freeze
  INSTRUCT_2 = "For example '11' represents the upper left cell.\nDo not add any whitespaces between the two digits!\n------------\n\nReady to start?\n\nTo start, press ENTER \nto quit, type 'exit' then press ENTER\n------------\n\n".freeze
  STARTPHRASE = "Nice, Let's start! First, define your players!\n".freeze
  INSERT_PLAYER1 = "\nPlayer 1 is:  (Human, Bot)\n\n".freeze
  INSERT_PLAYER2 = "\nPlayer 2 is:  (Human, Bot)\n\n".freeze
  BYE = "\nThank you for playing.\nHave a nice day!\n------------\n\n".freeze
  TIE = "\n\nIt's a tie!\n".freeze

  def initialize
    @board = Board.new
    @winner = nil
    @wins_player1 = 0
    @wins_player2 = 0
    @ties = 0
  end

  def build_player(input)
    case input
    when 'human' then TerminalPlayer.new
    when 'bot' then BotPlayer.new
    else TerminalPlayer.new
    end
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
        puts "\nPress ENTER if you want to play another round!\nElse just type 'exit' + ENTER\n\n\n------------\n\n"
        if gets.chomp.downcase != ''
          exit = true
          puts BYE
        else
          @board.reset
        end
      end
    end
  end

  def show_stats
    puts "\n-------------------------------------------------------\n\n"
    puts "\n________Your STATS_______\n\n"
    puts "#{@players[0][0].name}:   WINS: #{@wins_player1}\n"
    puts "#{@players[1][0].name}:   WINS: #{@wins_player2}\n"
    puts "Number of TIES: #{@ties}\n\n"
    puts "\n-------------------------------------------------------\n\n"
  end

  def evaluate_game
    if @winner.nil?
      @ties += 1
      puts TIE
    elsif @winner == @players[0][1]
      @wins_player1 += 1
      @players[0][0].set_win
      puts "\n\nCongratulations #{@players[0][0].name}, you win!\n"
    elsif @winner == @players[1][1]
      @wins_player2 += 1
      @players[1][0].set_win
      puts "\n\nCongratulations #{@players[1][0].name}, you win!\n"
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
end
