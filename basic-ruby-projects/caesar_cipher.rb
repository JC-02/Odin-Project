def caesar_cipher(string, shift)
  alphabet_lower = ('a'..'z').to_a
  alphabet_upper = ('A'..'Z').to_a

  string.chars.map do |char|
    if alphabet_lower.include?(char)
      index = alphabet_lower.find_index(char)
      new_index = (index + shift) % 26
      alphabet_lower[new_index]
    elsif alphabet_upper.include?(char)
      index = alphabet_upper.find_index(char)
      new_index = (index + shift) % 26
      alphabet_upper[new_index]
    else
      char
    end
  end.join
end

# Tests
if __FILE__ == $0
  puts "Running Caesar Cipher Tests..."
  
  test_cases = [
    { input: ["What a string!", 5], expected: "Bmfy f xywnsl!" },
    { input: ["Hello, World!", 7], expected: "Olssv, Dvysk!" },
    { input: ["Zzz", 1], expected: "Aaa" },
    { input: ["abc", 26], expected: "abc" },
    { input: ["abc", -1], expected: "zab" }
  ]

  test_cases.each_with_index do |test, i|
    result = caesar_cipher(*test[:input])
    if result == test[:expected]
      puts "Test #{i + 1} PASSED: caesar_cipher(#{test[:input].map(&:inspect).join(', ')}) => #{result.inspect}"
    else
      puts "Test #{i + 1} FAILED: caesar_cipher(#{test[:input].map(&:inspect).join(', ')}) expected #{test[:expected].inspect}, but got #{result.inspect}"
    end
  end
end
