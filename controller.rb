
require "sinatra"
require "sinatra/reloader"
require_relative "exceptions"

enable :sessions

WORDS = []
File.foreach("5desk.txt") {|word| WORDS.push(word)}

get '/' do
  if session[:game_over] || session[:message].nil?
    redirect to "/newgame"
  end
  check_game_status
  erb :index

end

post '/' do
  guess = params["guess"]
  make_guess(guess)
  redirect to "/"
end

get '/newgame' do
  set_up_game
  redirect to "/"
end

get '/win' do
  erb :win
end

get '/lose' do
  erb :lose
end

helpers do
  def check_game_status
    if session[:answer] == session[:guess]
      session[:game_over] = true
      redirect to '/win'
    elsif session[:num_wrong] == 6
      session[:game_over] = true
      redirect to '/lose'
    end
  end

  def set_up_game
    session[:message] = ""
    session[:game_over] = false
    session[:answer] = random_word.downcase
    session[:guess] = "_" * session[:answer].length
    session[:num_wrong] = 0
    session[:guess_string] = guess_to_string
    session[:guessed_letters] = []
  end

  def guess_to_string
    str = ""
    session[:guess].each_char {|char| str += char + " "}
    str
  end

  def check_letter(c)
    raise NotLetter.new if !(c =~ /[[:alpha:]]/)
  end

  def check_length(c)
    raise TooManyLetters.new if c.length != 1
  end

  def check_already_guessed(c)
    raise AlreadyGuessed.new if session[:guessed_letters].include? c
  end

  def make_guess(c)
    session[:message] = ""
    begin
      check_letter(c)
      check_length(c)
      check_already_guessed(c)
    rescue NotLetter
      session[:message] = "Error: #{c} is not a letter!"
      redirect to "/"
    rescue TooManyLetters
      session[:message] = "Error: Enter only one letter"
      redirect to "/"
    rescue AlreadyGuessed
      session[:message] = "Error: You already guessed #{c}"
      redirect to "/"
    end
    session[:guessed_letters].push(c)
    match_found = false
    (0...session[:answer].length).each do |i|
      if c == session[:answer][i]
        match_found = true
        session[:guess][i] = c
      end
    end
    session[:num_wrong] += 1 if !match_found
    session[:guess_string] = guess_to_string
  end

  def random_word
    WORDS[rand(WORDS.length)][0..-3]
  end

end
