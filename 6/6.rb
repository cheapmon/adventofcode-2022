marker = ->(buffer, length) { buffer.split('').each_cons(length).find_index { |c| c.uniq == c } + length }

File.read('6.txt').strip
  .tap { |buffer| puts marker.(buffer, 4) }
  .tap { |buffer| puts marker.(buffer, 14) }
