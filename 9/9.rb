require 'set'

Point = Struct.new(:x, :y) do
  def +(other)
    Point.new(x + other.x, y + other.y)
  end

  def -(other)
    Point.new(x - other.x, y - other.y)
  end

  def sgn
    Point.new(x == 0 ? 0 : x / x.abs, y == 0 ? 0 : y / y.abs)
  end

  def touching?(other)
    (x - other.x).abs <= 1 && (y - other.y).abs <= 1
  end
end

def adjust_points(current, previous)
  current.touching?(previous) ? Point.new(0, 0) : Point.new(0, 0) - (current - previous).sgn
end

def adjust_rope(rope)
  1.upto(rope.length - 1).each { |i| rope[i] += adjust_points(rope[i], rope[i-1]) }
end

def run(steps, knots)
  rope = 1.upto(knots).map { Point.new(0, 0) }
  positions = Set[]

  steps.each do |dir, n|
    n.to_i.times do |i|
      case dir
      when 'U'
        rope[0] += Point.new(0, 1)
        adjust_rope(rope)
      when 'R'
        rope[0] += Point.new(1, 0)
        adjust_rope(rope)
      when 'D'
        rope[0] += Point.new(0, -1)
        adjust_rope(rope)
      when 'L'
        rope[0] += Point.new(-1, 0)
        adjust_rope(rope)
      end

      positions << [rope.last.x, rope.last.y]
    end
  end

  positions.count
end

File.read('9.txt')
  .split("\n")
  .map(&:split)
  .tap { |steps| puts run(steps, 2) }
  .tap { |steps| puts run(steps, 10) }
