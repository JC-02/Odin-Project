require_relative 'player'

module Mastermind
  class ComputerPlayer < Player
    def initialize(name)
      super
      @last_guess = nil
      @possible_codes = @colors.repeated_permutation(4).to_a.map { |p| p.map(&:to_s) }
    end

    def create_code
      Array.new(4) { @colors.sample }
    end

    def make_guess(board)
      puts "Computer is thinking..."
      sleep(0.5)

      if @last_guess.nil?
        guess = ["1", "1", "2", "2"]
      else
        last_turn = board.history.last
        feedback = last_turn[:feedback]
        last_guess = last_turn[:guess]
        
        @possible_codes.select! do |potential_code|
          compare(last_guess, potential_code) == feedback
        end
        guess = @possible_codes.sample
      end

      @last_guess = guess
      guess
    end
  end
end
