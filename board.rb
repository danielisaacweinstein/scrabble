require_relative 'tile_space.rb'

class Board
  def initialize
    @board_size = 5

    @tile_grid = Array.new(@board_size) {
      Array.new(@board_size) { TileSpace.new(" ") }
    }
  end

  def to_s(grid = @tile_grid)
    grid_string = ""
    grid.each_with_index do |level_from_top, t_index|
      row_string = ""
      level_from_top.each_with_index do |keys_from_left, l_index|
        row_string << grid[l_index][t_index].to_s
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
        grid_copy[j][i].contents = @tile_grid[j][i].contents
      end
    end

    grid_copy
  end

  def is_valid_move?(starting_index, direction, word)
    starting_x, starting_y = starting_index[0], starting_index[1]
    is_valid = true
    test_grid = dup_grid
    
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
    # TODO: DRY this up
    word.split("").each_with_index do |letter, i|
      set_tile(test_grid, [starting_index[0] + i, starting_index[1]], letter) if direction == "east"
      set_tile(test_grid, [starting_index[0], starting_index[1] + i], letter) if direction == "south"
    end

    row_list = []
    column_list = []

    (0..@board_size - 1).each do |i|
      row_string = ""
      column_string = ""
      (0..@board_size - 1).each do |j|
        row_string << test_grid[j][i].contents
        column_string << test_grid[i][j].contents
      end
      row_list << row_string
      column_list << column_string
    end

    words = []

    [row_list, column_list].each do |list|
      list.each do |line|
        line.split(" ").each do |cluster|
          words << cluster
        end
      end
    end

    return is_valid
  end

  def set_tile(grid, index, contents)
    row_index = index[0]
    column_index = index[1]
    grid[row_index][column_index].contents = contents
  end

  # TODO: Might make sense to rewrite so that I can specify the grid. That way, we can use the same method
  # for setting state on hypothetical boards as for the read board. It seems like we shouldn't _need_
  # to depend on @tile_grid specifically in the set_word method.
  def set_word(starting_index, direction, word)
    if is_valid_move?(starting_index, direction, word)
      puts "VALID. starting_index: #{starting_index.to_s}, direction: #{direction}, word: #{word}."
      word.split("").each_with_index do |letter, i|
        set_tile(@tile_grid, [starting_index[0] + i, starting_index[1]], letter) if direction == "east"
        set_tile(@tile_grid, [starting_index[0], starting_index[1] + i], letter) if direction == "south"
      end
    else
      puts "INVALID. starting_index: #{starting_index.to_s}, direction: #{direction}, word: #{word}."
    end
  end
end
