class Edge
  attr_reader :src, :dest, :cost
  attr_writer :cost
  def initialize(src, dest, cost)
    @src = src
    @dest = dest
    @cost = cost
    src.to_edges << self
    dest.from_edges << self
  end

  def inspect
    "src: #{src.value} | dest: #{dest.value} | weight: #{cost}"
  end
end