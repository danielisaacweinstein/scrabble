require_relative 'board.rb'

class ScrabbleSet
  def initialize
    @board = Board.new
  end

  def to_s
    @board.to_s
  end

  def play
    @board.set_word([0,0], "south", "hello")
    @board.set_word([1,0], "south", "what")
    @board.set_word([1,1], "east", "hat")
    @board.set_word([1,1], "east", "bla")
    @board.set_word([4,0], "south", "werty")
    @board.set_word([1,4], "east", "bot")
  end

end

s = ScrabbleSet.new
s.play