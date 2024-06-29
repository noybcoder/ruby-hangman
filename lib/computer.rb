require_relative 'errors'

class Computer
  include CustomErrors

  class << self
    attr_accessor :computer_count
  end

  COMPUTER_LIMIT = 1
  @computer_count = 0

  attr_reader :secret_word

  def initialize
    @secret_word = select_random_word(read_dictionary)
    self.class.computer_count += 1
    handle_game_violations(ComputerLimitViolation, self.class.computer_count, COMPUTER_LIMIT)
  end

  def read_dictionary(file='google-10000-english-no-swears.txt', sep="\n")
    File.read(file).split(sep)
  end

  def filter_words(dictionary)
    dictionary.select{ |word| word.length.between?(5, 12)}
  end

  def select_random_word(dictionary)
    filter_words(dictionary).sample
  end
end

# c1 = Computer.new

# p c1.secret_word
