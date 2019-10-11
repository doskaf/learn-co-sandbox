class Pokedex::Scraper
  
  BASE_URL = "https://pokemondb.net/pokedex/national#gen-1"
  
  def self.initial_scrape
    doc = Nokogiri::HTML(open(BASE_URL))
    names = doc.css(".infocard-lg-data.text-muted .ent-name").text.split(/(?=[A-Z])/)[0..9]
    numbers = doc.css(".infocard-lg-data.text-muted small").text.split(/[A-Za-z · ]/).reject {|i| i.empty?}[0..9]
    types = doc.css(".infocard-lg-data.text-muted small").text.gsub(" ·", ",").split(/[^a-zA-z ,]/).reject {|i| i.empty?}[0..9]
    
    names.each_with_index do |name, i|
      Pokedex::Pokemon.new(name, numbers[i], types[i])
    end
  end
  
end