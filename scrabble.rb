# A set of methods and variables helpful for Scrabble board indexing
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

  # Offers a conversion between alphanumeric grid (A1...O15) visible to
  # the user and numeric index (0 - 224) familiar to game state.
  def ScrabbleLibrary.alphanumeric_to_key(alphanumeric_input)
    alphanumeric_array = []
    (1..15).each {|number| ('A'..'O').each {|letter| alphanumeric_array << letter + number.to_s}}

    alphanumeric_conversion = {}
    alphanumeric_array.each_with_index do |alphanumeric_location, i|
      first_number = alphanumeric_location.index(/\d/)

      # Subtract char offset to get 1..15
      alpha = alphanumeric_location[0..first_number - 1].ord - 64
      numeric = alphanumeric_location[first_number..-1].to_i

      # Revisit for cleanliness
      alphanumeric_conversion[alphanumeric_location] = (alpha - 1) + (15 * (numeric - 1))
    end

    alphanumeric_conversion[alphanumeric_input]
  end

  def ScrabbleLibrary.valid_move?(game_state, word_position, word)

    # Create hypothetical game_state
    test_state = game_state.clone()
    word_position.each_with_index do |key, index|
      test_state[key.to_s.to_sym] = word.split("")[index]
    end

    word_hash_array = []

    # Iterate through each column, taking indeces corresponding to straight lines
    # to find all words with length >= 2. We'll later use the collection of hashes
    # of words on the board to test for intersections.
    @@column_keys.each do |column|
      column_string = ""
      column.each {|letter| column_string << test_state[letter.to_s.to_sym]}

      column_word_hash = {}
      column_string.split("").each_with_index do |letter, index|
        column_word_hash[column[index]] = letter unless letter == " "
      end

      word_hash_array << column_word_hash unless column_word_hash.length < 2
    end

    puts word_hash_array

    true
  end
end

# Individual Scrabble game. Contains game state, game play, players.
class ScrabbleSet
  include ScrabbleLibrary

  def initialize
    @game_state = {}
    ScrabbleLibrary.get_empty_board(@game_state)
    key_arrays = ScrabbleLibrary.get_key_arrays
    @column_keys = key_arrays[0]
    @row_keys = key_arrays[1]
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

      state = state + "[ " + value.to_s + " ]"

      if (index + 1) % 15 == 0
        state = state + "\n\n"
      end
    end

    state
  end

  # Given a starting position, direction ("south"/"east"), and word, sets the tiles
  # on the board using column/row index arrays. No validation included at this time.
  def set_tiles(starting_index, direction, word)
    starting_key = ScrabbleLibrary.alphanumeric_to_key(starting_index)

    # direction_array holds 2D array of indeces for all straight lines on the board
    direction_array = (direction.downcase == "south" ? @column_keys : @row_keys)

    word_position = []

    direction_array.each do |line|
      if line.any? {|key| key == starting_key}
        position_in_line = line.index(starting_key)
        word_position = line[position_in_line..(position_in_line + word.length - 1)]
      end
    end

    if ScrabbleLibrary.valid_move?(@game_state, word_position, word)
      word_position.each_with_index do |key, index|
        @game_state[key.to_s.to_sym] = word.split("")[index]
      end
    end
  end
end

# Arbitrary tests here
game = ScrabbleSet.new
game.set_tiles("D2", "south", "ben")
game.set_tiles("F8", "south", "what")
game.set_tiles("B1", "south", "anaconda")
puts game.to_s