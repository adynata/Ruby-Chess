
class Computer
  attr_accessor :dictionary, :word, :current_guess, :guessed_letters

  def initialize
    @dictionary = []
    @word = nil
    @current_guess = nil
    @guessed_letters = []
    get_dictionary
  end

  def get_dictionary
    begin

      File.foreach('dictionary.txt') do |line|
        @dictionary << line.chomp
      end
    rescue StandardError => e
      puts "Something went wrong: #{e.message}"
    end
  end

  def get_common_words
    File.foreach('most_common.txt') do |line|
      @dictionary << line.chomp
    end
  end


  def get_word
    @word = @dictionary.sample
    @current_guess = "_" * @word.length
  end

  def check_guess(guess)
    array = @word.split('')
    array.each_with_index do |letter, index|
      @current_guess[index] = letter if letter == guess
    end
    puts @current_guess
  end

  def get_guess(opponents_feedback)
    puts "So far, the computer has guessed: #{@guessed_letters.to_s}"
    eliminate_on_length(opponents_feedback.length)
    eliminate_on_positions(opponents_feedback)
    most_common_letter
  end

  def eliminate_on_length(number)
    @dictionary = @dictionary.select { |word| word.length == number }
  end

  def most_common_letter
    letters = @dictionary.map { |word| word.split(//) }.flatten
    freq = Hash.new(0)
    letters.each { |letter| freq[letter] += 1 }
    @guessed_letters.each { |letter| letters.delete(letter) }
    guess = letters.max_by { |value| freq[value] }
    @guessed_letters << guess
    guess
  end

  def eliminate_on_positions(opponents_feedback)
    @dictionary = @dictionary.select do |word|
      position_match?(word, opponents_feedback)
    end
  end

  def position_match?(word, opponents_feedback)
    letters = word.split(//)
    letters.each_with_index do |letter, index|
      if opponents_feedback[index] != "_" && opponents_feedback[index] != letter
        return false
      end
    end
    true
  end


  def get_random_guess

    guess = (97 + rand(25)).chr
    until !@guessed_letters.include?(guess)
      guess = (97 + rand(25)).chr
    end
    @guessed_letters << guess
    guess
  end

  def won?
    @word == @current_guess
  end

end

class Human
  attr_accessor :current_guess, :guessed_letters

  def initialize
    @current_guess = nil
    @guessed_letters = []
  end

  def get_guess(current_guess)
    puts "So far, you have guessed: #{@guessed_letters}"
    puts "Which letter would you like to guess?"
    guess = gets.chomp.downcase
    until guess.length == 1 && guess.match(/[a-z]/) && !@guessed_letters.include?(guess)
      puts "Please enter a letter."
      guess = gets.chomp.downcase
    end
    @guessed_letters << guess
    guess
  end

  def get_word
    puts "How many letters is your word?"
    chosen_word = gets.chomp
    until chosen_word.match(/\d/)
      puts "Please enter a number."
      chosen_word = gets.chomp
    end
    @current_guess = "_" * chosen_word.to_i
  end

  def check_guess(guess)
    puts "What positions does #{guess} match? (if none, enter 'n')"
    answer = gets.chomp.downcase.split(",")
    until answer == ["n"] || array_of_integers?(answer)
      puts "Sorry, I didn't understand. Please enter something like '1,2' or 'n'"
      answer = gets.chomp.downcase.split(",")
    end
    return puts @current_guess if answer == ["n"]
    answer.each do |number|
      @current_guess[number.to_i - 1] = guess
    end

    puts @current_guess
  end

  def array_of_integers?(array)
    array.each { |number| return false unless number.match(/\d/) }
    true
  end

  def won?
    !@current_guess.match(/_/)
  end

  def write(answer)
    File.open("most_common.txt", "a") { |f| f.puts answer }
  end
end
