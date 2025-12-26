def bubble_sort(array)
  # Error Handling: Ensure input is an array
  unless array.is_a?(Array)
    raise ArgumentError, "Expected an Array, but got #{array.class}"
  end

  n = array.length
  return array if n <= 1

  # Optimization: Each pass, the largest element 'bubbles' to the end,
  # so we can decrease the inner loop limit.
  last_index = n - 1

  loop do
    swapped = false
    
    last_index.times do |i|
      # Error Handling: Ensure elements are comparable
      begin
        if array[i] > array[i + 1]
          array[i], array[i + 1] = array[i + 1], array[i]
          swapped = true
        end
      rescue StandardError => e
        raise TypeError, "Elements in array must be comparable: #{e.message}"
      end
    end

    # Yield current state for methodology verification if block is provided
    yield(array.dup) if block_given?

    # Optimization
    last_index -= 1
    
    break if !swapped || last_index <= 0
  end
  array
end

# Verification Helper
def assert_sorted(input, result, expected)
  if result == expected
    puts "✅ PASSED: [#{input.join(', ')}] -> [#{result.join(', ')}]"
    true
  else
    puts "❌ FAILED: Expected #{expected}, but got #{result}"
    false
  end
end

def test_suite
  puts "\n--- BUBBLE SORT COMPREHENSIVE TEST SUITE ---\n"
  
  total = 0
  passed = 0

  # 1. Basic Cases
  puts "\n[1] Basic Cases"
  cases = [
    { in: [4, 3, 78, 2, 0, 2], out: [0, 2, 2, 3, 4, 78] },
    { in: [1, 2, 3], out: [1, 2, 3] },
    { in: [3, 2, 1], out: [1, 2, 3] }
  ]
  cases.each do |c|
    total += 1
    passed += 1 if assert_sorted(c[:in], bubble_sort(c[:in].dup), c[:out])
  end

  # 2. Edge Cases
  puts "\n[2] Edge Cases"
  edge_cases = [
    { name: "Empty Array", in: [], out: [] },
    { name: "Single Element", in: [1], out: [1] },
    { name: "Negative Numbers", in: [-5, 2, -1, 0, 10], out: [-5, -1, 0, 2, 10] },
    { name: "All Identical", in: [5, 5, 5], out: [5, 5, 5] },
    { name: "Large Numbers", in: [999999, 1, 500], out: [1, 500, 999999] },
    { name: "Already Sorted", in: (1..10).to_a, out: (1..10).to_a },
    { name: "Reverse Sorted", in: (1..10).to_a.reverse, out: (1..10).to_a }
  ]
  edge_cases.each do |c|
    total += 1
    puts "Testing: #{c[:name]}"
    passed += 1 if assert_sorted(c[:in], bubble_sort(c[:in].dup), c[:out])
  end

  # 3. Methodology Verification (Intermediate Steps)
  puts "\n[3] Methodology Verification (Pass-by-Pass)"
  total += 1
  sample = [4, 1, 3, 2]
  expected_steps = [
    [1, 3, 2, 4], # 4 bubbles to end
    [1, 2, 3, 4], # 3 bubbles to pos 2
    [1, 2, 3, 4]  # final check
  ]
  actual_steps = []
  bubble_sort(sample.dup) { |state| actual_steps << state }
  
  # Note: Depending on optimization, the number of steps might vary.
  # Our implementation reduces the range, so we expect the steps.
  if actual_steps.first == expected_steps.first
    puts "✅ Methodology check: First pass correctly bubbled largest element to end."
    passed += 1
  else
    puts "❌ Methodology check failed: Found #{actual_steps[0]}, expected #{expected_steps[0]}"
  end

  # 4. Error Handling
  puts "\n[4] Error Handling"
  
  # Type Error: Not an array
  total += 1
  begin
    bubble_sort("not an array")
    puts "❌ FAILED: Did not raise ArgumentError for string input"
  rescue ArgumentError => e
    puts "✅ PASSED: Caught ArgumentError for invalid input: #{e.message}"
    passed += 1
  end

  # Type Error: Uncomparable elements
  total += 1
  begin
    bubble_sort([1, "string", 3])
    puts "❌ FAILED: Did not raise TypeError for uncomparable elements"
  rescue TypeError => e
    puts "✅ PASSED: Caught TypeError for mixed types: #{e.message}"
    passed += 1
  end

  # Nil input
  total += 1
  begin
    bubble_sort(nil)
    puts "❌ FAILED: Did not raise ArgumentError for nil"
  rescue ArgumentError
    puts "✅ PASSED: Caught ArgumentError for nil"
    passed += 1
  end

  # 5. Stress Test (Large Random Array)
  puts "\n[5] Stress Test"
  total += 1
  large_array = Array.new(100) { rand(-1000..1000) }
  result = bubble_sort(large_array.dup)
  if result == large_array.sort
    puts "✅ PASSED: Sorted 100 random integers correctly."
    passed += 1
  else
    puts "❌ FAILED: Large array sorting failed."
  end

  puts "\n--- SUMMARY ---"
  puts "Passed: #{passed} / #{total}"
  exit(passed == total ? 0 : 1)
end

if __FILE__ == $0
  test_suite
end
