require './lib/pokedex'

class Pokedex::CLI
  
  def welcome
    puts "Hey there, trainer! Welcome to your Gen 1 Pokédex!\nHow can I help you today? (Choose a number:)"
    menu
  end
  
  def menu
    Pokedex::Scraper.initial_scrape
    puts "--------------------------"
    puts " 1. List Pokémon"
    puts " 2. Learn about a Pokémon"
    puts " 3. List Pokémon by type"
    puts " 4. Exit"
    puts "--------------------------"
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
        puts "--------------------"
        puts "Gotta catch 'em all!"
        menu_promt
      else
        puts "***Invalid input. Please select a number from the list:***"
        menu
      end
  end
  
  def list_pokemon
    puts "------------------------"
    Pokedex::Pokemon.all.uniq.each do |pokemon|
      puts "#{pokemon.number}. #{pokemon.name}"
    end
    puts "------------------------"
  end
  
  def poke_info
    puts "-----------------------------------------------------"
    puts "Please enter the name or number (three digits) of the\nGen 1 Pokémon you'd like to learn about:"
    input = gets.strip
    if (Pokedex::Pokemon.find_by_number(input) == nil) && (Pokedex::Pokemon.find_by_name(input) == nil)
      puts "***Invalid input.***"
      poke_info
    else
      learn_another_poke
    end
  end
  
  def self.display_more_info(poke)
    puts "--------------------------------"
    puts "Name: #{poke.name}"
    puts "Number: #{poke.number}"
    puts "Types: #{poke.types}"
    puts "Species: #{poke.species}"
    puts "Height: #{poke.height}"
    puts "Weight: #{poke.weight}"
    puts "Abilities: #{poke.abilities.each_with_index.map {|ab, i| "\n #{i + 1}. #{ab}"}.join("")}"
    Pokedex::Pokemon.evolution_display(poke)
    puts "--------------------------------"
  end
  
  def list_by_type
    puts "----------------------------"
    puts "Please enter a Pokémon type.\n*For a list of valid types, enter 'types':"
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
      puts "----------------------------"
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
    puts "----------------------------------------------------------------"
    Pokedex::Pokemon.list_of_types.each {|type| puts " #{type}"}
  end
  
  def what_next
    puts "*To learn more about one of these Pokémon, enter 'pokemon'\n*To list Pokémon by a different type, enter 'type'\n*For neither, enter anything else!"
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
    puts "Would you like to learn more about one of these Pokémon? (y/n)"
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
    puts "Would you like to learn about another Pokémon? (y/n)"
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
    puts "*To return to the menu, enter 'menu' or enter 'exit' to quit!"
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
    puts "Would you like to list more Pokémon by another type? (y/n)"
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
    puts "----------------"
    puts "Happy catching!"
  end
  
end