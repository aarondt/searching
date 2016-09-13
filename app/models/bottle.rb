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
end
