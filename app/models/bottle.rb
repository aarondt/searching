class Bottle < ActiveRecord::Base
  
    belongs_to :shop, dependent: :destroy
    
    
    def self.calculate_price(flaschen, quantity)
        preis_array = []
        flaschen.each do |x|
            x.inhalt =  "n/a" if x.inhalt.blank? 
            x.price_per_litre_string =  "n/a" if x.price_per_litre_string.blank? 
            x.price =  "n/a" if x.price.blank? 
            preis = x.price * quantity.to_i
            preis_array << preis
           
        end
        return preis_array
    end
    
    
    def self.search_wines(search, category,country, grape)
   # where('LOWER(name) LIKE :search', search: "%#{search}%")
    #Bottle.where(["lower(name) LIKE lower(?)", name2]) if name2.present?
   #bottle = bottle.where(["category LIKE ?", category]) if category.present?
     bottle = Bottle.all
    if search != ""
    bottle = bottle.where(["lower(name) LIKE ?", "%#{search}%"]) if search.present?
    bottle = bottle.where(["category LIKE ?", category]) if category.present? and category != "Alle Kategorien"
    bottle = bottle.where(["country LIKE ?", country]) if country.present? and country != "Alle Länder"
    bottle = bottle.where(["grape LIKE ?", grape]) if grape.present? and grape != "Alle Rebsorten"
    else
    bottle = bottle.where(["category LIKE ?", category]) if category.present? and category != "Alle Kategorien"
    bottle = bottle.where(["country LIKE ?", country]) if country.present? and country != "Alle Länder"
    bottle = bottle.where(["grape LIKE ?", grape]) if grape.present? and grape != "Alle Rebsorten"
    end
    return bottle
    
    
    
    end
end
