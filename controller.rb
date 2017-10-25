
require "sinatra"
require "sinatra"
require_relative "hangman"

game = Hangman.new

get '/hangman' do
  if game.in_progress?
    guess = params["guess"]
    game.make_guess(guess)
  elsif params["new_game"] == "true"
    game = Hangman.new
  end
  erb :index, :locals => {:guess_string => game.guess_to_string,
                          :in_progress => game.in_progress?,
                          :message => game.message,
                          :num_wrong => game.num_wrong}
end
