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
    time_taken = Time.now - params[:start_time].to_i
    @word = params[:word].downcase.split('').sort
    @letters = params[:letters].downcase.split.sort
    if grid_check(@word, @letters) == false
      @message = 'Sorry, that word is not in the grid'
    elsif dictionary_check(params[:word]) == false
      @message = 'Sorry that word is not in the dictionary'
    else
      @score = (@word.length / time_taken.to_f) * 1000
      @message = "Congratulations, your word exists and is in the grid!
      \n Your score is #{@score.round}"
      if session[:score]
        session[:score] += @score
      else
        session[:score] = @score
      end
      @session_score = session[:score].round
    end
  end

  def grid_check(attempt, grid)
    # binding.pry
    attempt.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  def dictionary_check(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    word_hash = JSON.parse(word_serialized)
    word_hash['found']
  end
end
