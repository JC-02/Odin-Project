# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Game class to manage game flow and logic
class Game
  def initialize
    @board = Board.new
    @players = []
    @current_player_index = 0
  end

  def play
    setup_players
    @board.display

    loop do
      turn
      @board.display

      if @board.win?(current_player.symbol)
        puts "Congratulations! #{current_player.name} wins!"
        break
      elsif @board.full?
        puts "It's a draw!"
        break
      end

      switch_player
    end
  end

  private

  def setup_players
    puts 'Welcome to Tic-Tac-Toe!'
    print 'Enter name for Player 1 (X): '
    name1 = gets.chomp
    @players << Player.new(name1, 'X')

    print 'Enter name for Player 2 (O): '
    name2 = gets.chomp
    @players << Player.new(name2, 'O')
  end

  def turn
    puts "#{current_player.name}'s turn (#{current_player.symbol})"
    loop do
      print 'Enter position (1-9): '
      input = gets.chomp.to_i
      if input.between?(1, 9) && @board.update(input, current_player.symbol)
        break
      else
        puts 'Invalid move! Please try again.'
      end
    end
  end

  def current_player
    @players[@current_player_index]
  end

  def switch_player
    @current_player_index = (@current_player_index + 1) % 2
  end
end
