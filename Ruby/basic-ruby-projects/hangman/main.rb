require_relative 'lib/hangman'

def main
  puts "HANGMAN"
  puts "======="
  puts "1. New Game"
  puts "2. Load Game"
  print "\nSelect an option: "
  
  choice = gets.chomp
  
  case choice
  when '1'
    game = Hangman.new
    game.play
  when '2'
    game = Serializable.load_game
    game.play if game
  else
    puts "Invalid option. Exiting."
  end
end

main if __FILE__ == $0
