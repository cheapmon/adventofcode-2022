require 'active_support/all'

Node = Struct.new(:e, :w) do
  def ord
    e == 'S' ? 'a'.ord : e == 'E' ? 'z'.ord : e.ord
  end
end

class Grid
  attr_reader :width, :height

  def initialize(str)
    lines = str.split("\n")

    @grid = lines.flat_map { |line| line.split('') }.map { |s| Node.new(s) }
    @width = lines.first.length
    @height = lines.length
  end

  def [](x, y)
    if x.between?(0, width - 1) && y.between?(0, height - 1)
      Cell.new(self, x, y, @grid[y * width + x])
    end
  end

  def find(&block)
    @grid.each_with_index
      .filter(&block)
      .map { |node, i| Cell.new(self, i % width, i / width, node) }
  end

  def clear!
    @grid.each { |node| node.w = nil }
  end

  class Cell
    attr_reader :x, :y, :value

    delegate :e, :w, :ord, to: :value

    def initialize(grid, x, y, value)
      @grid = grid
      @x = x
      @y = y
      @value = value
    end

    def neighbors
      [
        @grid[x-1, y],
        @grid[x+1, y],
        @grid[x, y-1],
        @grid[x, y+1]
      ].compact_blank
    end
  end
end

def run(grid, s)
  grid.clear!
  queue = [s]

  while (cell = queue.shift).present?
    cell.neighbors.each do |c|
      w = (cell.w || 0) + 1

      next unless c.w.nil? || w < c.w
      next unless (c.ord - cell.ord) <= 1

      c.value.w = w
      queue << c
    end
  end

  grid.find { |node, i| node.e == 'E' }.sole.w
end

input = File.read('12.txt')
grid = Grid.new(input)

puts run(grid, grid.find { |node, i| node.e == 'S' }.sole)
puts grid.find { |node, i| node.ord == 'a'.ord }.map { |s| run(grid, s) }.compact_blank.min
