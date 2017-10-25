class Hangman

  attr_accessor :num_wrong
  @@max_wrong = 6

  def initialize
    @words = read_file("5desk.txt")
    @answer = random_word
    @guess = "_" * @answer.length
    @num_wrong = 0
  end

  def in_progress?
    @answer != @guess && @num_wrong < @@max_wrong
  end


  def message
    if @answer == @guess
      "You win!"
    elsif @num_wrong == @@max_wrong
      "The word was #{@answer} <br> You lose :("
    else
      nil
    end
  end

  def guess_to_string
    str = ""
    @guess.each_char {|char| str += char + " "}
    str
  end

  def make_guess(c)

    match_found = false
    (0...@answer.length).each do |i|
      if c == @answer[i]
        match_found = true
        @guess[i] = c
      end
    end
    @num_wrong += 1 if !match_found
  end

  def random_word
    @words[rand(@words.length)][0..-3]
  end

  def read_file(filename)
    words = []
    File.foreach(filename) {|word| words.push(word)}
    words
  end
end
