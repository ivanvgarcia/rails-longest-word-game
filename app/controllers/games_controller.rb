# frozen_string_literal: true

require 'rest-client'

def message(word, answer, dictionary, letters = [])
  if !answer
    "Sorry, #{word.upcase} can't be built from: #{letters.join(', ').upcase}"
  elsif answer && dictionary['found'] == false
    "Sorry, but #{word.upcase} is not a valid English word."
  elsif answer && dictionary['found'] == true
    "Congratulations! #{word.upcase} is a valid word!"
  end
end

# Games Controller
class GamesController < ApplicationController
  def new
    @letters = %w[a e i o u].sample(3).concat(('a'..'z').to_a.sample(7))
  end

  def score
    @word = params[:word]
    letters = params[:letters].split('');

    # Getting the information from the API
    url = 'https://wagon-dictionary.herokuapp.com/'
    data = RestClient.get("#{url}#{@word}").body
    dictionary = JSON.parse(data)

    answer = @word.split('').all? { |letter| letters.include?(letter) }

    @message = message(@word, answer, dictionary, letters)
  end
end
