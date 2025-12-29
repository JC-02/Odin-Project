module Mastermind
  class Player
    attr_accessor :name, :secret_code

    def initialize(name)
      @name = name
      @colors = %w[1 2 3 4 5 6]
    end

    def compare(guess, secret)
      exact = 0
      color = 0
      
      temp_guess = guess.dup
      temp_secret = secret.dup

      temp_guess.each_with_index do |val, idx|
        if val == temp_secret[idx]
          exact += 1
          temp_guess[idx] = nil
          temp_secret[idx] = nil
        end
      end

      temp_guess.compact.each do |val|
        if (match_idx = temp_secret.index(val))
          color += 1
          temp_secret[match_idx] = nil
        end
      end

      { exact: exact, color: color }
    end

    def give_feedback(guess)
      compare(guess, @secret_code)
    end
  end
end
