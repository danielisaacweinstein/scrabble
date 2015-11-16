require_relative 'tile_space.rb'

class Board
  def initialize
    board_size = 5

    @tile_grid = Array.new(board_size) {
      Array.new(board_size) { TileSpace.new(" ") }
    }
  end

  def to_s
    @tile_grid.each_with_index do |level_from_top, t_index|
      row_string = ""
      level_from_top.each_with_index do |keys_from_left, l_index|
        row_string << @tile_grid[l_index][t_index].to_s
      end
      puts row_string
    end
  end

  def set_tile
    @tile_grid[0][1].set_contents("W")
    @tile_grid[2][0].set_contents("W")
  end

end