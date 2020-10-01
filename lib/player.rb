# Implements the superclass player for Tic Tac Toe
class Player
  attr_reader :name, :symbol

  def initialize
    @name = 'NoName'
    @symbol = 'x'
  end
end
