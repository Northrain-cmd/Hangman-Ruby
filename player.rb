# frozen_string_literal: true

require 'colorize'

# manages player behavior
class Player
  attr_accessor :name
  def guess_letter(tried_letters)
    letter = ''
    loop do
      input_info
      letter = gets.chomp.downcase
      break if letter.length == 1 && letter.match(/[a-z]/) || letter == 'save' || letter == 'load'
    end
    puts 'You already tried this letter!'.colorize(:red) if tried_letters.include?(letter)
    letter
  end

  def input_info
    puts '', "Type #{'save'.colorize(:green)}  to save current game",
         "Type #{'load'.colorize(:yellow)} to load a previous game",
         'Type the letter you want to guess'
  end
end
