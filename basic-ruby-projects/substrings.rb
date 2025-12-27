def substrings(text, dictionary)
  # Handle nil or invalid inputs gracefully
  return {} unless text.is_a?(String) && dictionary.is_a?(Array)

  result = Hash.new(0)
  lowered_text = text.downcase

  dictionary.each do |word|
    # Skip non-string elements in dictionary or empty strings
    next unless word.is_a?(String) && !word.empty?

    word_to_find = word.downcase
    # Use scan to find all occurrences of the word in the text.
    # Note: scan(string) matches literally, which is what we want.
    matches = lowered_text.scan(word_to_find).length
    result[word] = matches if matches > 0
  end

  result
end

# --- Test Runner ---
def run_test(name, text, dictionary, expected)
  puts "Test: #{name}"
  result = substrings(text, dictionary)
  if result == expected
    puts "  [PASS] Result: #{result}"
  else
    puts '  [FAIL]'
    puts "    Expected: #{expected}"
    puts "    Got:      #{result}"
  end
  result == expected
end

if __FILE__ == $0
  puts "Running Comprehensive Substrings Tests...\n\n"

  dictionary = %w[below down go going horn how howdy it i low own part partner
                  sit]
  all_passed = true

  # Original Assignment Tests
  all_passed &= run_test('Basic single word', 'below', dictionary, { 'below' => 1, 'low' => 1 })
  all_passed &= run_test('Multi-word sentence', "Howdy partner, sit down! How's it going?", dictionary,
                         { 'down' => 1, 'go' => 1, 'going' => 1, 'how' => 2, 'howdy' => 1, 'it' => 2, 'i' => 3, 'own' => 1, 'part' => 1, 'partner' => 1, 'sit' => 1 })

  # Edge Cases: Punctuation and Case
  all_passed &= run_test('Punctuation handling', '!!BELOW!!', dictionary, { 'below' => 1, 'low' => 1 })
  all_passed &= run_test('Case insensitivity in text', 'Go Go GO!', ['go'], { 'go' => 3 })
  all_passed &= run_test('Case insensitivity in dictionary', 'go', ['GO'], { 'GO' => 1 })

  # Edge Cases: Overlaps
  all_passed &= run_test('Overlapping identical substrings', 'aaaaa', ['aa'], { 'aa' => 2 }) # 'aa' found at indices 0, 2 (scan jumps)
  # Note: Ruby's scan("aa") on "aaaaa" finds index 0 and then index 2.
  # If we wanted every single overlapping possibility (0,1,2,3), we'd need a different approach,
  # but standard scan is usually acceptable for this exercise unless specified.

  # Edge Cases: Empty inputs
  all_passed &= run_test('Empty string text', '', dictionary, {})
  all_passed &= run_test('Empty dictionary', 'hello', [], {})
  all_passed &= run_test('Empty dictionary entry', 'hello', [''], {})

  # Error Handling: Invalid Arguments
  all_passed &= run_test('Nil text', nil, dictionary, {})
  all_passed &= run_test('Nil dictionary', 'hello', nil, {})
  all_passed &= run_test('Non-string text (Integer)', 123, dictionary, {})
  all_passed &= run_test('Non-array dictionary', 'hello', 'world', {})

  # Dictionary with mixed types
  all_passed &= run_test('Mixed types in dictionary', 'hello 123', ['hello', 123, nil, '123'],
                         { 'hello' => 1, '123' => 1 })

  # Complex Substrings
  all_passed &= run_test('Substrings with symbols', 'he.llo', ['he', '.', 'lo'], { 'he' => 1, '.' => 1, 'lo' => 1 })

  puts "\n" + ('=' * 30)
  if all_passed
    puts 'ALL TESTS PASSED!'
  else
    puts 'SOME TESTS FAILED. CHECK OUTPUT.'
    exit 1
  end
end
