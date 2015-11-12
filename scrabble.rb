module ScrabbleLibrary

	# empty_board is represented by a hash pointing from location to contents
	def ScrabbleLibrary.get_empty_board(game_state)
		(0..224).each {|i| game_state[i.to_s.to_sym] = " "}
		return game_state
	end

	# Create set of arrays in which numbers map to board rows and columns
	# This should be useful when checking rows and columns for only valid words
	def ScrabbleLibrary.get_key_arrays
		@@column_keys = (0..14).to_a.collect {|c| (0..224).to_a.select {|n| n % 15 == c }}
		@@row_keys = @@column_keys[0].collect {|r| (r..(r + 14)).to_a}.to_a

		return @@column_keys, @@row_keys
	end

	def ScrabbleLibrary.alphanumeric_to_key(alphanumeric_input)
		alphanumeric_array = []
		(1..15).each {|number| ('A'..'O').each {|letter| alphanumeric_array << letter + number.to_s}}

		alphanumeric_conversion = {}
		alphanumeric_array.each do |index|
			first_number = index.index(/\d/)
			alpha = index[0..first_number -1].ord - 64 # char offset
			numeric = index[first_number..-1].to_i
			alphanumeric_conversion[index] = (alpha * numeric) - 1 # set to 0th index
		end

		alphanumeric_conversion[alphanumeric_input.to_sym]
	end
end

class ScrabbleSet
	include ScrabbleLibrary

	def initialize
		@game_state = {}
		ScrabbleLibrary.get_empty_board(@game_state)

		key_arrays = ScrabbleLibrary.get_key_arrays
		@column_keys = key_arrays[0]
		@row_keys = key_arrays[1]

		ScrabbleLibrary.alphanumeric_to_key('A1')
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
# puts game.to_s