require_relative 'player'

class Hangman
  TURN_LIMIT = 26
  
  attr_accessor :turns, :checker, :guesser
  def initialize(checker, guesser)
    @turns = 0
    @checker = checker
    @guesser = guesser
  end
  
  def self.start
    puts "Welcome to Hangman!"
    puts "Is the checker a human or a computer?"
    checker = create_player(player_identity)

    puts "Is the guesser a human or a computer?"
    guesser = create_player(player_identity)
    
    game = Hangman.new(checker, guesser)
    game.play
  end
  
  def self.player_identity
    answer = gets.chomp.downcase
    until ["human", "computer", "skynet"].include?(answer)
      puts "Please enter human or computer."
      answer = gets.chomp.downcase
    end
    answer
  end
  
  def self.create_player(player)
    player == "human" ? Human.new : Computer.new
  end
      
  def play
    checker.get_word
    guesser.get_common_words if guesser.is_a?(Computer)
    puts checker.current_guess
    while turns < TURN_LIMIT
      checker.check_guess(guesser.get_guess(checker.current_guess))
      @turns += 1
      break if checker.won?
    end
    checker.write(checker.current_guess) if checker.is_a?(Human) && checker.won?
    return puts "Yay! You won." if checker.won?
    puts "Sorry :( You lose"
  end
  
end

Hangman.start