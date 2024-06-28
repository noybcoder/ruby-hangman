require_relative 'errors'

class Computer
  include CustomErrors

  class << self
    attr_accessor :computer_count
  end

  COMPUTER_LIMIT = 1
  @computer_count = 0

  def initialize
    self.class.computer_count += 1
    handle_game_violations(ComputerLimitViolation, self.class.computer_count, COMPUTER_LIMIT)
  end

  def read_dictionary(file='google-10000-english-no-swears.txt')
    File.read(file)
  end
end

c1 = Computer.new
p c1.read_dictionary.class
