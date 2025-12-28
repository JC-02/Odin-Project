require_relative 'player'

module Mastermind
  class HumanPlayer < Player
    def create_code
      puts "Choose 4 colors (numbers 1-6) for your secret code (e.g., 1 2 3 4):"
      get_valid_input
    end

    def make_guess(board)
      puts "Enter your guess (4 numbers between 1-6, separated by spaces):"
      get_valid_input
    end

    private

    def get_valid_input
      loop do
        input = gets.chomp.split
        if input.length == 4 && input.all? { |c| @colors.include?(c) }
          return input
        end
        puts "Invalid input. Please enter 4 numbers between 1 and 6."
      end
    end
  end
end
