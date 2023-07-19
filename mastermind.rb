#There will be a codebreaker and a codemaker
#and the player will be able to choose which one they want to be
#computer code is in an array [1,2,3,4]

class Display
  STAR =  '\u2606'
  CIRCLE = '\u26AC'

  def different_inputs 
    all_inputs = {
      'r': 'Red',
      'b': 'Blue',
      'g': 'Green',
      'p': 'Pink',
      'c': 'Cyan',
      'y': 'Yellow',
  }


  end
end

class Computer
  COMPUTER_CHOICES = ["Red", "Blue", "Green", "Pink", "Cyan", "Yellow"]
  def initialize
    @computer_crafted_code = four_color_code.split(' ')
    puts "The computer has chosen a code for you to break. You will lose if you do not guess it within 12 turns"
  end

  def four_color_code 
    computer_code = ''
    for color in 0...4
      computer_code += COMPUTER_CHOICES[rand(1..6) - 1].downcase + ' '
    end
    return computer_code
  end
end

class Player
  def initialize
    @turn = 1
    prompt_player
  end

  def prompt_player
    puts "It is now Turn #{@turn}
    Please type in your guess seperated by a space.
    For example these are valid guesses:  Red Blue Purple Yellow => r b p y => R B P Y \n"
  end


end

class Board 
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
      computer = Computer.new()
      player = Player.new()
    end
    #if userinput is 1 => player will be the code breaker
      #initialize the computer() object so that it will pick a random code for us to break
      #initialize the player() object so that it will prompt us for our 4 color code guess 
      #every turn, our guess will be displayed and then the hints will be displayed
      #if our 4 code input matches the code within 12 attempts then it is our win 




    #if userinput is 2 => player wll be the code maker
  end
end


