class SearchSuggestion < ActiveRecord::Base
    attr_accessor :term, :popularity
    
    def self.terms_for(prefix)
        suggestions = where("term LIKE ?", "#{prefix}_%")  
        suggestions.limit(10).pluck(:term)
    end 
    
    
 def   self.index_products
    Bottle.find_each do |bottle|
        index_term(bottle.name)
        bottle.name.split.each {|t| index_term(t)}
    end
 end
 
 
 def self.index_term(term)
     where(term: term.downcase).first_or_initialize.tap do |suggestion|
         suggestion.increment! :popularity
    end
 end
     

    
end
