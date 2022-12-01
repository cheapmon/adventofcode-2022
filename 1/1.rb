File.read('1.txt')
  .split("\n\n")
  .map { |section| section.split("\n").map(&:to_i).sum }
  .tap { |calories| puts calories.max }
  .tap { |calories| puts calories.max(3).sum }
