require_relative 'lib/game_window'

begin
  window = Mastermind::GameWindow.new
  window.show
rescue LoadError => e
  puts "Error: The 'gosu' gem is not installed or dependencies are missing."
  puts "Please install it using: gem install gosu"
  puts "Details: #{e.message}"
end
