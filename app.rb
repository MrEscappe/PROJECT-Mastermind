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
end

class Mastermind
  attr_accessor :guess, :player, :player_input, :hint, :code, :computer_guess

  def initialize
    @player = Player.new
    @computer_player = ComputerCodeBreak.new
    @mode = 0
    @guess = ''
    game_set_up
    @code = []
    @hint = []
  end

  def game_set_up
    game_mode
    case @mode
    when 1
      game
    when 2
      code_maker
    end
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
      @mode = 1
      sleep(1)
      system 'clear'
    when '2'
      puts 'Great you choose Code Maker!'
      @mode = 2
      puts ''
      sleep(1)
    end
  end

  def code_breaker
    @numbers = NUMBERS
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

  def code_maker
    i = false
    @code = ''
    system 'clear'
    puts 'Please choose four numbers between (1-6) to make your code:'
    until i == true
      input = gets.chomp
      if /[1-6]{4}/.match?(input) && input.length == 4
        i = true
        @code = input.split('')
        @code
        computer_brake
      else
        puts 'Please, choose only 4 numbers between (1-6) to make your code.'
      end
    end
  end

  def computer_brake
    count = 10
    until count < 1
      if count == 10
        @computer_guess = @computer_player.initial_guess
      else
        @computer_guess = @computer_player.final_array
        @computer_player.temp = []
      end
      puts "Guess Number: #{count}"
      computer_hints

      puts 'The computer is making his guess:'
      3.times do
        print('.')
        sleep(1)
      end

      computer_result
      @computer_player.logic(@hint, @computer_guess)
      @computer_player.any_nil?
      @computer_player.final_array

      if @computer_guess == @code
        puts ''
        puts 'Oh No! The Computer cracks the code!'
        sleep(1)
        play_again
      else
        count -= 1
        puts "HAHHAA WRONG COMPUTER! You have #{count} chances"
        puts ''
      end
    end
  end

  def computer_hints
    i = 0
    @hint = []
    while i < @computer_guess.length
      @hint[i] = if @computer_guess[i] == @code[i]
                   '✓'
                 elsif @code.include?(@computer_guess[i])
                   '●'
                 else
                   '×'
                 end
      i += 1
    end
    @hint
  end

  def computer_result
    puts ''
    puts '       Exact = ✓, Close = ●, Wrong = ×'
    puts "Guess: #{computer_guess[0]}-#{computer_guess[1]}-#{computer_guess[2]}-#{computer_guess[3]}"
    puts "Hints: #{@hint[0]}-#{@hint[1]}-#{@hint[2]}-#{@hint[3]}"
    puts ''
    sleep(1)
  end

  def game
    count = 10
    until count < 1
      @guess = code_breaker
      if @guess == @numbers
        puts ''
        puts 'Great You cracked the code!'
        sleep(1)
        play_again
        # break
      else
        hints
        result
        count -= 1
        puts "Wrong, you have #{count} chances"
        puts ''
      end
    end
  end

  def hints
    i = 0
    @hint = []
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

class ComputerCodeBreak
  attr_accessor :sample, :temp, :final_array, :possible_numbers

  def initialize
    start_code
    @temp = Array.new(4)
    @initial_guess = []
    @free_indexes = []
    @final_guess = []
    @final_array = []
  end

  def start_code
    @sample = %w[1 2 3 4 5 6].sample(4)
    @possible_numbers = %w[1 2 3 4 5 6]
  end

  def initial_guess
    while @initial_guess.size < 4
      @initial_guess = @sample
      @initial_guess.uniq!
      return @initial_guess
    end
  end

  def logic(hint, guess)
    i = 0
    while i < hint.size
      case hint[i]
      when '✓'
        @temp[i] = guess[i]
        @possible_numbers.delete(guess[i])
      when '●'
        find_empty_idx
        @temp[@new_index] = if @temp.count(guess[i]) > 1 || @final_array.count(guess[1]) > 1
                              choose_random_number(guess[i])
                            else
                              guess[i]
                            end
      when '×'
        @possible_numbers.delete(guess[i])
        @temp[i] = @possible_numbers[rand(@possible_numbers.size)]
      end
      i += 1
    end
    @final_array = @temp
    @final_array
  end

  def any_nil?
    i = 0
    while i < 4
      @temp[i] = @possible_numbers[rand(@possible_numbers.length)] if @temp[i].nil?
      i += 1
    end
    @final_array = @temp
    @final_array
  end

  def choose_random_number(number)
    new_number = number
    new_number = @possible_numbers[rand(@possible_numbers.size)] while new_number == number
    new_number
  end

  def find_empty_idx
    i = 0
    @free_indexes.clear
    while i < 4
      @free_indexes << i if @temp[i].nil?
      i += 1
    end
    @new_index = @free_indexes[rand(@free_indexes.size)]
    @new_index
  end
end

games = Mastermind.new
# games.game
