require './lib/pokedex'

class Pokedex::CLI
  
  def welcome
    puts "Hey there, trainer! How can I help you today? (Choose a number:)"
    menu
  end
  
  def menu
    Pokedex::Scraper.initial_scrape
    puts " 1. List Pokemon"
    puts " 2. Learn about a Pokemon"
    puts " 3. List Pokemon by type"
    puts " 4. Exit"
    input = gets.strip
    case input.downcase
      when "1"
        list_pokemon
        learn_promt
      when "2"
        poke_info
      when "3"
        list_by_type
      when "4"
        quit
      when "pokemon"
        puts "Gotta catch 'em all!"
        menu_promt
      else
        puts "***Invalid input. Please select a number from the list:***"
        menu
      end
  end
  
  def list_pokemon
    Pokedex::Pokemon.all.uniq.each do |pokemon|
      puts "#{pokemon.number}. #{pokemon.name}"
    end
  end
  
  def poke_info
    puts "Please enter the name or number (three digits) of the\nGen 1 Pokemon you'd like to learn about:"
    input = gets.strip
    if (Pokedex::Pokemon.find_by_number(input) == nil) && (Pokedex::Pokemon.find_by_name(input) == nil)
      puts "***Invalid input.***"
      poke_info
    elsif input.to_i > 0
      Pokedex::Pokemon.find_by_number(input)
      learn_another_poke
    else
      Pokedex::Pokemon.find_by_name(input)
      learn_another_poke
    end
  end
  
  def self.display_more_info(poke)
    puts "Name: #{poke.name}"
    puts "Number: #{poke.number}"
    puts "Types: #{poke.types}"
    puts "Species: #{poke.species}"
    puts "Height: #{poke.height}"
    puts "Weight: #{poke.weight}"
    puts "Abilities: #{poke.abilities.each_with_index.map {|ab, i| "\n #{i + 1}. #{ab}"}.join("")}"
  end
  
  def list_by_type
    puts "Please enter a Pokemon type. For a list of valid types, enter 'types':"
    input = gets.strip
    if input.downcase == "types"
      type_list
      list_by_type
    elsif Pokedex::Pokemon.list_of_types.find {|t| t == input.capitalize} != nil
      selected_type_pokemon = []
      Pokedex::Pokemon.all.each do |poke|
        if (poke.types.split(", ").find {|t| t == input.capitalize}) != nil
          selected_type_pokemon << poke
        end
      end
      selected_type_pokemon.uniq.each do |poke|
        puts " #{poke.number}. #{poke.name}"
      end
      what_next
    else
      puts "***Invalid input.***"
      list_by_type
    end
  end
  
  def type_list
    Pokedex::Pokemon.list_of_types.each {|type| puts " #{type}"}
  end
  
  def what_next
    puts "*To learn more about one of these Pokemon, enter 'pokemon'\n*To list Pokemon by a different type, enter 'type'\n*For neither, enter anything else!"
    input = gets.strip
    if input.downcase == "pokemon"
      poke_info
    elsif input.downcase == "type"
      list_by_type
    else
      menu_promt
    end
  end
  
  def learn_promt
    puts "Would you like to learn more about one of these pokemon? (y/n)"
    input = gets.strip
    case input.downcase
      when "y"
        poke_info
      when "n"
        menu_promt
      else
        puts "***Invalid input.***"
        learn_promt
      end
  end
  
  def learn_another_poke
    puts "Would you like to learn about another pokemon? (y/n)"
    input = gets.strip
    case input.downcase
      when "y"
        poke_info
      when "n"
        menu_promt
      else
        puts "***Invalid input.***"
        learn_another_poke
      end
  end
  
  def menu_promt
    puts "(To return to the menu, enter 'menu' or enter 'exit' to quit!)"
    input = gets.strip
    case input
      when "menu"
        menu
      when "exit"
        quit
      else
        puts "***Invalid input.***"
        menu_promt
      end
  end
  
  def type_prompt
    puts "Would you like to list more Pokemon by another type? (y/n)"
    input = gets.strip
    case input
      when "y"
        list_by_type
      when "n"
        menu_promt
      else
        puts "***Invalid input.***"
        type_prompt
      end
  end
  
  def quit
    puts "Happy catching!"
  end
  
end