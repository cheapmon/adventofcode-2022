instructions = File.read('10.txt')
  .split("\n")
  .map(&:split)

x = 1
r = [x]

while !instructions.empty?
  instruction = instructions.shift

  case instruction
  in ['addx', n]
    2.times { r << x }
    x += n.to_i
  in ['noop']
    r << x
  end
end


puts [20, 60, 100, 140, 180, 220].map { |i| i * r[i] }.sum

r.each_with_index.drop(1).each_slice(40) do |list|
  list.each { |x, i| print (i % 40).between?(x, x+2) ? '#' : '.' }
  puts
end
