# frozen_string_literal: true

# # frozen_string_literal: true

# # the player have to guess the 4 numbers,
# # after the game is over

NUMBERS = %w[1 2 3 4 5 6].sample(4)

class Player
  attr_accessor :name

  def initialize
    puts 'Hello! Please entry your name:'
    @name = gets.chomp
  end
end

class Mastermind
  attr_accessor :guess, :count, :numbers

  def initialize
    @numbers = NUMBERS
    @player = Player.new
    @guess = []
    @hint = []
    p @numbers
    game
  end

  def game
    @count = 9
    while @count > -1
      player_guess
      if @guess == @numbers
        puts 'You Win!'
        break
      else
        puts "Try again! You have more #{@count} chances "
      end
      @count -= 1
    end
  end

  def player_guess
    puts "Hello #{@player.name}, choose 4 numbers, from 1 to 6"
    @guess = gets.chomp.split('')
    evaluate_guess
  end

  def evaluate_guess
    @result = { exact: [], near: [] }
    if @guess.include?(@numbers)
      puts 'Nice'
      @result[:exact] << true
    else
      puts 'nope'
    end
    @result
  end

  
end

games = Mastermind.new
