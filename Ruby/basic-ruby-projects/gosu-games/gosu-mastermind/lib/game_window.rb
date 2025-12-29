require 'gosu'
require_relative 'computer_player'
require_relative 'player'

module Mastermind
  class GameWindow < Gosu::Window
    WIDTH = 600
    HEIGHT = 800
    
    COLORS = {
      "1" => Gosu::Color::RED,
      "2" => Gosu::Color::GREEN,
      "3" => Gosu::Color::BLUE,
      "4" => Gosu::Color::YELLOW,
      "5" => Gosu::Color::new(255, 255, 165, 0), # Orange
      "6" => Gosu::Color::CYAN
    }

    def initialize
      super WIDTH, HEIGHT
      self.caption = "Mastermind"
      
      @font = Gosu::Font.new(24)
      @large_font = Gosu::Font.new(48)
      
      @state = :start # :start, :playing, :game_over
      @breaker_is_human = true
      
      reset_game
    end

    def reset_game
      @history = []
      @current_guess = [nil, nil, nil, nil]
      @game_over = false
      @message = "Guess the secret code!"
      
      if @state == :playing
        if @breaker_is_human
          @maker = ComputerPlayer.new("Computer")
          @breaker = nil # Human
          @secret_code = @maker.create_code
        else
          @maker = nil # Human
          @breaker = ComputerPlayer.new("Computer")
          # Waiting for human to set secret code
          @state = :set_secret
          @message = "Set your secret code!"
        end
      end
    end

    def update
      if @state == :playing && !@breaker_is_human && !@game_over
        # Slow down computer guesses
        if Gosu.milliseconds > (@last_computer_move || 0) + 1000
          computer_turn
          @last_computer_move = Gosu.milliseconds
        end
      end
    end

    def draw
      draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color::new(255, 50, 50, 50))
      
      case @state
      when :start
        draw_start_screen
      when :set_secret
        draw_board
        draw_current_selection
        draw_controls
        @font.draw_text("SET SECRET CODE", 50, 750, 1, 1.0, 1.0, Gosu::Color::YELLOW)
      when :playing, :game_over
        draw_board
        draw_current_selection
        draw_controls
        @font.draw_text(@message, 50, 750, 1, 1.0, 1.0, Gosu::Color::WHITE)
        
        if @game_over
          draw_rect(100, 300, 400, 200, Gosu::Color::new(220, 0, 0, 0))
          @large_font.draw_text("GAME OVER", 160, 350, 2, 1.0, 1.0, Gosu::Color::YELLOW)
          @font.draw_text("Press 'R' to Restart", 190, 420, 2, 1.0, 1.0, Gosu::Color::WHITE)
        end
      end
    end

    def draw_start_screen
      @large_font.draw_text("MASTERMIND", 130, 250, 1, 1.0, 1.0, Gosu::Color::WHITE)
      @font.draw_text("Select your role:", 220, 350, 1, 1.0, 1.0, Gosu::Color::YELLOW)
      
      draw_rect(150, 400, 300, 50, Gosu::Color::BLUE)
      @font.draw_text("1. BE THE BREAKER", 200, 412, 1, 1.0, 1.0, Gosu::Color::WHITE)
      
      draw_rect(150, 470, 300, 50, Gosu::Color::RED)
      @font.draw_text("2. BE THE MAKER", 215, 482, 1, 1.0, 1.0, Gosu::Color::WHITE)
    end

    def draw_board
      12.times do |i|
        y = 50 + (i * 50)
        # Draw turn number
        @font.draw_text((i + 1).to_s, 20, y + 10, 1, 1.0, 1.0, Gosu::Color::GRAY)
        
        # Draw guess slots
        4.times do |j|
          x = 60 + (j * 50)
          color = Gosu::Color::GRAY
          if @history[i]
            color = COLORS[@history[i][:guess][j]]
          end
          draw_circle(x + 20, y + 25, 15, color)
        end

        # Draw feedback slots
        if @history[i]
          fb = @history[i][:feedback]
          draw_feedback(280, y + 10, fb)
        end
      end
    end

    def draw_feedback(x, y, feedback)
      # Draw small dots for exact and color matches
      count = 0
      feedback[:exact].times do
        fx = x + (count % 2) * 20
        fy = y + (count / 2) * 20
        draw_circle(fx, fy, 6, Gosu::Color::WHITE)
        count += 1
      end
      feedback[:color].times do
        fx = x + (count % 2) * 20
        fy = y + (count / 2) * 20
        draw_circle(fx, fy, 6, Gosu::Color::GRAY)
        count += 1
      end
    end

    def draw_current_selection
      y = 680
      @font.draw_text("Selection:", 50, y - 30, 1, 1.0, 1.0, Gosu::Color::WHITE)
      4.times do |j|
        x = 60 + (j * 50)
        color = @current_guess[j] ? COLORS[@current_guess[j]] : Gosu::Color::new(255, 100, 100, 100)
        draw_circle(x + 20, y + 25, 15, color)
      end
    end

    def draw_controls
      # Palette
      @font.draw_text("Palette (1-6):", 300, 650, 1, 1.0, 1.0, Gosu::Color::WHITE)
      6.times do |i|
        x = 300 + (i * 45)
        color = COLORS[(i + 1).to_s]
        draw_circle(x + 20, 690 + 25, 15, color)
        @font.draw_text((i + 1).to_s, x + 15, 730, 1, 1.0, 1.0, Gosu::Color::WHITE)
      end
      
      # Guess button
      draw_rect(480, 740, 100, 40, Gosu::Color::GREEN)
      @font.draw_text("GUESS", 495, 748, 1, 1.0, 1.0, Gosu::Color::BLACK)
    end

    def button_down(id)
      case @state
      when :start
        handle_start_input(id)
      when :set_secret
        handle_playing_input(id)
      when :playing
        handle_playing_input(id) if @breaker_is_human
      when :game_over
        reset_to_start if id == Gosu::KB_R
      end
    end

    def handle_start_input(id)
      if id == Gosu::KB_1 || id == Gosu::MS_LEFT && mouse_x.between?(150, 450) && mouse_y.between?(400, 450)
        @breaker_is_human = true
        @state = :playing
        reset_game
      elsif id == Gosu::KB_2 || id == Gosu::MS_LEFT && mouse_x.between?(150, 450) && mouse_y.between?(470, 520)
        @breaker_is_human = false
        @state = :set_secret
        reset_game
      end
    end

    def handle_playing_input(id)
      case id
      when Gosu::KB_1..Gosu::KB_6
        val = (id - Gosu::KB_1 + 1).to_s
        if (idx = @current_guess.index(nil))
          @current_guess[idx] = val
        end
      when Gosu::KB_BACKSPACE
        if (idx = @current_guess.rindex { |v| !v.nil? })
          @current_guess[idx] = nil
        end
      when Gosu::KB_RETURN, Gosu::MS_LEFT
        if id == Gosu::MS_LEFT
          check_clicks
        else
          submit_action
        end
      when Gosu::KB_R
        reset_to_start
      end
    end

    def reset_to_start
      @state = :start
    end

    def check_clicks
      # Guess button
      if mouse_x.between?(480, 580) && mouse_y.between?(740, 780)
        submit_action
      end
      
      # Palette
      6.times do |i|
        x = 300 + (i * 45)
        if Gosu.distance(mouse_x, mouse_y, x + 20, 715) < 15
          val = (i + 1).to_s
          if (idx = @current_guess.index(nil))
            @current_guess[idx] = val
          end
        end
      end
    end

    def submit_action
      if @current_guess.all?
        if @state == :set_secret
          @secret_code = @current_guess.dup
          @state = :playing
          @message = "Computer is guessing..."
          @current_guess = [nil, nil, nil, nil]
        else
          submit_guess(@current_guess)
        end
      end
    end

    def submit_guess(guess)
      # We need a way to compare if we are the maker. 
      # Since we (human) are the maker, we'll store the secret code.
      # But wait, the feedback logic is in the Player class.
      # I'll use a temporary Player to get feedback.
      helper = Player.new("Helper")
      feedback = helper.compare(guess, @secret_code)
      
      @history << { guess: guess.dup, feedback: feedback }
      @current_guess = [nil, nil, nil, nil]
      
      if feedback[:exact] == 4
        @game_over = true
        @message = @breaker_is_human ? "You Won!" : "Computer Won!"
      elsif @history.size >= 12
        @game_over = true
        @message = @breaker_is_human ? "Game Over! Code: #{@secret_code.join(' ')}" : "Computer Lost!"
      end
    end

    def computer_turn
      guess = @breaker.make_guess(@history)
      submit_guess(guess)
    end

    def draw_circle(x, y, radius, color)
      # Simulating a circle with a polygon or just use a built-in if available
      # Gosu doesn't have a direct draw_circle, but we can draw a 20-sided polygon
      steps = 20
      angle_step = 2 * Math::PI / steps
      steps.times do |i|
        x1 = x + Math.cos(i * angle_step) * radius
        y1 = y + Math.sin(i * angle_step) * radius
        x2 = x + Math.cos((i + 1) * angle_step) * radius
        y2 = y + Math.sin((i + 1) * angle_step) * radius
        draw_triangle(x, y, color, x1, y1, color, x2, y2, color)
      end
    end
  end
end
