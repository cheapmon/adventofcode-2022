require 'active_support/all'

class Directory
  attr_reader :name, :parent, :dirs, :files

  def initialize(name, parent)
    @name = name
    @parent = parent
    @dirs = {}
    @files = {}
  end

  def cd(name)
    if name == '..'
      @parent
    else
      mkdir(name)
      @dirs[name]
    end
  end

  def mkdir(name)
    @dirs[name] ||= Directory.new(name, self)

    self
  end

  def mkfile(size, name)
    @files[name] = size.to_i

    self
  end

  def total_size
    @files.values.sum + @dirs.values.map(&:total_size).sum
  end

  def sum_of_at_most(n)
    (total_size < n ? total_size : 0) + @dirs.values.map { |d| d.sum_of_at_most(n) }.sum
  end

  def smallest_of_at_least(n)
    [total_size, *@dirs.values.map { |d| d.smallest_of_at_least(n) }].compact_blank.filter { |s| s >= n }.min
  end
end

root_dir = Directory.new('ROOT', nil)
current_dir = root_dir

File.read('7.txt').split("\n").each do |line|
  current_dir = case line
  when /\$ cd \.\./
    current_dir.cd('..')
  when /\$ cd (.*)/
    current_dir.cd($1)
  when /\$ ls/
    current_dir
  when /dir (.*)/
    current_dir.mkdir($1)
  when /(\d+) (.*)/
    current_dir.mkfile($1, $2)
  end
end

root_dir = root_dir.dirs['/']
puts root_dir.sum_of_at_most(100000)
puts root_dir.smallest_of_at_least(root_dir.total_size - (70000000 - 30000000))
