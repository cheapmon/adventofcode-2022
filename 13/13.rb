class Array
  def zipp(other)
    length >= other.length ? zip(other) : other.zip(self).map(&:reverse)
  end
end

def right_order?(a, b)
  if a.nil?
    true
  elsif b.nil?
    false
  elsif a.is_a?(Integer) && b.is_a?(Integer)
    a < b unless a == b
  elsif a.is_a?(Array) && b.is_a?(Array)
    a.zipp(b).each do |c, d|
      r = right_order?(c, d)
      return r if [true, false].include?(r)
    end

    nil
  else
    right_order?(Array(a), Array(b))
  end
end

packets = File.read('13.txt').split("\n")
  .map { |str| eval(str) }
  .compact

puts packets.each_slice(2).each_with_index
  .filter_map { |pair, i| i+1 if right_order?(*pair) }
  .sum

puts packets.concat([[[2]], [[6]]]).sort { |a, b| right_order?(a, b) ? -1 : 1 }
  .each_with_index
  .filter_map { |packet, i| i+1 if packet == [[2]] || packet == [[6]] }
  .reduce(:*)
