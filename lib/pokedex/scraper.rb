class Pokedex::Scraper
  
  BASE_URL = "https://pokemondb.net"
  
  def self.initial_scrape
    doc = Nokogiri::HTML(open(BASE_URL + "/pokedex/national#gen-1"))
    names = doc.css(".infocard-lg-data.text-muted .ent-name").text.split(/(?<!\s)(?=[A-Z])/)[0..150]
    numbers = doc.css(".infocard-lg-data.text-muted small").text.split(/[A-Za-z · ]/).reject {|i| i.empty?}[0..150]
    urls = doc.css(".infocard-lg-data.text-muted a.ent-name").map {|link| link['href']}[0..150]
    types = doc.css(".infocard-lg-data.text-muted small").text.gsub(" ·", ",").gsub((/(#|\d)/), "").split(/(?<!\s)(?=[A-Z])/)[0..150]
    names.each_with_index do |name, i|
      Pokedex::Pokemon.new(name, numbers[i], urls[i], types[i])
    end
  end

  def self.get_more_info(poke)
    doc = Nokogiri::HTML(open(BASE_URL + poke.url))
    poke.species = doc.css(".grid-col.span-md-6.span-lg-4 table.vitals-table tbody tr:nth-child(3) td").text.split(/(?<!\s)(?=[A-Z])/).uniq.join
    poke.height = doc.css(".grid-col.span-md-6.span-lg-4 table.vitals-table tbody tr:nth-child(4) td").text.split(/(?<=\)).+/).join
    poke.weight = doc.css(".grid-col.span-md-6.span-lg-4 table.vitals-table tbody tr:nth-child(5) td").text.split(/(?<=\)).+/).join
    poke.abilities = doc.css(".grid-col.span-md-6.span-lg-4 table.vitals-table tbody tr:nth-child(6) td").text.gsub(/(\d. )/, "").split(/(?<!\s)(?=[A-Z])/)
    poke.first_evolution = doc.css(".infocard-list-evo .infocard:first-child .infocard-lg-data.text-muted small:first-child, .infocard-list-evo .infocard:first-child .infocard-lg-data.text-muted a.ent-name").text.split(/(?<!\s)(?=[A-Z])/).join(". ")
    poke.second_evolution = doc.css(".infocard-list-evo .infocard:nth-child(3) .infocard-lg-data.text-muted small:first-child, .infocard-list-evo .infocard:nth-child(3) .infocard-lg-data.text-muted a.ent-name").text.split(/(?<!\s)(?=[A-Z])/).join(". ")
    poke.third_evolution = doc.css(".infocard-list-evo .infocard:last-child .infocard-lg-data.text-muted small:first-child, .infocard-list-evo .infocard:last-child .infocard-lg-data.text-muted a.ent-name").text.split(/(?<!\s)(?=[A-Z])/).join(". ")
    
    Pokedex::CLI.display_more_info(poke)
  end
  
  def self.testing
    doc = Nokogiri::HTML(open(BASE_URL + "/pokedex/mr-mime"))
    second_evolution = doc.css(".infocard-list-evo .infocard:nth-child(3) .infocard-lg-data.text-muted small:first-child, .infocard-list-evo .infocard:nth-child(3) .infocard-lg-data.text-muted a.ent-name").text.split(/(?<!\s)(?=[A-Z])/).join(". ").split(/(?<!\s)(?=[A-Z])/)
  end

end