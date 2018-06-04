require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ("a".."z").to_a.sample
    end
  end

  def score
    @word = params["word"].downcase
    @letters = params["letters"].split("").delete_if{|a| a == " "}
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = open(url).read
    @result = JSON.parse(word_serialized)
    @is_englisch = @result["found"]
    @message = nil
    @is_in_array = true
    @word.split(//).each do |letter|
      if @letters.include?(letter)
        @letters.delete_at(@letters.index(letter))
      else
        @is_in_array = false
      end
    end


    if @is_in_array && @is_englisch
      @message = "This is valid"
    elsif @is_in_array
      @message = "This is not an english word."
    elsif @is_englisch
      @message = "This word cannot be built using these letters"
    else
      @message = "This is neither an english word nor can it be made using these letters"
    end
  end
end
