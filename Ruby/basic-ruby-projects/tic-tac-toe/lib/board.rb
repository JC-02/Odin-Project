# frozen_string_literal: true

# Board class to manage the 3x3 grid
class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(3) { Array.new(3, ' ') }
  end

  def display
    puts "\n"
    @grid.each_with_index do |row, i|
      puts " #{row.join(' | ')} "
      puts '-----------' unless i == 2
    end
    puts "\n"
  end

  def update(position, symbol)
    row, col = position_to_coordinates(position)
    return false if @grid[row][col] != ' '

    @grid[row][col] = symbol
    true
  end

  def full?
    @grid.flatten.none? { |cell| cell == ' ' }
  end

  def win?(symbol)
    winning_combinations.any? do |combination|
      combination.all? { |row, col| @grid[row][col] == symbol }
    end
  end

  private

  def position_to_coordinates(position)
    [(position - 1) / 3, (position - 1) % 3]
  end

  def winning_combinations
    # Rows
    rows = (0..2).map { |r| (0..2).map { |c| [r, c] } }
    # Columns
    cols = (0..2).map { |c| (0..2).map { |r| [r, c] } }
    # Diagonals
    diagonals = [
      [[0, 0], [1, 1], [2, 2]],
      [[0, 2], [1, 1], [2, 0]]
    ]
    rows + cols + diagonals
  end
end
