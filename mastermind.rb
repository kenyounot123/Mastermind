#fix hit display and logic
module Display
  STAR =  "\u2606"
  CIRCLE = "\u26AC"
  def display_guess(guess)
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
  def initialize
    @turn = 1
    @win = 0
    @all_valid_inputs = ["red", "blue", "green", "pink", "cyan", "yellow", "r", "b", "g", "p", "c", "y"]
    @computer = ComputerCodeMaker.new()
    prompt_player
    player_guess
  end

  def prompt_player
    puts "It is now Turn #{@turn}
    Please type in your guess seperated by a space.
    For example these are valid guesses:  Red Blue Purple Yellow => r b p y => R B P Y \n"
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

  #the heart of the game
  def player_guess
    until @turn == 13 || @win == 1
      @guess = gets.chomp.downcase.split(' ')
      validate_player_input(@guess)
      puts display_guess(@guess)
      puts display_hints(determine_guess(@guess))
      if @guess == @computer.computer_crafted_code
        @win = 1
        puts "You have correctly guessed the code! You win!"
      elsif @guess != @computer.computer_crafted_code && @turn == 12
        puts "You Lose! The computer generated code was #{display_guess(@computer.computer_crafted_code)}"
        break
      else
        @turn += 1
        prompt_player
      end
    end
  end


  #makes sure player is inputing a valid word
  def validate_player_input(guess)
    color_inputs = different_color_inputs
    if valid_input(guess)
      proper_guess = guess.map do |color|
        color = color.downcase
        if color.length == 1 
          color = color_inputs[color]
        end
      end
      @guess = proper_guess
    else
      puts "This is not a valid guess, please look at the example and type in a new guess correctly"
      @guess = gets.chomp.downcase.split(' ')
      until valid_input(@guess)
        puts "Invalid guess. Please try again"
        @guess = gets.chomp.downcase.split(' ')
      end
    end
  end

  #makes sure user input is a color that is part of the game
  def valid_input(input)
    valid_color = input.all? { |word| @all_valid_inputs.include?(word) }
    if (valid_color) && (input.length == 4)
      return valid_color
    end
  end


  #showing hint logic
  def determine_guess(guess)
    symbol_display = []
    previous_colors = []
    guess.each_with_index do |color, index|
      if @computer.computer_crafted_code.include?(color) && !previous_colors.include?(color)
        hint = CIRCLE
        previous_colors << color
        if color == @computer.computer_crafted_code[index]
          hint = STAR
        end
      end
      if color == @computer.computer_crafted_code[index]
        hint = STAR
      end
      symbol_display << hint
    end
    return symbol_display 
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
      player_breaker = PlayerCodeBreaker.new()
    end
    #if userinput is 1 => player will be the code breaker
      #initialize the computer() object so that it will pick a random code for us to break
      #initialize the player() object so that it will prompt us for our 4 color code guess 
      #every turn, our guess will be displayed and then the hints will be displayed
      #if our 4 code input matches the code within 12 attempts then it is our win

    #if userinput is 2 => player wll be the code maker
  end
end


MastermindGame.new()