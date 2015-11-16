require_relative 'tile_space.rb'

class Board
  def initialize
    @board_size = 5

    @tile_grid = Array.new(@board_size) {
      Array.new(@board_size) { TileSpace.new(" ") }
    }
  end

  def to_s
    grid_string = ""
    @tile_grid.each_with_index do |level_from_top, t_index|
      row_string = ""
      level_from_top.each_with_index do |keys_from_left, l_index|
        row_string << @tile_grid[l_index][t_index].to_s
      end
      grid_string << row_string + "\n\n"
    end
    grid_string
  end

  def dup_grid
    grid_copy = Array.new(@board_size) {
      Array.new(@board_size) { TileSpace.new(" ") }
    }

    (0..@board_size - 1).each do |i|
      (0..@board_size - 1).each do |j|
        puts grid_copy[j][i].class
        grid_copy[j][i].contents = @tile_grid[j][i].contents
      end
    end

    grid_copy
  end

  def is_valid_move?(starting_index, direction, word)
    test_grid = dup_grid

    is_valid = true
    starting_x = starting_index[0]
    starting_y = starting_index[1]

    # Word must be at least 2 letters
    is_valid = false if word.length < 2

    # Doesn't go past edge
    is_valid = false if direction == "east" and starting_index[0] + word.length > @board_size
    is_valid = false if direction == "south" and starting_index[1] + word.length > @board_size

    # Doesn't disagree with contents of current tile_spaces
    word.split("").each_with_index do |letter, index|
      relative_tile = (direction == "east" ? test_grid[starting_x + index][starting_y] : test_grid[starting_x][starting_y + index])
      is_valid = false unless !relative_tile.nil? and (relative_tile.contents == " " or relative_tile.contents == letter)
    end

    # All 2+ letter words on the board are valid words
    row_list = []
    column_list = []

    (0..@board_size - 1).each do |i|
      row_string = ""
      column_string = ""
      (0..@board_size - 1).each do |j|
        column_string << test_grid[j][i].contents
        row_string << test_grid[i][j].contents
      end
      row_list << row_string
      column_list << column_string
    end

    row_words = []
    column_words = []
    row_list.each{ |row| row_words << row.split(" ")}
    column_list.each{ |column| column_words << column.split(" ")}
    
    puts row_words.to_s
    puts column_words.to_s

    return is_valid
  end

  def set_tile(index, contents)
    row_index = index[0]
    column_index = index[1]
    @tile_grid[row_index][column_index].contents = contents
  end

  def set_word(starting_index, direction, word) # starting_index is an array, [x axis, y axis]
    if is_valid_move?(starting_index, direction, word)
      word.split("").each_with_index do |letter, i|
        set_tile([starting_index[0] + i, starting_index[1]], letter) if direction == "east"
        set_tile([starting_index[0], starting_index[1] + i], letter) if direction == "south"
      end
    else
      puts "Invalid word."
    end


  end
end
