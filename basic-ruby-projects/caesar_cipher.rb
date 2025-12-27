def caesar_cipher(string, shift)
  # Basic input validation
  return '' if string.nil? || (string.respond_to?(:empty?) && string.empty?)
  raise ArgumentError, 'First argument must be a string' unless string.is_a?(String)
  raise ArgumentError, 'Second argument must be an integer' unless shift.is_a?(Integer)

  # Normalize shift to within 0-25
  shift %= 26
  return string if shift == 0

  # Building the translation maps
  lower = 'abcdefghijklmnopqrstuvwxyz'
  upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  # Perform shift
  rotated_lower = lower[shift..-1] + lower[0...shift]
  rotated_upper = upper[shift..-1] + upper[0...shift]

  string.tr("#{lower}#{upper}", "#{rotated_lower}#{rotated_upper}")
end

# Test Runner Helper
def run_tests
  puts '========================================'
  puts '   RUNNING CAESAR CIPHER TEST SUITE     '
  puts "========================================\n"

  success_count = 0
  failure_count = 0

  test_groups = {
    'Basic Functionality' => [
      { input: ['What a string!', 5], expected: 'Bmfy f xywnsl!' },
      { input: ['Hello, World!', 7], expected: 'Olssv, Dvysk!' },
      { input: ['abc', 1], expected: 'bcd' }
    ],
    'Wrapping and Loops' => [
      { input: ['z', 1], expected: 'a' },
      { input: ['Z', 1], expected: 'A' },
      { input: ['abc', 26], expected: 'abc' },
      { input: ['abc', 52], expected: 'abc' },
      { input: ['xyz', 3], expected: 'abc' }
    ],
    'Negative Shifts' => [
      { input: ['abc', -1], expected: 'zab' },
      { input: ['abc', -26], expected: 'abc' },
      { input: ['Bmfy f xywnsl!', -5], expected: 'What a string!' }
    ],
    'Edge Cases' => [
      { input: ['', 5], expected: '' },
      { input: ['1234567890', 10], expected: '1234567890' },
      { input: ["!@\#$%^&*()", 5], expected: "!@\#$%^&*()" },
      { input: ['   ', 3], expected: '   ' },
      { input: ['Mixed 123 Cases!!!', 1], expected: 'Njyfe 123 Dbtft!!!' }
    ],
    'Large Shifts' => [
      { input: ['abc', 1000], expected: 'mno' }, # 1000 % 26 = 12. abc + 12 = mno
      { input: ['abc', -1000], expected: 'opq' } # -1000 % 26 = 14. abc + 14 = opq
    ]
  }

  test_groups.each do |group_name, tests|
    puts "--- #{group_name} ---"
    tests.each do |test|
      result = caesar_cipher(*test[:input])
      if result == test[:expected]
        puts "[PASS] input: #{test[:input].inspect} -> result: #{result.inspect}"
        success_count += 1
      else
        puts "[FAIL] input: #{test[:input].inspect} -> expected: #{test[:expected].inspect}, but got: #{result.inspect}"
        failure_count += 1
      end
    rescue StandardError => e
      puts "[ERROR] input: #{test[:input].inspect} -> raised #{e.class}: #{e.message}"
      failure_count += 1
    end
    puts ''
  end

  puts '--- Error Handling ---'
  error_cases = [
    { input: [123, 5], expected_error: ArgumentError },
    { input: %w[abc 5], expected_error: ArgumentError },
    { input: [nil, 5], expected: '' } # Based on normalization in method
  ]

  error_cases.each do |test|
    result = caesar_cipher(*test[:input])
    if test[:expected] && result == test[:expected]
      puts "[PASS] input: #{test[:input].inspect} -> handled correctly as #{result.inspect}"
      success_count += 1
    else
      puts "[FAIL] input: #{test[:input].inspect} -> expected an error or specific value, got result: #{result.inspect}"
      failure_count += 1
    end
  rescue StandardError => e
    if test[:expected_error] && e.is_a?(test[:expected_error])
      puts "[PASS] input: #{test[:input].inspect} -> correctly raised #{e.class}"
      success_count += 1
    else
      puts "[FAIL] input: #{test[:input].inspect} -> raised unexpected error #{e.class}: #{e.message}"
      failure_count += 1
    end
  end

  puts "\n========================================"
  puts "TOTAL: #{success_count + failure_count} | PASSED: #{success_count} | FAILED: #{failure_count}"
  puts '========================================'
end

run_tests if __FILE__ == $0
