# frozen_string_literal: true

# Manages computer behavior
class Computer
  def pick_word
    file = File.open('5desk.txt')
    words = file.readlines.map(&:chomp)
    file.close
    random_word(words)
  end

  private

  def random_word(words)
    word = ''
    loop do
      word = words.sample
      break if word.length >= 5 && word.length <= 12
    end
    word.downcase
  end
end
