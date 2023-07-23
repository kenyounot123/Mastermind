
#implement a way to play the game again depending if they type Y or N
module Display
  BLACK_CIRCLE =  "\u25CB"
  WHITE_CIRCLE = "\u25CF"
  def display_color(guess)
    to_display = {
        'red' => 'Red'.red,
        'blue' => 'Blue'.blue,
        'green' => 'Green'.green,
        'pink' => 'Pink'.pink,
        'cyan' => 'Cyan'.cyan,
        'yellow' => 'Yellow'.yellow,
    }
    display_colors = guess.map do |color|
      to_display[color]
    end
    return display_colors.join(' ')
  end

  def display_hints(array_of_symbols)
    return "Clues: #{array_of_symbols.join('')}"
  end

  def different_color_inputs 
    color_inputs = {
      'r' => 'red',
      'b' => 'blue',
      'g' => 'green',
      'p' => 'pink',
      'c' => 'cyan',
      'y' => 'yellow',
    }
  end

end
module Inputs
  #makes sure player is inputing a valid word
  ALL_VALID_INPUTS = ["red", "blue", "green", "pink", "cyan", "yellow", "r", "b", "g", "p", "c", "y"]
  def validate_player_input(guess)
    color_inputs = different_color_inputs
    if guess[0] == 'q'
      puts "Exiting game ..."
      exit
    end
    until valid_input(guess)
      puts "Invalid. Please try again"
      guess = gets.chomp.downcase.split(' ')
    end
    if valid_input(guess)
      proper_guess = guess.map do |color|
        color = color.downcase
        if color.length == 1 
          color = color_inputs[color]
        end
      end
      guess = proper_guess
    end
    return guess
  end

  #makes sure user input is a color that is part of the game
  def valid_input(input)
    valid_color = input.all? { |word| ALL_VALID_INPUTS.include?(word) }
    if (valid_color) && (input.length == 4)
      return valid_color
    end
  end

  def play_again_input(yes_or_no)
    if yes_or_no.downcase == 'y' 
      MastermindGame.new()
    end
    if yes_or_no.downcase == 'n'
      puts "Thank you for playing!"
      exit
    end
  end
end

class ComputerCodeMaker
  attr_accessor :computer_crafted_code
  COMPUTER_CHOICES = ["Red", "Blue", "Green", "Pink", "Cyan", "Yellow"]
  def initialize
    @computer_crafted_code = four_color_code.split(' ')
    puts "The computer has chosen a code for you to break. You will lose if you do not guess it within 12 turns\n"
  end

  def four_color_code 
    computer_code = ''
    for color in 0...4
      computer_code += COMPUTER_CHOICES[rand(1..6) - 1].downcase + ' '
    end
    return computer_code
  end
end

class PlayerCodeBreaker
  include Display
  include Inputs
  def initialize
    @turn = 1
    @win = 0
    @computer = ComputerCodeMaker.new()
    prompt_player
    player_guess
  end

  def prompt_player
    puts "It is now Turn #{@turn}
    Please type in your guess seperated by a space. Press 'q' to exit
    For example these are valid guesses:  Red Blue Purple Yellow => r b p y => R B P Y \n"
  end

  #the heart of the game
  def player_guess
    until @turn == 13 || @win == 1
      @guess = gets.chomp.downcase.split(' ')
      @guess = validate_player_input(@guess)
      puts display_color(@guess)
      puts display_hints(determine_guess(@guess))
      if @guess == @computer.computer_crafted_code
        @win = 1
        puts "You have correctly guessed the code! You win!"
        puts "Do you want to play again? Enter Y/N "
        play_again_input(gets.chomp)
      elsif @guess != @computer.computer_crafted_code && @turn == 12
        puts "You Lose! The computer generated code was #{display_color(@computer.computer_crafted_code)}"
        puts "Do you want to play again? Enter Y/N "
        play_again_input(gets.chomp)
      else
        @turn += 1
        prompt_player
      end
    end
    
  end

  #showing hint logic
  def determine_guess(guess)
    symbol_display = []
    unmatched_guess = []
    unmatched_computer_code = []
    #if there is a match , print out White cirlce to indicate that our color and index matches the computer's
    #if there is no match, put the rest of our guesses in an array and the rest of the computer's code in the array
    guess.each_with_index do |color, index|
      
      if color == @computer.computer_crafted_code[index]
        symbol_display << WHITE_CIRCLE
      else
        unmatched_guess << color
        unmatched_computer_code << @computer.computer_crafted_code[index]
      end
    end
    #check the two arrays to see if the computer's code includes any of our unmatched guesses. if it does print out Black circle and delete the computer's index that contains our unmatched guess
    unmatched_guess.each do |unmatched_color|
      if unmatched_computer_code.include?(unmatched_color)
        symbol_display << BLACK_CIRCLE
        unmatched_computer_code.delete_at(unmatched_computer_code.index(unmatched_color))
      end
    end
    symbol_display
  end
  
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def cyan
    colorize(36)
  end
end


module Instructions
  def intro
    puts <<~Intro
  
    Welcome to my Mastermind game!
  
    Mastermind is a code-breaking game for two players.
  
    In this version it's you against the computer and you get to choose if you want to be the 
    code-maker or the code-breaker
  
    The code-breaker gets 12 attempts to guess the code set by the code-maker.

    The colors are #{'Red'.red}, #{'Blue'.blue}, #{'Green'.green}, #{'Pink'.pink}, #{'Cyan'.cyan}, #{'Yellow'.yellow}

    The hints are going to be either \u2606 or \u26AC. 

    \u2606 means that one of the colors are correct and also in the correct position

    \u26AC means that one of the colors are correct but not in the correct position
  
    Good luck!!

    Press '1' to be the code BREAKER
    Press '2' to be the code MAKER
    Intro
  end
end


class ComputerSolver
  
  include Display
  include Inputs
  COLORS = 6
  CODE_LENGTH = 4

  def initialize
    @computer_turn = 1
    @computer_colors = ["red", "blue", "green", "pink", "cyan", "yellow"]
    @player_code = PlayerMaker.new().player_code
    knuth_algorithm
  end

  def generate_all_possible_codes
    @all_possible_codes = @computer_colors.repeated_permutation(CODE_LENGTH).to_a
  end

  def first_guess
    return [@computer_colors[0], @computer_colors[0], @computer_colors[1], @computer_colors[1]]
  end
  def determine_computer_guess(guess)
    symbol_display = []
    unmatched_guess = []
    unmatched_player_code = []
    #if there is a match , print out White cirlce to indicate that our color and index matches the computer's
    #if there is no match, put the rest of our guesses in an array and the rest of the computer's code in the array
    guess.each_with_index do |color, index|
      if color == @player_code[index]
        symbol_display << WHITE_CIRCLE
      else
        unmatched_guess << color
        unmatched_player_code << @player_code[index]
      end
    end
    #check the two arrays to see if the computer's code includes any of our unmatched guesses. if it does print out Black circle and delete the computer's index that contains our unmatched guess
    unmatched_guess.each do |unmatched_color|
      if unmatched_player_code.include?(unmatched_color)
        symbol_display << BLACK_CIRCLE
        unmatched_player_code.delete_at(unmatched_player_code.index(unmatched_color))
      end
    end
    symbol_display
  end

  def get_clues(symbol_array)
    white_circle = 0
    black_circle = 0
    symbol_array.each do |symbol|
      if symbol == WHITE_CIRCLE
        white_circle += 1
      end
      if symbol == BLACK_CIRCLE
        black_circle += 1
      end
    end
    return [white_circle, black_circle]
  end

  def knuth_algorithm
    max_turns = 5
    possible_combinations = generate_all_possible_codes
    computer_guesses = []
    computer_win = 0
    #Loop until computer figures out the player code
    while computer_guesses.size <= 5 || computer_win = 1
      if computer_guesses.empty?
        current_guess = first_guess
      # if it is not the first guess then the next guess will a guess based on the minmax strategy
      else
        current_guess = next_guess(possible_combinations)
      end
      
      puts "Computer guesses: #{display_color(current_guess)}"
      puts "#{display_hints(determine_computer_guess(current_guess))}"
      if current_guess == @player_code
        puts "The computer cracked your secret code!"
        computer_win += 1
        break
      end
      possible_combinations.reject! do |combo|
        get_clues(determine_computer_guess(combo)) != get_clues(determine_computer_guess(current_guess)) 
      end
      computer_guesses << current_guess
    end
  end

  #min max strategy 
  def next_guess(combinations_remaining)
    best_guess = combinations_remaining.first
    min_max_remaining = Float::INFINITY

    combinations_remaining.each do |guess|
      remaining_possibilities = Hash.new(0)

      combinations_remaining.each do |combination|
        clues = get_clues(determine_computer_guess(combination))
        remaining_possibilities[clues] += 1
      end

      max_remaining = remaining_possibilities.values.max

      if max_remaining < min_max_remaining
        best_guess = guess
        min_max_remaining = max_remaining
      end
    end
    puts "#{best_guess} is the best guess"

    best_guess
  end

  def compare(guess_one, guess_two)
  end


end

class PlayerMaker 
  include Display
  include Inputs
  attr_accessor :player_code
  def initialize
    @player_code = validate_player_input(gets.chomp.downcase.split(' '))
    puts "#{display_color(@player_code)} => This is your code for the computer to break!"
  end
end

class MastermindGame
  include Instructions
  def initialize 
    intro
    user_choice
  end

  def user_choice #handles userinput to see if they want to be code maker or code breaker and initializes the game after
    user_input = gets.chomp
    until user_input == '1' || user_input == '2'
      puts "Please enter either 1 or 2"
      user_input = gets.chomp
    end
    if user_input == '1' 
      puts "You are the code BREAKER"
      PlayerCodeBreaker.new()
    end
    if user_input == '2'
      puts "You are the code MAKER"
      ComputerSolver.new()
    end
  end
end


MastermindGame.new()
    #if userinput is 1 => player will be the code breaker
      #initialize the computer() object so that it will pick a random code for us to break
      #initialize the player() object so that it will prompt us for our 4 color code guess 
      #every turn, our guess will be displayed and then the hints will be displayed
      #if our 4 code input matches the code within 12 attempts then it is our win