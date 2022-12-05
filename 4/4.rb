require 'active_support/all'

File.read('4.txt').split("\n")
  .map { |line| line.split(',').map { |r| (x=r.split('-')).first.to_i..x.second.to_i } }
  .tap { |list| p list.count { |r1, r2| r1.all? { |n| n.in?(r2) } || r2.all? { |n| n.in?(r1) } } }
  .tap { |list| p list.count { |r1, r2| (r1.to_a & r2.to_a).present? } }
