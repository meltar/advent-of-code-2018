require 'rspec'

def input
  frequencies = []
  File.foreach('day-01-input.txt') {|line| frequencies.push(line.to_i) }
  frequencies
end

def calculate_frequency(frequencies)
  frequencies.inject(0, &:+)
end

def calibrate_device(frequencies)
  frequency_history = {}
  last_frequency = 0
  repeated_found = nil
  until repeated_found
    frequencies.map do |i|
      frequency = last_frequency + i
      if frequency_history.has_key?(frequency.to_s)
        repeated_found = frequency
        break
      else
        frequency_history[frequency.to_s] = true
        last_frequency = frequency
      end
    end
  end
  repeated_found
end

# Part 1
puts calculate_frequency(input)

# Part 2
puts calibrate_device(input)

describe 'calculate_frequency' do
  it 'defaults to 0' do
    expect(calculate_frequency([])).to eq 0
  end

  it 'handles positive and negative input' do
    expect(calculate_frequency([1, 1, 1])).to eq 3
    expect(calculate_frequency([-1, -2, -3])).to eq -6
    expect(calculate_frequency([1, 1, -2])).to eq 0
  end
end

describe 'calibrate_device' do
  it 'stops when it reaches a duplicate frequency' do
    expect(calibrate_device([1, -1])).to eq 0
    expect(calibrate_device([3, 3, 4, -2, -4])).to eq 10
    expect(calibrate_device([-6, 3, 8, 5, -6])).to eq 5
    expect(calibrate_device([7, 7, -2, -7, -4])).to eq 14
  end
end
