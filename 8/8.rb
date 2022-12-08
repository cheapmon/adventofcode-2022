require 'active_support/all'

class Grid
  attr_reader :width, :height

  def initialize(grid, width)
    @grid = grid
    @width = width
    @height = grid.length / width
  end

  def [](x, y)
    Cell.new(self, x, y, @grid[y * width + x])
  end
  
  def []=(x, y, value)
    @grid[y * width + x] = value
  end

  def cells
    Enumerator.new do |e|
      (0..(width-1)).each do |x|
        (0..(height-1)).each do |y|
          e << self[x, y]
        end
      end
    end
  end
end

class Cell
  attr_reader :x, :y, :value

  def initialize(grid, x, y, value)
    @grid = grid
    @x = x
    @y = y
    @value = value
  end

  def value=(value)
    @grid[x, y] = value
    @value = value
  end

  def surrounding
    [
      (0..(y-1)).map { |n| @grid[x, n] }.reverse,
      ((y+1)..(@grid.height-1)).map { |n| @grid[x, n] },
      (0..(x-1)).map { |n| @grid[n, y] }.reverse,
      ((x+1)..(@grid.width-1)).map { |n| @grid[n, y] }
    ]
  end
end

class Array
  def take_while(&block)
    result = []
    each do |el|
      result << el
      break unless block.(el)
    end
    result
  end
end

contents = File.read('8.txt')
width = contents.split("\n").first.length
grid = Grid.new(contents.gsub("\n", "").split("").map(&:to_i), width)

puts grid.cells.count { |cell| cell.surrounding.any? { |list| list.all? { |c| c.value < cell.value } } }
puts grid.cells.map { |cell| cell.surrounding.map { |list| list.take_while { |c| c.value < cell.value }.count }.reduce(:*) }.max
