# frozen_string_literal: true

require_relative 'computer'
require_relative 'player'

# Handles game logic
class GameController
  attr_accessor :computer, :player
  def initialize
    @player = Player.new
    @computer = Computer.new
  end

  def new_game
    puts welcome_message
    @computer.pick_word
    game_cycle
  end

  private

  def game_cycle
    @player.guess_letter
  end

  def welcome_message
    <<-WELCOME
                    Welcome to Hangman!
    You will have to guess a random word 5-12 characters long.
    Each turn you can guess one letter and it will be shown in all positions in the word.
    You can have 8 incorrect guesses before you lose.
    Good luck!
    WELCOME
  end
end

controller = GameController.new
controller.new_game
