require_relative 'errors'

class Player
  include CustomErrors

  class << self
    attr_accessor :player_count
  end

  PLAYER_LIMIT = 1
  @player_count = 0

  def initialize
    self.class.player_count += 1
    handle_game_violations(PlayerLimitViolation, self.class.player_count, PLAYER_LIMIT)
  end
end
