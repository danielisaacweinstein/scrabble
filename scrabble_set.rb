require_relative 'board.rb'

class ScrabbleSet
  def initialize
    @board = Board.new
  end

  def to_s
    @board.to_s
  end

  def play
    # @board.set_word([0,0], "east", "hi")

    # @board.set_word([2,2], "south", "hi")

    puts @board.is_valid_move?([0,0], "south", "hello")
    @board.set_word([0,0], "south", "hello")
    puts @board.is_valid_move?([1,0], "south", "what")
    @board.set_word([1,0], "south", "what")
    puts @board.is_valid_move?([1,1], "east", "hat")
    @board.set_word([1,1], "east", "hat")
    #puts @board.is_valid_move?([3,3], "south", "hihihihi")

  end

end


puts "STARTING"

s = ScrabbleSet.new
puts s.to_s
s.play
puts s.to_s