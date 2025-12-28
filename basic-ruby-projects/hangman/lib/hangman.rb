require 'yaml'
require 'fileutils'

module Serializable
  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    print "Enter a name for your save file: "
    filename = gets.chomp.downcase
    File.open("saves/#{filename}.yaml", 'w') { |file| file.write(YAML.dump(self)) }
    puts "Game saved as #{filename}!"
  end

  def self.load_game
    saves = Dir.glob('saves/*.yaml')
    if saves.empty?
      puts "No saved games found."
      return nil
    end

    puts "\nSelect a saved game to load:"
    saves.each_with_index do |save, index|
      puts "#{index + 1}: #{File.basename(save, '.yaml')}"
    end

    choice = gets.chomp.to_i - 1
    if choice.between?(0, saves.length - 1)
      YAML.safe_load(File.read(saves[choice]), permitted_classes: [Symbol, Hangman])
    else
      puts "Invalid choice."
      nil
    end
  end
end

class Hangman
  include Serializable

  DICTIONARY_PATH = File.join(File.dirname(__FILE__), '..', 'data', 'dictionary.txt')
  MAX_TURNS = 8

  def initialize
    @word = select_word
    @correct_guesses = []
    @incorrect_guesses = []
    @remaining_turns = MAX_TURNS
  end

  def play
    puts "\nWelcome to Hangman!"
    
    while @remaining_turns > 0
      display_status
      guess = get_player_input
      
      if guess == 'save'
        save_game
        return
      end

      process_guess(guess)
      
      if won?
        display_status
        puts "\nCongratulations! You discovered the word: #{@word}"
        return
      end
    end

    display_status
    puts "\nGame Over! You've run out of guesses. The word was: #{@word}"
  end

  private

  def select_word
    dictionary = File.readlines(DICTIONARY_PATH).map(&:chomp)
    eligible_words = dictionary.select { |word| word.length.between?(5, 12) }
    eligible_words.sample.downcase
  end

  def display_status
    puts "\n-----------------------------------"
    puts "Remaining turns: #{@remaining_turns}"
    puts "Incorrect guesses: #{@incorrect_guesses.join(', ')}"
    display_word = @word.split('').map { |char| @correct_guesses.include?(char) ? char : '_' }.join(' ')
    puts "Word: #{display_word}"
    puts "-----------------------------------"
  end

  def get_player_input
    loop do
      print "\nEnter a letter to guess (or type 'save' to save): "
      input = gets.chomp.downcase
      return 'save' if input == 'save'
      
      if input.match?(/^[a-z]$/)
        if (@correct_guesses + @incorrect_guesses).include?(input)
          puts "You already guessed that letter!"
        else
          return input
        end
      else
        puts "Invalid input. Please enter a single letter."
      end
    end
  end

  def process_guess(guess)
    if @word.include?(guess)
      @correct_guesses << guess
      puts "\nCorrect! '#{guess}' is in the word."
    else
      @incorrect_guesses << guess
      @remaining_turns -= 1
      puts "\nIncorrect! '#{guess}' is not in the word."
    end
  end

  def won?
    @word.split('').all? { |char| @correct_guesses.include?(char) }
  end
end
