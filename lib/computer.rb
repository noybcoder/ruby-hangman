require_relative 'errors'
require 'json'

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

  def serialize
    JSON.dump({
      :computer_count => self.class.computer_count,
      :secret_word => secret_word
    })
  end

  def self.deserialize(serialized_obj)
    data = JSON.load(serialized_obj)
    computer = new
    self.class.computer_count = data['computer_count']
    computer.local_variables_set(:secret_word, secret_word)
    computer
  end
end
