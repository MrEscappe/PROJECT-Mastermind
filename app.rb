# frozen_string_literal: true

# the player have to guess the 4 numbers,
#  before the game is over

NUMBERS = %w[1 2 3 4 5 6].sample(4)

class Player
  attr_accessor :name, :guess, :player_input

  def initialize
    @name = ''
    puts "Hello, What's Your name?"
    @name = gets.chomp
    puts "Hello #{@name}, Let's Play!"
    puts ''
  end

  def player_guess
    @player_input = []
    i = false
    puts "What's your guess? Choose 4 numbers between(1-6)."
    until i == true
      input = gets.chomp
      if /[1-6]{4}/.match?(input) && input.length == 4
        i = true
        @player_input = input.split('')
        return @player_input
      else
        puts 'Please, input only 4 numbers between (1-6)'
      end
    end
  end
end

class Mastermind
  attr_accessor :guess, :player

  def initialize
    p @numbers = NUMBERS
    @player = Player.new
    game_mode
    @hint = []
  end

  def game_mode
    @answer = ''
    puts "Hello #{@player.name}, do you want to play what mode?"
    puts '1 - Code Breaker'
    puts '2 - Code Maker'
    puts ''
    puts 'Please choose an option:'
    @answer = gets.chomp
    @answer = gets.chomp until @answer == '1' || @answer == '2'
    case @answer
    when '1'
      puts 'Great you choose Code Breaker!'
      sleep(1)
      system 'clear'
      code_breaker
    when '2'
      puts 'Great you choose Code Maker!'
      puts ''
      sleep(1)
    end
  end

  def game
    count = 10
    until count < -1
      @guess = @player.player_guess
      if @guess == @numbers
        puts 'Great You cracked the code!'
        sleep(1)
        play_again
        # break
      else
        hints
        result
        count -= 1
        puts "Wrong, you have #{count} chances"
      end
    end
  end

  def hints
    i = 0
    while i < @guess.length
      @hint[i] = if @guess[i] == @numbers[i]
                   '✓'
                 elsif @numbers.include?(@guess[i])
                   '●'
                 else
                   '×'
                 end
      i += 1
    end
    @hint
  end

  def result
    puts ''
    puts '       Exact = ✓, Close = ●, Wrong = ×'
    puts "Guess: #{guess[0]}-#{guess[1]}-#{guess[2]}-#{guess[3]}"
    puts "Hints: #{@hint[0]}-#{@hint[1]}-#{@hint[2]}-#{@hint[3]}"
    puts ''
  end

  def play_again
    puts 'Do you want to play again? (Y/N)'
    input = gets.chomp.downcase
    case input
    when 'y'
      system 'clear'
      load './app.rb'
    when 'n'
      exit
    else
      puts 'Please enter either Y or N.'
    end
  end
end

games = Mastermind.new
games.game
