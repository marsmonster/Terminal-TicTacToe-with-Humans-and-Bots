# Implements the superclass player for Tic Tac Toe
class Player
  attr_reader :name, :symbol, :wins

  def initialize
    @name = 'NoName'
    @symbol = 'x'
    @wins = 0
  end
end
