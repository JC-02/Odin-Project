require_relative 'lib/hangman_window'

begin
  HangmanWindow.new.show
rescue LoadError => e
  puts "Failed to load gosu. Please make sure the 'gosu' gem is installed."
  puts "Error: #{e.message}"
end
