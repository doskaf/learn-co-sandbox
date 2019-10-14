require './lib/pokedex'

class Pokedex::Pokemon
  
  attr_accessor :name, :number, :url, :types, :species, :height, :weight, :abilities
  
  @@all = []
  
  def initialize(name, number, url, types)
  @name = name
  @number = number
  @url = url
  @types = types
  @@all << self
  end
  
  def self.all
    @@all
  end
  
  def self.find_by_name(user_input)
    poke = self.all.find do |pokemon|
      pokemon.name == user_input.capitalize
    end
    if poke != nil
      Pokedex::Scraper.get_more_info(poke)
    end
    poke
  end
  
  def self.find_by_number(user_input)
    poke = Pokedex::Pokemon.all.find do |pokemon|
      pokemon.number == "#" + user_input
    end
    if poke != nil
      Pokedex::Scraper.get_more_info(poke)
    end
    poke
  end
  
  def self.list_of_types
    self.all.collect do |pokemon|
      pokemon.types.split(", ")
    end.flatten.uniq.sort
  end
  
end