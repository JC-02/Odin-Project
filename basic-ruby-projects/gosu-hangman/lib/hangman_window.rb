require 'gosu'
require 'yaml'

module Serializable
  def save_state(filename)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open("saves/#{filename}.yaml", 'w') { |file| file.write(YAML.dump(self)) }
  end

  def self.load_state(filename)
    path = "saves/#{filename}.yaml"
    return nil unless File.exist?(path)
    YAML.safe_load(File.read(path), permitted_classes: [Symbol, HangmanWindow])
  end
end

class HangmanWindow < Gosu::Window
  include Serializable

  WIDTH = 1000
  HEIGHT = 800
  DICTIONARY_PATH = File.join(File.dirname(__FILE__), '..', 'data', 'dictionary.txt')
  MAX_MISSES = 8

  def initialize
    super WIDTH, HEIGHT
    self.caption = "Gosu Hangman - Keyboard Edition"
    
    @font = Gosu::Font.new(32)
    @small_font = Gosu::Font.new(24)
    @large_font = Gosu::Font.new(64)
    
    reset_game
  end

  def reset_game
    @word = select_word
    @correct_guesses = []
    @incorrect_guesses = []
    @game_status = :playing # :playing, :won, :lost
    @message = "Type any letter to start guessing!"
  end

  def select_word
    dictionary = File.readlines(DICTIONARY_PATH).map(&:chomp)
    eligible_words = dictionary.select { |word| word.length.between?(5, 12) }
    eligible_words.sample.downcase
  end

  def draw
    draw_background
    draw_hangman
    draw_game_info
    draw_status_and_controls
  end

  def draw_background
    draw_quad(0, 0, 0xff_1e1e2e, WIDTH, 0, 0xff_1e1e2e, WIDTH, HEIGHT, 0xff_181825, 0, HEIGHT, 0xff_181825)
  end

  def draw_hangman
    color = 0xff_cdd6f4
    x = 250
    y = 550
    misses = @incorrect_guesses.length

    # 1. Base
    draw_line(x - 80, y, color, x + 80, y, color) if misses >= 1
    # 2. Vertical Pole
    draw_line(x, y, color, x, y - 400, color) if misses >= 2
    # 3. Horizontal Beam
    draw_line(x, y - 400, color, x + 200, y - 400, color) if misses >= 3
    # 4. Rope
    draw_line(x + 200, y - 400, color, x + 200, y - 340, color) if misses >= 4
    # 5. Head
    draw_rect(x + 175, y - 340, 50, 50, color, 0) if misses >= 5
    # 6. Body
    draw_line(x + 200, y - 290, color, x + 200, y - 150, color) if misses >= 6
    # 7. Arms
    if misses >= 7
      draw_line(x + 200, y - 270, color, x + 150, y - 220, color)
      draw_line(x + 200, y - 270, color, x + 250, y - 220, color)
    end
    # 8. Legs
    if misses >= 8
      draw_line(x + 200, y - 150, color, x + 160, y - 60, color)
      draw_line(x + 200, y - 150, color, x + 240, y - 60, color)
    end
  end

  def draw_game_info
    # Word Display
    display_word = @word.split('').map { |char| @correct_guesses.include?(char) ? char.upcase : '_' }.join(' ')
    w_width = @large_font.text_width(display_word)
    @large_font.draw_text(display_word, 500 + (500 - w_width) / 2, 200, 1, 1.0, 1.0, 0xff_f5e0dc)

    # Misses info
    @font.draw_text("Incorrect Guesses:", 550, 350, 1, 1.0, 1.0, 0xff_f38ba8)
    @font.draw_text(@incorrect_guesses.join(', ').upcase, 550, 400, 1, 1.0, 1.0, 0xff_f38ba8)
    @font.draw_text("Guesses Remaining: #{MAX_MISSES - @incorrect_guesses.length}", 550, 480, 1, 1.0, 1.0, 0xff_fab387)
  end

  def draw_status_and_controls
    # Message / Status
    color = case @game_status
            when :won then 0xff_a6e3a1
            when :lost then 0xff_f38ba8
            else 0xff_cdd6f4
            end
    
    status_text = case @game_status
                  when :won then "VICTORY! Word: #{@word.upcase}"
                  when :lost then "DEFEAT! Word: #{@word.upcase}"
                  else @message
                  end
    
    m_width = @font.text_width(status_text)
    @font.draw_text(status_text, (WIDTH - m_width) / 2, 50, 1, 1.0, 1.0, color)

    # Sidebar Controls (Mapped to numbers)
    @small_font.draw_text("[1] Save Game", 20, 20, 1, 1.0, 1.0, 0xff_94e2d5)
    @small_font.draw_text("[2] Load Latest", 20, 50, 1, 1.0, 1.0, 0xff_94e2d5)
    
    if @game_status != :playing
      @font.draw_text("Press [3] to Restart", 550, 600, 1, 1.0, 1.0, 0xff_a6e3a1)
    end
  end

  def button_down(id)
    case id
    when Gosu::KB_1
      save_state("gosu_save")
      @message = "Game Saved!"
    when Gosu::KB_2
      load_game_file
    when Gosu::KB_3
      reset_game if @game_status != :playing
    else
      # Handle letter guessing
      char = Gosu.button_id_to_char(id)
      if char && char.match?(/^[a-z]$/i)
        process_guess(char.downcase)
      end
    end
  end

  def load_game_file
    loaded = Serializable.load_state("gosu_save")
    if loaded
      @word = loaded.instance_variable_get(:@word)
      @correct_guesses = loaded.instance_variable_get(:@correct_guesses)
      @incorrect_guesses = loaded.instance_variable_get(:@incorrect_guesses)
      @game_status = loaded.instance_variable_get(:@game_status) || :playing
      @message = "Game Loaded!"
    else
      @message = "No save found."
    end
  end

  def process_guess(guess)
    return unless @game_status == :playing
    return if (@correct_guesses + @incorrect_guesses).include?(guess)

    if @word.include?(guess)
      @correct_guesses << guess
      @message = "Correct: '#{guess.upcase}'!"
    else
      @incorrect_guesses << guess
      @message = "Incorrect: '#{guess.upcase}'!"
    end

    check_game_over
  end

  def check_game_over
    if @word.split('').all? { |char| @correct_guesses.include?(char) }
      @game_status = :won
    elsif @incorrect_guesses.length >= MAX_MISSES
      @game_status = :lost
    end
  end

  def draw_rect(x, y, w, h, color, z)
    draw_quad(x, y, color, x + w, y, color, x + w, y + h, color, x, y + h, color, z)
  end
end
