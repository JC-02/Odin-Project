# frozen_string_literal: true

# Player class to manage player information
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end
