# frozen_string_literal: true

# CustomErrors module defines custom error classes for the Mastermind game.
module CustomErrors
  # PlayerLimitViolation class represents an error when the number of players exceeds the limit.
  class PlayerLimitViolation < StandardError
    # Public: Initializes a new PlayerLimitViolation instance.
    #
    # msg - The message to be displayed for the error (default: 'Mastermind only allows up to 2 players.').
    # exception_type - The type of exception (default: 'custom').
    #
    # Returns a new PlayerLimitViolation object.
    def initialize(msg = 'Hangman only allows 1 player.', exception_type = 'custom')
      @exception_type = exception_type
      super(msg)
    end
  end

  # PlayerLimitViolation class represents an error when the number of players exceeds the limit.
  class ComputerLimitViolation < StandardError
    # Public: Initializes a new PlayerLimitViolation instance.
    #
    # msg - The message to be displayed for the error (default: 'Mastermind only allows up to 2 players.').
    # exception_type - The type of exception (default: 'custom').
    #
    # Returns a new PlayerLimitViolation object.
    def initialize(msg = 'Hangman only allows 1 computer.', exception_type = 'custom')
      @exception_type = exception_type
      super(msg)
    end
  end

  def handle_game_violations(error, class_variable, limit)
    # Raise error if more than one board instance is created
    raise error if class_variable > limit
  rescue error => e
    puts e.message # Display the error message
    exit # Terminate the program
  end
end
