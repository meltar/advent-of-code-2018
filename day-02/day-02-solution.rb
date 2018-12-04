require 'rspec'

def input
  box_ids = []
  File.foreach('day-02-input.txt') {|line| box_ids.push(line) }
  box_ids
end

def count_letters(id)
  counts = {}
  id.chars.each do |letter|
    if counts[letter].nil?
      counts[letter] = 1
    else
      counts[letter] += 1
    end
  end
  counts
end

def calculate_checksum(box_ids)
  twos = 0
  threes = 0
  box_ids.map do |id|
    counts = count_letters(id)
    twos += 1 if counts.has_value?(2)
    threes += 1 if counts.has_value?(3)
  end
  twos * threes
end


# Part 1
puts calculate_checksum(input)

# Part 2
# 

describe 'count_letters' do
  it 'counts each time a letter is used in an id' do
    expected_result = { 'a' => 3, 'b' => 2, 'c' => 1 }
    expect(count_letters('ababac')).to eq expected_result
  end
end

describe 'calculate_checksum' do
  it 'generates a total based on values for each element in input' do
    expect(calculate_checksum(['ababac'])).to eq 1

    ids = ['abcdef', 'bababc', 'abbcde', 'abcccd', 'aabcdd', 'abcdee', 'ababab']
    expect(calculate_checksum(ids)).to eq 12
  end
end