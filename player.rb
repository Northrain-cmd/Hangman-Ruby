# frozen_string_literal: true

# manages player behavior
class Player
  attr_accessor :name
  def initialize
    set_player_name
  end

  def guess_letter
    letter = ''
    loop do
      puts '', 'Type the letter you want to guess'
      letter = gets.chomp.downcase
      break if letter.length == 1 && letter.match(/[a-z]/) || letter == 'save'
    end
    letter
  end

  private

  def set_player_name
    input = ''
    loop do
      puts 'Please enter your name'
      input = gets.chomp
      break unless input.empty?
    end
    @name = input
  end
end
