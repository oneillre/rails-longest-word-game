require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    9.times do
      let = ('a'..'z').to_a.sample
      @letters << let
    end
    @letters
  end

  def score
    raise
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    time_taken = Time.now - params[:start_time].to_i
    @word = params[:word].downcase.split('')
    @letters = params[:letters].downcase.split
    if word['found'] == false
      @message = 'Sorry, that word is not in our dictionary'
    elsif @word.all? { |letter| @letters.include?(letter) } == false
      @message = 'Sorry, that word is not in the grid!'
    else
      # binding.pry
      @score = (@word.length / time_taken.to_f) * 1000
      @message = "Congratulations, your word exists and is in the grid!
      \n Your score is #{@score.round}"
    end
  end
end
