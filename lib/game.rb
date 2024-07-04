# frozen_string_literal: true

require_relative 'player'
require_relative 'computer'
require_relative 'visualizable'
require 'json'

class Game
  include Visualizable
  attr_accessor :player, :computer, :tries, :guess, :wrong_letters

  def initialize
    @player = Player.new
    @computer = Computer.new
    @tries = 10
    @guess = Array.new(computer.secret_word.length, ' ')
    @wrong_letters = []
  end

  def play
    load_progress
    until win? || lose?
      display_stats('Tries left', @tries, :yellow)
      update_progress
      display_stats('Guess', style_guess(@guess), :darkgreen, ' ')
      display_hangman(@tries, :saddlebrown)
      display_stats('Wrong letters', @wrong_letters, :red, ', ')
      save_progress
      if win?
        puts '\nYou got it!'
      elsif lose?
        puts "\nYou lose! The answer is \"#{computer.secret_word}\"."
      end
    end
  end

  def load_progress(file_name = 'save.txt')
    from_json(file_name) if player.load_game == 'y'
  end

  def from_json(file_name)
    save = read_save(file_name)
    @player = Player.deserialize(save['player'])
    @computer = Computer.deserialize(save['computer'])
    @tries = save['tries']
    @guess = save['guess']
    @wrong_letters = save['wrong_letters']
  end

  def read_save(file_name)
    save = File.read(file_name)
    JSON.parse(save)
  end

  def save_progress(file_name = 'save.txt')
    save = to_json if !(lose? || win?) && player.save_game == 'y'
    write_save(save, file_name)
  end

  def to_json(*_args)
    JSON.dump({
                player: @player.serialize,
                computer: @computer.serialize,
                tries: @tries,
                guess: @guess,
                wrong_letters: @wrong_letters
              })
  end

  def write_save(save, file_name)
    game_file = File.open(file_name, 'w')
    game_file.write(save)
    game_file.close
  end

  def update_progress
    guess = player.make_guess(@wrong_letters, @guess)
    answer = computer.secret_word

    guess_matched_indices = get_guess_matched_indices(guess, answer)

    if incorrect_guess?(guess_matched_indices)
      @tries -= 1
      store_wrong_letters(guess)
    else
      update_display(guess_matched_indices, guess)
    end
  end

  def win?(symbol = ' ')
    @guess.none?(symbol)
  end

  def lose?
    @tries.zero? && !win?
  end

  def get_guess_matched_indices(guess, answer)
    answer.chars.each_index.select { |idx| answer[idx] == guess }
  end

  def incorrect_guess?(guess_match_indices)
    guess_match_indices.empty?
  end

  def store_wrong_letters(guess)
    @wrong_letters << guess
  end

  def update_display(guess_match_indices, guess)
    guess_match_indices.each { |idx| @guess[idx] = guess }
  end
end

game = Game.new

game.play
