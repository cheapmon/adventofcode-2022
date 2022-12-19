require 'active_support/all'

Point = Struct.new(:x, :y)
Line = Struct.new(:a, :b) do
  def points
    Enumerator.new do |e|
      if a.x == b.x
        [a.y, b.y].min.upto([a.y, b.y].max).each { |y| e << Point.new(a.x, y) }
      elsif a.y == b.y
        [a.x, b.x].min.upto([a.x, b.x].max).each { |x| e << Point.new(x, a.y) }
      else
        raise
      end
    end
  end
end

class Grid
  def initialize(str)
    lines = str.split("\n").flat_map do |line|
      line.split('->')
        .map { |s| Point.new(*s.split(',').map(&:to_i)) }
        .each_cons(2)
        .map { |a, b| Line.new(a, b) }
    end

    @grid = []
    lines.each { |line| fill(line, '#') }
  end

  def width
    @grid.map { |row| row.try(:size) || 0 }.max
  end

  def height
    @grid.size
  end

  def [](x, y)
    @grid[y] = [] if @grid[y].nil?
    @grid[y][x]
  end

  def []=(x, y, el)
    @grid[y] = [] if @grid[y].nil?
    @grid[y][x] = el
  end

  def fill(line, el)
    line.points.each { |point| self[point.x, point.y] = el }
  end

  def count(el)
    @grid.map { |row| row.try(:count, el) || 0 }.sum
  end
end

input = File.read('14.txt')
grid = Grid.new(input)

while true do
  sand = Point.new(500, 0)

  rested = while true do
    if (sand.y + 1) >= grid.height
      break false
    elsif grid[sand.x, sand.y + 1] == nil
      sand.y += 1
    elsif grid[sand.x - 1, sand.y + 1] == nil
      sand.x -= 1
      sand.y += 1
    elsif grid[sand.x + 1, sand.y + 1] == nil
      sand.x += 1
      sand.y += 1
    else
      grid[sand.x, sand.y] = 'o'
      break true
    end
  end

  break unless rested
end

puts grid.count('o')

grid = Grid.new(input)
grid.fill(Line.new(Point.new(0, grid.height + 1), Point.new(grid.width * 2, grid.height + 1)), '#')

while grid[500, 0].nil? do
  sand = Point.new(500, 0)

  while true do
    if grid[sand.x, sand.y + 1] == nil
      sand.y += 1
    elsif grid[sand.x - 1, sand.y + 1] == nil
      sand.x -= 1
      sand.y += 1
    elsif grid[sand.x + 1, sand.y + 1] == nil
      sand.x += 1
      sand.y += 1
    else
      grid[sand.x, sand.y] = 'o'
      break
    end
  end
end

puts grid.count('o')
