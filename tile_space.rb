class TileSpace
  def initialize(contents)
    @contents = contents
  end

  def to_s
    return "[ " + @contents + " ]"
  end

  def set_contents(new_contents)
    @contents = new_contents
  end

end