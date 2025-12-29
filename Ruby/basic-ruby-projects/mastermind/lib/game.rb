require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

module Mastermind
  class Game
    MAX_TURNS = 12

    def initialize
      @board = Board.new
    end

    def play
      setup_game
      @turns = 1

      while @turns <= MAX_TURNS
        puts "\nTurn #{@turns} of #{MAX_TURNS}"
        guess = @breaker.make_guess(@board)
        feedback = @maker.give_feedback(guess)
        @board.add_turn(guess, feedback)
        @board.display

        if feedback[:exact] == 4
          announce_winner(@breaker)
          return
        end

        @turns += 1
      end

      announce_loser(@breaker)
    end

    private

    def setup_game
      puts "Would you like to be the (1) Code Maker or (2) Code Breaker?"
      choice = gets.chomp
      
      if choice == '1'
        @maker = HumanPlayer.new("Maker")
        @breaker = ComputerPlayer.new("Breaker")
      else
        @maker = ComputerPlayer.new("Maker")
        @breaker = HumanPlayer.new("Breaker")
      end

      @secret_code = @maker.create_code
      @maker.secret_code = @secret_code # Maker keeps track for feedback
    end

    def announce_winner(player)
      puts "\nCongratulations! #{player.name} guessed the code!"
    end

    def announce_loser(player)
      puts "\nGame Over! The code was not guessed. The code was #{@maker.secret_code.join(' ')}"
    end
  end
end
