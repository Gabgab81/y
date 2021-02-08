require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    session[:score] = [] if session[:score].nil?
    @alphab = ("a".."z").to_a
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    # 10.times { |letter| @letters << @alphab.sample.upcase}
    
    # session[:score] = [{date: Time.new.strftime("%Y-%m-%d %H:%M:%S"), score: 10}]
    # session[:score2] = {date: Time.new.strftime("%Y-%m-%d %H:%M:%S"), score: 80}
  end

  def score
    @answer = params[:l_word].upcase
    @letters = params[:letters].split(//)
    @goodword = included?(@answer, @letters)
    @englishword = english_word?(@answer)

    # @sentence = message(@goodword, @englishword, @answer, @letters)
    @score = @answer.size*10

    addscore(@score) if @goodword && @englishword
    
  end
  
  private

  def addscore(score)
    session[:score] << {"date" => Time.now.strftime("%Y-%m-%d %H:%M:%S"), "score" => score}
  end
  

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  # def message(includ, english, guess, grid)
  #   if !includ
  #     "Sorry but #{guess} can't be build out of #{grid}"
  #   elsif !english
  #     "Sorry but #{guess} does not seem to be a valid English word..."
  #   else
  #     "Congratulation #{guess} is a valide Englidh word"
  #   end
  # end

end
