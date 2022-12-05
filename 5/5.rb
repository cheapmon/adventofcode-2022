require 'active_support/all'

def create_stacks
  [
    %i[d h n q t w v b],
    %i[d w b],
    %i[t s q w j c],
    %i[f j r n z t p],
    %i[g p v j m s t],
    %i[b w f t n],
    %i[b l d q f h v n],
    %i[h p f r],
    %i[z s m b l n p h]
  ]
end

def parse_instruction(str)
  str.match(/^move (\d+) from (\d+) to (\d+)$/).to_a[1..].map(&:to_i)
end

def run_instruction(stacks, instruction, in_order)
  amount, from, to = instruction

  crates = stacks[from-1].pop(amount)
  crates = crates.reverse unless in_order
  stacks[to-1].push(*crates)
end

instructions = File.read('5.txt')
  .split("\n")
  .filter { |line| line.starts_with?('move') }
  .map { |line| parse_instruction(line) }

[false, true].each do |in_order|
  stacks = create_stacks
  instructions.each { |instruction| run_instruction(stacks, instruction, in_order) }
  puts stacks.map(&:last).join.upcase
end
