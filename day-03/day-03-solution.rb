require 'rspec'

def input
  claims = []
  File.foreach('day-03-input.txt') do |line|
    claim = parse_claim(line)
    claims.push(claim)
  end
  claims
end

def parse_claim(line)
  claim = line.split(/\D/) - [""]
  {
    id: claim[0],
    x: claim[1].to_i,
    y: claim[2].to_i,
    width: claim[3].to_i,
    height: claim[4].to_i
  }
end

def claimed_squares(claims)
  squares = {}
  claims.each do |claim| 
    claim[:width].times do |x|
      claim[:height].times do |y|
        coordinates = "#{claim[:x] + x}x#{claim[:y] + y}"
        if squares[coordinates]
          squares[coordinates] += 1
        else
          squares[coordinates] = 1
        end
      end
    end
  end
  squares
end

def overlapping_claimed_squares(squares)
  squares.values.count { |val| val > 1 }
end

def unconflicting_claims(squares, claims)
  ids = []
  claims.each do |claim|
    unconflicted = true
    claim[:width].times do |x|
      claim[:height].times do |y|
        coordinates = "#{claim[:x] + x}x#{claim[:y] + y}"
        unconflicted = false if squares[coordinates] > 1
        break unless unconflicted
      end
      break unless unconflicted
    end
    ids.push(claim[:id]) if unconflicted
  end
  ids
end

# Part 1
# read in input and parse lines
claims = input
# calculate claims
squares = claimed_squares(claims)
# find overlaps
puts overlapping_claimed_squares(squares)
# Part 2
puts unconflicting_claims(squares, claims)

describe 'parse_claim' do
  it 'breaks the claim string into hash values' do
    expected_result = { id: '123', x: 3, y: 2, width: 5, height: 4 }
    expect(parse_claim('#123 @ 3,2: 5x4')).to eq expected_result
  end
end

describe 'claimed_squares' do
  it 'counts claims for squares' do
    claims = [
      { id: '1', x: 1, y: 3, width: 2, height: 2 },
      { id: '2', x: 0, y: 3, width: 2, height: 1 }
    ]
    expected_result = { '1x3' => 2, '1x4' => 1, '2x3' => 1, '2x4' => 1, '0x3' => 1 }
    expect(claimed_squares(claims)).to eq expected_result
  end
end

describe 'overlapping_claimed_squares' do
  it 'counts squares with more than one claim' do
    claims = { '1x1' => 1, '1x2' => 2, '2x1' => 3, '2x2' => 4 }
    expect(overlapping_claimed_squares(claims)).to eq 3
  end
end

describe 'unconflicting_claims' do
  it 'returns ids for claims that do not overlap with any others' do
    claims = [
      { id: '1', x: 1, y: 3, width: 2, height: 2 },
      { id: '2', x: 0, y: 3, width: 2, height: 1 },
      { id: '3', x: 0, y: 0, width: 1, height: 1 },
      { id: '4', x: 5, y: 5, width: 1, height: 1 }
    ]
    squares = {
      '1x3' => 2, '1x4' => 1, '2x3' => 1, '2x4' => 1, '0x3' => 1, '0x0' => 1, '5x5' => 1
    }
    expected_result = ['3', '4']
    expect(unconflicting_claims(squares, claims)).to eq expected_result
  end
end
