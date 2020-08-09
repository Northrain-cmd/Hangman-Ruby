# frozen_string_literal: true

require 'json'
require_relative 'computer'
require_relative 'player'

# Handles game logic
class GameController
  attr_accessor :computer, :player, :word, :word_arr, :wrong_guesses,
                :tried_letters, :game_over
  def initialize
    @player = Player.new
    @computer = Computer.new
  end

  def new_game
    puts welcome_message
    @game_over = false
    @word = @computer.pick_word
    @wrong_guesses = 8
    @tried_letters = []
    @word_arr = Array.new(@word.length, '___')
    p @word
    game_cycle until @wrong_guesses.zero? || @game_over
    declare_winner
    new_game?
  end

  private

  def save_game
    state = {
      word: @word,
      wrong_guesses: @wrong_guesses,
      tried_letters: @tried_letters,
      word_arr: @word_arr
    }

    File.open("./saved_games/#{file_name}", 'w'){ |f| f.write state.to_json }
  end

  def file_name
    puts 'Please enter the name of the saved game'
    input = ''
    loop do 
      input = gets.chomp
      break if input.length > 1
    end
    input
  end

  def new_game?
    puts 'Would you like to play again?', '[Y] Yes', '[N] No'
    answer = gets.chomp.downcase
    new_game if answer == 'y'
  end

  def declare_winner
    if game_over?
      puts 'Congratulations!',
           'You have guessed the word correctly'
    else
      puts 'Sorry, you lost this time',
           'The word was: ' + @word
    end
  end

  def game_over?
    @game_over = true unless @word_arr.include?('___')
  end

  def pick_letter
    letter = ''
    letter = @player.guess_letter while @tried_letters.include?(letter) && letter != 'save'
    if letter == 'save'
      save_game
      pick_letter
    else
      @tried_letters.push(letter)
      letter
    end
  end

  def game_cycle
    letter = pick_letter
    @word.each_char.with_index do |char, index|
      @word_arr[index] = char if char == letter
    end
    @wrong_guesses -= 1 unless @word.include?(letter)
    game_over?
    puts wrong_guesses.to_s + ' Wrong guesses left', @word_arr.join('  '),
         '', 'Letters tried: ' + @tried_letters.join(', ')
  end

  def welcome_message
    <<-WELCOME
                    Welcome to Hangman, #{@player.name}!
    You will have to guess a random word 5-12 characters long.
    Each turn you can guess one letter and it will be shown in all positions in the word.
    You can have 8 incorrect guesses before you lose.
    Good luck!
    WELCOME
  end
end

controller = GameController.new
controller.new_game
