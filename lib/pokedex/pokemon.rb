require './lib/pokedex'

class Pokedex::Pokemon
  
  attr_accessor :name, :number, :types
  
  @@all = []
  
  def initialize(name, number, types)
  @name = name
  @number = number
  @types = types
  @@all << self
  end
  
  def self.all
    @@all
    #pokemon = []
    #pokemon << self.scrape_pokedex
    #pokemon
  end
  
  def self.scrape_pokedex
    doc = Nokogiri::HTML(open("https://pokemondb.net/pokedex/national#gen-1"))
    names = doc.css(".infocard-lg-data.text-muted .ent-name").text.split(/(?=[A-Z])/)[0..9]
    numbers = doc.css(".infocard-lg-data.text-muted small").text.split(/[A-Za-z · ]/).reject {|i| i.empty?}[0..9]
    types = doc.css(".infocard-lg-data.text-muted small").text.gsub(" ·", ",").split(/[^a-zA-z ,]/).reject {|i| i.empty?}[0..9]
    
    names.each_with_index do |name, i|
      pokemon = self.new(name, numbers[i], types[i])
    end
    @@all
    #**Getting there
  end
  
  
  #def self.scrape_names()
    #doc.css(".infocard-lg-data.text-muted .ent-name").text.split(/(?=[A-Z])/)[0..9]
  #end
  
  #def self.scrape_numbers()
    #doc.css(".infocard-lg-data.text-muted small").text.split(/[A-Za-z · ]/).reject {|i| i.empty?}[0..9]
  #end
  
  #def self.scrape_types()
    #doc.css(".infocard-lg-data.text-muted small").text.gsub("· ", "").split(/[^a-zA-z ]/).reject {|i| i.empty?}[0..9]
  #end
  #binding.pry
end