# frozen_string_literal: true

require 'json'
require_relative 'computer'
require_relative 'player'

# Handles saving and loading the game
module SaveAndLoad
  def load_game
    filenames = show_saves
    index = ''
    index = gets.chomp until index.match(/^\d+$/)
    file = File.open(filenames[index.to_i - 1].to_s)
    state = JSON.parse(file.read)
    update_state(state)
    file.close
  end

  def save_game
    state = {
      word: @word,
      wrong_guesses: @wrong_guesses,
      tried_letters: @tried_letters,
      word_arr: @word_arr
    }

    File.open("./saved_games/#{file_name}.json", 'w') { |f| f.write state.to_json }
    puts 'Game saved successfully'
  end

  private

  def show_saves
    filenames = Dir.glob('saved_games/*').select { |e| File.file? e }
    filenames.each_with_index do |filename, index|
      puts "[#{index + 1}] #{filename}"
    end
    filenames
  end

  def update_state(state)
    @word = state['word']
    p @word
    @word_arr = state['word_arr']
    @tried_letters = state['tried_letters']
    @wrong_guesses = state['wrong_guesses']
    puts 'Game loaded successfully'
  end
end

WELCOME_MESSAGE =
  <<~WELCOME
                      Welcome to Hangman!
    You will have to guess a random word 5-12 characters long.
    Each turn you can guess one letter and it will be shown in all positions in the word.
    You can have 8 incorrect guesses before you lose.
    Good luck!
  WELCOME

# Handles game logic
class GameController
  include SaveAndLoad
  attr_accessor :computer, :player, :word, :word_arr, :wrong_guesses,
                :tried_letters, :game_over
  def initialize
    @player = Player.new
    @computer = Computer.new
  end

  def new_game
    puts WELCOME_MESSAGE
    init_game
    p @word
    print_status
    game_cycle until @wrong_guesses.zero? || @game_over
    declare_winner
    new_game?
  end

  private

  def print_status
    puts wrong_guesses.to_s + ' Wrong guesses left', @word_arr.join('  '),
         '', 'Letters tried: ' + @tried_letters.join(', ')
  end

  def init_game
    @game_over = false
    @word = @computer.pick_word
    @wrong_guesses = 8
    @tried_letters = []
    @word_arr = Array.new(@word.length, '___')
  end

  def file_name
    puts 'Please enter the name of the saved game'
    input = ''
    loop do
      input = gets.chomp
      break unless input.empty?
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
    letter = check_input
    input_action(letter)
    letter
  end

  def input_action(letter)
    case letter
    when 'save'
      save_game
    when 'load'
      load_game
      print_status
    else
      @tried_letters.push(letter)
    end
  end

  def check_input
    letter = ''
    letter = @player.guess_letter(@tried_letters) while @tried_letters.include?(letter) &&
                                                        letter != 'save' &&
                                                        letter != 'load'
    letter
  end

  def game_cycle
    letter = pick_letter
    return unless letter.length == 1

    @word.each_char.with_index do |char, index|
      @word_arr[index] = char if char == letter
    end
    @wrong_guesses -= 1 unless @word.include?(letter)
    print_status
    game_over?
  end
end

controller = GameController.new
controller.new_game
