# Stock Picker
# This method takes in an array of stock prices, one for each hypothetical day.
# It returns a pair of days representing the best day to buy and the best day to sell.
# Days start at 0.

def stock_picker(prices)
  # Error Handling: Check if input is a valid array with at least 2 prices
  return nil unless prices.is_a?(Array) && prices.length >= 2
  # Error Handling: Check if all elements are numbers
  return nil unless prices.all? { |price| price.is_a?(Numeric) }

  min_price = prices[0]
  min_day = 0
  max_profit = 0
  # Initialize with [0, 0] to indicate no profit possible by default
  best_days = [0, 0]

  prices.each_with_index do |current_price, current_day|
    # Potential new minimum price found
    if current_price < min_price
      min_price = current_price
      min_day = current_day
      next
    end

    # Calculate profit if we bought at the min_price found so far
    profit = current_price - min_price
    if profit > max_profit
      max_profit = profit
      best_days = [min_day, current_day]
    end
  end

  best_days
end

# Test Cases
def run_tests
  puts "Running Comprehensive Stock Picker Tests..."
  puts "=" * 40
  
  test_suites = {
    "Basic Cases" => [
      { input: [17,3,6,9,15,8,6,1,10], expected: [1, 4], desc: "Standard case from assignment" },
      { input: [1, 2, 3, 4, 5], expected: [0, 4], desc: "Continuous increase" },
      { input: [10, 1, 10], expected: [1, 2], desc: "V-shape" }
    ],
    "Edge Cases (Prices)" => [
      { input: [5, 4, 3, 2, 1], expected: [0, 0], desc: "Continuous decrease (no profit)" },
      { input: [1, 1, 1, 1], expected: [0, 0], desc: "Flat prices (no profit)" },
      { input: [10, 100, 1, 2], expected: [0, 1], desc: "Highest peak early, lowest trough late" },
      { input: [1, 100, 1, 200], expected: [0, 3], desc: "Multiple peaks" },
      { input: [5, 10, 2, 8], expected: [2, 3], desc: "Best profit can be later in the array" },
      { input: [1, 5, 1, 5], expected: [0, 1], desc: "Duplicate prices" }
    ],
    "Edge Cases (Array Size)" => [
      { input: [], expected: nil, desc: "Empty array" },
      { input: [10], expected: nil, desc: "Single element" },
      { input: [10, 20], expected: [0, 1], desc: "Two elements" }
    ],
    "Error Handling (Invalid Inputs)" => [
      { input: nil, expected: nil, desc: "Nil input" },
      { input: "not an array", expected: nil, desc: "String input" },
      { input: [1, "two", 3], expected: nil, desc: "Array with non-numeric strings" },
      { input: [1, nil, 3], expected: nil, desc: "Array with nil elements" }
    ]
  }

  total_tests = 0
  passed_tests = 0

  test_suites.each do |suite_name, tests|
    puts "\n--- #{suite_name} ---"
    tests.each do |test|
      total_tests += 1
      result = stock_picker(test[:input])
      status = (result == test[:expected]) ? "PASSED" : "FAILED"
      
      if status == "PASSED"
        passed_tests += 1
        puts " [OK] #{test[:desc]}"
      else
        puts " [!] #{test[:desc]}"
        puts "     Input: #{test[:input].inspect}"
        puts "     Expected: #{test[:expected].inspect}"
        puts "     Got: #{result.inspect}"
      end
    end
  end

  puts "\n" + "=" * 40
  puts "Final Result: #{passed_tests}/#{total_tests} tests passed."
  puts "=" * 40
end

if __FILE__ == $0
  run_tests
end
