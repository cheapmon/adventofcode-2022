@shapes = { rock: 1, paper: 2, scissors: 3 }
@outcomes = { loss: 1, draw: 2, win: 3 }
@scores = { loss: 0, draw: 3, win: 6 }
@shape_for_outcome = {
  %i[rock loss] => :scissors,
  %i[rock draw] => :rock,
  %i[rock win] => :paper,
  %i[paper loss] => :rock,
  %i[paper draw] => :paper,
  %i[paper win] => :scissors,
  %i[scissors loss] => :paper,
  %i[scissors draw] => :scissors,
  %i[scissors win] => :rock
}

def score(opponent, outcome)
  opponent_shape = @shapes.invert[opponent]
  outcome = @outcomes.invert[outcome]
  shape = @shape_for_outcome.fetch([opponent_shape, outcome])
  @scores[outcome] + @shapes[shape]
end

File.read('2.txt')
  .split("\n")
  .map { |round| round.split.map { |letter| letter.ord % 88 % 65 + 1 } }
  .tap { |rounds| p rounds.map { |a, b| b + (4.5 * (x=(a-b)%3) * x) - (7.5 * x) + 3 }.sum.to_i }
  .tap { |rounds| p rounds.map { |a, b| score(a, b) }.sum }
