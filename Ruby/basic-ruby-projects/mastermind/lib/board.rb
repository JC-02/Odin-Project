module Mastermind
  class Board
    attr_reader :history

    def initialize
      @history = []
    end

    def add_turn(guess, feedback)
      @history << { guess: guess, feedback: feedback }
    end

    def display
      puts "\n--- Game Board ---"
      @history.each_with_index do |turn, index|
        guess_str = turn[:guess].join(" ")
        feedback_str = "Exact: #{turn[:feedback][:exact]} | Color: #{turn[:feedback][:color]}"
        puts "Turn #{index + 1}: [ #{guess_str} ] - #{feedback_str}"
      end
      puts "------------------\n"
    end
  end
end
