# Hangman

A Ruby implementation of the classic Hangman game, built as part of the Odin Project curriculum.

## Features

- **Word Selection**: Automatically selects a random word between 5 and 12 characters from a dictionary.
- **Save/Load**: Save your progress at any time and resume later.
- **Game State Tracking**: Displays correct guesses in position, incorrect guesses, and remaining turns.

## How to Run

1. Navigate to the project directory:
   ```bash
   cd basic-ruby-projects/hangman
   ```
2. Run the game:
   ```bash
   ruby main.rb
   ```

## How to Play

- When prompted, enter a single letter to guess it.
- Guesses are case-insensitive.
- To save your game, type `save` during your turn.
- To load a game, select the load option from the main menu.
