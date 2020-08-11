# frozen_string_literal: true

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
    puts 'You already tried this letter!' if tried_letters.include?(letter)
    puts 'Invalid letter' unless letter.match(/[a-z]/)
    letter
  end

  def input_info
    puts '', 'Type "save" to save current game',
         'Type load to load a previous game',
         'Type the letter you want to guess'
  end
end
