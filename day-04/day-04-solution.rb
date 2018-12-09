require 'rspec'

def input
  log = []
  File.foreach('day-04-input.txt') { |line| log.push(line) }
  sort_entries(log)
end

def sort_entries(log)
  log.sort
end

def parse_entries(log)
  log_data = []
  sleep_start = nil
  log.each do |entry|
    numbers = entry.split(/\D/) - [""]
    numbers = numbers.drop(1) # get rid of the year
    if entry.include?('Guard')
      sleep_start = nil
      current_guard = { date: numbers.first(2).join('-'), id: numbers.last, asleep: [] }
      log_data.push(current_guard)
    elsif entry.include?('falls asleep')
      sleep_start = numbers[3].to_i
    else
      sleep_end = numbers[3].to_i
      asleep = (sleep_start...sleep_end).to_a
      log_data.last[:asleep].concat(asleep)
      sleep_start = nil
    end
  end
  log_data
end

def max_sleeper(log)
  mins_per_guard = {}
  log.each do |shift|
    guard = shift[:id]
    if mins_per_guard[guard].nil?
      mins_per_guard[guard] = shift[:asleep].length
    else
      mins_per_guard[guard] = mins_per_guard[guard] + shift[:asleep].length
    end
  end
  guard = mins_per_guard.max_by { |k,v| v }
  guard.first # return the key (id)
end

def max_sleep_at(log, id)
  log = log.select { |entry| entry[:id] == id }
  sleep_by_mins = {}

  log.each do |shift|
    shift[:asleep].each do |minute|
      time = minute
      if sleep_by_mins[time].nil?
        sleep_by_mins[time] = 1
      else
        sleep_by_mins[time] = sleep_by_mins[time] + 1
      end
    end
  end
  minute = sleep_by_mins.max_by { |k,v| v }
  minute.first # return the key (time)
end

# Part 1
log = input
log = parse_entries(log)
id = max_sleeper(log)
time = max_sleep_at(log, id)
puts "id: #{id}, time: #{time}, result: #{id.to_i * time.to_i}"
# Part 2
#

describe 'sort_entries' do
  it 'sorts the entries in the log alphabetically' do
    log = [
      "[1518-11-01 00:05] falls asleep",
      "[1518-11-01 00:00] Guard #10 begins shift",
      "[1518-11-01 00:25] wakes up"
      
    ]
    expected_result = [
      "[1518-11-01 00:00] Guard #10 begins shift",
      "[1518-11-01 00:05] falls asleep",
      "[1518-11-01 00:25] wakes up"
    ]
    expect(sort_entries(log)).to eq expected_result
  end
end
