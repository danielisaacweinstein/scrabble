require_relative 'board.rb'

class ScrabbleSet
  def initialize
    @board = Board.new
  end

  def to_s
    @board.to_s
  end

end

s = ScrabbleSet.new
s.to_s