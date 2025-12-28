# Gosu Mastermind

A graphical implementation of the classic Mastermind game using the Gosu library.

## Features

- Graphical UI with mouse and keyboard support.
- Choice of roles: Play as the **Code Breaker** or the **Code Maker**.
- Intelligent Computer AI for both creating and breaking codes.
- 12 turns to win.

## Controls

- **Mouse**: Click color circles to select them, and click the "GUESS" button to submit.
- **Keys 1-6**: Select a color for the next available slot.
- **Backspace**: Remove the last selected color.
- **Return**: Submit your guess/code.
- **R**: Restart the game.

## Requirements

You must have the `gosu` gem installed:

```bash
gem install gosu
```

_Note: Gosu may require additional system dependencies (SDL2, etc.) depending on your OS._

## How to Play

Run the game from the project directory:

```bash
ruby main.rb
```
