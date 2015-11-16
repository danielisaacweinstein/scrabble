class TileSpace
  def initialize(contents)
    @contents = contents
  end

  attr_accessor :contents

  def to_s
    return "[ " + @contents + " ]"
  end
end
