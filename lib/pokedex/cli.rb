require './lib/pokedex'

class Pokedex::CLI
  
  def welcome
    puts "Hey there, trainer! How can I help you today? (Choose a number:)"
    menu
  end
  
  def menu
    puts "1. List Pokemon"
    puts "2. Learn about a Pokemon"
    puts "3. List Pokemon by type"
    puts "4. Exit"
    input = gets.strip
    case input
      when "1"
        list_pokemon
        learn_promt
      when "2"
        poke_info
        menu_promt
      when "3"
        list_by_type
      when "4"
        quit
      when "pokemon"
        puts "Gotta catch 'em all!"
        menu_promt
      else
        puts "Invalid input. Please select a number from the list:"
        menu
      end
  end
  
  def list_pokemon
    Pokedex::Pokemon.all.each do |pokemon|
      puts "#{pokemon.number}. #{pokemon.name}"
    end
  end
  
  def learn_promt
    puts "Would you like to learn more about one of these pokemon? (y/n)"
    input = gets.strip
    case input
      when "y"
        poke_info
        menu_promt
      when "n"
        menu_promt
      else
        puts "Invalid input."
        learn_promt
      end
  end
  
  def poke_info
    #puts "This Pokemon is a fire type!"
  end
  
  def menu_promt
    puts "(To return to the menu, type 'menu' or type 'exit' to quit!)"
    input = gets.strip
    case input
      when "menu"
        menu
      when "exit"
        quit
      else
        puts "Invalid input."
        menu_promt
      end
  end
  
  def list_by_type
    puts "Please enter a Pokemon type:"
    input = gets.strip
    case input
      when "fire"
        puts "charizard"
        type_prompt
      when "electric"
        puts "pikachu"
        type_prompt
      else
        puts "Invalid input."
        list_by_type
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
        puts "Invalid input."
        type_prompt
      end
  end
  
  def quit
    puts "Happy catching!"
  end
  #binding.pry
  
end