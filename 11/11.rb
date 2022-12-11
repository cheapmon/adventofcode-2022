class Monkey
  attr_reader :id, :count, :div
  attr_accessor :items

  def initialize(str)
    lines = str.split("\n")

    @id = lines[0].sub('Monkey ', '').sub(':', '').to_i
    @items = lines[1].sub('Starting items: ', '').split(', ').map(&:to_i)
    @count = 0

    op = lines[2].sub('Operation: new =', '').strip
    @div = lines[3].sub('Test: divisible by ', '').to_i
    t = lines[4].sub('If true: throw to monkey ', '').to_i
    f = lines[5].sub('If false: throw to monkey ', '').to_i
    instance_eval <<~RUBY.chomp
      def test(old, lcm, d)
        @count += 1

        r = ((#{op}) / d) % lcm
        [(r % div == 0) ? #{t} : #{f}, r]
      end
    RUBY
  end
end

def run(input, rounds, d=1)
  monkeys = input.map { |str| Monkey.new(str) }
  lcm = monkeys.reduce(1) { |acc, cur| acc.lcm(cur.div) }

  rounds.times do
    monkeys.each do |monkey|
      monkey.items.each do |item, i|
        new_monkey_id, new_item = monkey.test(item, lcm, d)
        monkeys[new_monkey_id].items.push(new_item)
      end

      monkey.items = []
    end
  end

  monkeys.max_by(2, &:count).map(&:count).reduce(:*)
end

File.read('11.txt')
  .split("\n\n")
  .tap { |input| puts run(input, 20, 3) }
  .tap { |input| puts run(input, 10_000) }
