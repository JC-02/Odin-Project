# Mastermind

A command-line implementation of the classic Mastermind game.

## Rules

- The Code Maker creates a secret code consisting of 4 colors (represented by numbers 1-6).
- The Code Breaker has 12 turns to guess the secret code.
- After each guess, the Code Maker provides feedback:
  - **Exact**: The number of colors that are correct in both color and position.
  - **Color**: The number of colors that are correct in color but in the wrong position.

## Features

- Play as either the Code Maker or the Code Breaker.
- Intelligent computer AI that uses a filtering strategy to narrow down possibilities.

## How to Play

Run the game from the root directory:

```bash
ruby main.rb
```

## Project Structure

- `main.rb`: Entry point.
- `lib/game.rb`: Main game loop and logic.
- `lib/board.rb`: Tracks and displays the game board.
- `lib/player.rb`: Base player class with feedback logic.
- `lib/human_player.rb`: Human interaction logic.
- `lib/computer_player.rb`: AI guessing and code creation logic.
