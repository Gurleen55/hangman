require "rubocop"
require "yaml"

# this will create  a game object
class Game
  def initialize
    file = File.open("google-10000-english-no-swears.txt")
    # using random number and looping through the file to get a random word
    rand(9893).times do
      file.readline
    end
    @secret_word = file.readline.chomp.split("")
    @grid = Array.new(@secret_word.length, "_").join(" ")
    file.close
  end

  def start
    puts @secret_word
    puts @grid
    10.times do |i|
      puts "guess ##{i + 1}"
      guess = turn
      update_grid(guess) if exist?(guess)
      puts @grid
      if @grid.split(" ").join("") == @secret_word.join("")
        puts "you have guessed the right word"
        return # rubocop:disable Lint/NonLocalExitFromIterator
      end
    end
    "Alas! you lost"
  end

  def turn
    guess = nil
    puts "Guess an alphabet to save yourself, You will get 10 guesses"
    loop do
      puts "Enter a single letter (a-z) to guess or type 'save' to save the game:"
      input = gets.chomp.downcase
      if input == "save"
        save_game
        puts "game saved successfully"
        next
      elsif input.length == 1 && input.ord >= 97 && input.ord <= 122
        guess = input
        break
      else
        puts "Invalid input. Please enter a single letter or 'save'."
      end
    end
    guess
  end

  def exist?(char)
    return true if @secret_word.include?(char)

    false
  end

  def update_grid(guess)
    grid = @grid.split(" ")
    grid.each_with_index do |_value, index|
      @grid[index * 2] = guess if guess == @secret_word[index]
    end
  end

  def save_game
    File.open("saved_game.dat", "wb") do |file|
      Marshal.dump(self, file)
    end
  end

  def self.load_game
    if File.exist?("saved_game.dat")
      File.open("saved_game.dat", "rb") do |file|
        Marshal.load(file)
      end
    else
      puts "no saved game found"
      new
    end
  end
end

if File.exist?("saved_game.dat")
  puts "Do you want to load the saved game? (yes/no)"
  input = gets.chomp.downcase
  mastermind = if input == "yes"
                 Game.load_game
               else
                 Game.new
               end
else
  mastermind = Game.new
end
mastermind.start
