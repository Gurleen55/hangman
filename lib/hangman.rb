class Game
  def initialize
    file = File.open("google-10000-english-no-swears.txt")
    rand(9893).times do 
      file.readline
    end
    @secret_word = file.readline.chomp
    file.close
  end

  def test
    puts @secret_word
  end
end

mastermind = Game.new
mastermind.test
