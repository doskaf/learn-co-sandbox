require './lib/pokedex'

class Pokedex::Pokemon
  
  attr_accessor :name, :number, :url, :types, :species, :height, :weight, :abilities, :first_evolution, :second_evolution, :third_evolution, :evolves_from, :evolves_into
  
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
      pokemon.name == user_input.split(" ").map(&:capitalize).join(' ')
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
  
  def self.evolution_display(poke)
    if (poke.first_evolution == "") && (poke.second_evolution == "") && (poke.third_evolution == "")
      puts "Evolutions:\n This Pokémon does not evolve."
    elsif poke.number == "#133"
      puts "Evolves From:\n This Pokémon is the first of its evolution line!"
      puts "Evolves Into:\n #134. Vaporeon\n #135. Jolteon\n #136. Flareon"
    elsif (poke.number == "#134") || (poke.number == "#135") || (poke.number == "#136")
      puts "Evolves From:\n #{poke.first_evolution}"
      puts "Evolves Into:\n This Pokémon is the last of its evolution line!"
    elsif poke.second_evolution != poke.third_evolution
      if poke.first_evolution.match(poke.name)
        puts "Evolves From:\n This Pokémon is the first of its evolution line!"
        puts "Evolves Into:\n #{poke.second_evolution}"
      elsif poke.second_evolution.match(poke.name)
        puts "Evolves From:\n #{poke.first_evolution}"
        puts "Evolves Into:\n #{poke.third_evolution}"
      elsif poke.third_evolution.match(poke.name)
        puts "Evolves From:\n #{poke.second_evolution}"
        puts "Evolves Into:\n This Pokémon is the last of its evolution line!"
      end
    else
      if poke.first_evolution.match(poke.name)
        puts "Evolves From:\n This Pokémon is the first of its evolution line!"
        puts "Evolves Into:\n #{poke.second_evolution}"
      elsif poke.second_evolution.match(poke.name)
        puts "Evolves From:\n #{poke.first_evolution}"
        puts "Evolves Into:\n This Pokémon is the last of its evolution line!"
      end
    end
  end
  
end