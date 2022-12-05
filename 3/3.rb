require 'active_support/all'

def priority(char)
  ord = char.ord

  if ord >= 97
    ord % 97 + 1
  else
    ord % 65 + 27
  end
end

def split_compartments(rucksack)
  mid = rucksack.length / 2
  [rucksack[0..(mid-1)], rucksack[mid..-1]]
end

def common_item(strs)
  strs[1..].reduce(strs[0].split('')) { |acc, str| acc & str.split('') }.sole
end

File.read('3.txt')
  .split("\n")
  .tap { |list| puts list.map { |rucksack| priority(common_item(split_compartments(rucksack))) }.sum }
  .tap { |list| puts list.each_slice(3).map { |list| priority(common_item(list)) }.sum }
