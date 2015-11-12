module ScrabbleLibrary

	# empty_board is represented by a hash pointing from index to contents
	def ScrabbleLibrary.get_empty_board(game_state)
		(0..224).each {|i| game_state[i.to_s.to_sym] = " "}
		return game_state
	end

	# Create set of arrays in which numbers map to board rows and columns
	# This should be useful when checking rows and columns for only valid words
	def ScrabbleLibrary.get_index_arrays
		@@column_indeces = (0..14).to_a.collect {|c| (0..224).to_a.select {|n| n % 15 == c }}
		@@row_indeces = @@column_indeces[0].collect {|r| (r..(r + 14)).to_a}.to_a

		return @@column_indeces, @@row_indeces
	end

end

class ScrabbleSet
	include ScrabbleLibrary

	def initialize
		@game_state = {}
		ScrabbleLibrary.get_empty_board(@game_state)

		index_arrays = ScrabbleLibrary.get_index_arrays
		@column_indeces = index_arrays[0]
		@row_indeces = index_arrays[1]
	end

	def to_s
		state = "   "
		('A'..'O').each {|letter| state = state + "  #{letter}  "}
		state = state + "\n"

		@game_state.values.each_with_index do |value, index|
			if (index) % 15 == 0
				row_number = (index/15 + 1).to_s
				state = state + "#{row_number} "
				state = state + " " if row_number.length == 1
			end

			state = state + "[ " + value + " ]"

			if (index + 1) % 15 == 0
				state = state + "\n\n"
			end
		end
		state
	end
end

game = ScrabbleSet.new
puts game.to_s