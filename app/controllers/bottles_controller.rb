class BottlesController < ApplicationController
    
 

    
   def update_text
           @country_value == "Alle Länder"
       if params[:category_name] != "Alle Kategorien" and (params[:country_name] == "Alle Länder")
           @rebsorten = Bottle.where(category: params[:category_name] ).pluck(:grape).uniq
           @rebsorten.sort_by!{ |e| e.downcase }
           @rebsorten.unshift("Alle Rebsorten")
       elsif (params[:category_name] == "Alle Kategorien") and (params[:country_name] != "Alle Länder")
           @rebsorten = Bottle.where(country: params[:country_name] ).pluck(:grape).uniq
           @rebsorten.sort_by!{ |e| e.downcase }
           @rebsorten.unshift("Alle Rebsorten")
       elsif (params[:category_name] == "Alle Kategorien") and (params[:country_name] == "Alle Länder")
           @rebsorten = Bottle.order(:grape).pluck(:grape).uniq
           @rebsorten.sort_by!{ |e| e.downcase }
           @rebsorten.unshift("Alle Rebsorten")
        elsif (params[:category_name] != "Alle Kategorien")
           @rebsorten = Bottle.where(category: params[:category_name]).pluck(:grape).uniq
           @rebsorten.sort_by!{ |e| e.downcase }
           @rebsorten.unshift("Alle Rebsorten")
       else
           @rebsorten = Bottle.where(country: params[:country_name], category: params[:category_name]).pluck(:grape).uniq
           @rebsorten.sort_by!{ |e| e.downcase }
           @rebsorten.unshift("Alle Rebsorten")
       end
   end
 
  def update_category
      
     if   (params[:category_name] != "Alle Kategorien") and (params[:country_name] != "Alle Länder")
          @country = Bottle.where(category: params[:category_name]).pluck(:country).uniq
          @country.sort_by!{ |e| e.downcase }
          @country.unshift("Alle Länder")
          @grape = Bottle.where( category: params[:category_name]).pluck(:grape).uniq
          @grape.sort_by!{ |e| e.downcase }
          @grape.unshift("Alle Rebsorten")
      elsif (params[:category_name] == "Alle Kategorien") and (params[:country_name] == "Alle Länder")
          @country = Bottle.order(:country).pluck(:country).uniq
          @country.sort_by!{ |e| e.downcase }
          @country.unshift("Alle Länder")
          @grape = Bottle.order(:grape).pluck(:grape).uniq
          @grape.sort_by!{ |e| e.downcase }
          @grape.unshift("Alle Rebsorten")
          
     elsif (params[:category_name] != "Alle Kategorien") and (params[:country_name] == "Alle Länder") 
          @country = Bottle.where(category: params[:category_name]).pluck(:country).uniq
          @country.sort_by!{ |e| e.downcase }
          @country.unshift("Alle Länder")
          @grape = Bottle.where(category: params[:category_name]).pluck(:grape).uniq
          @grape.sort_by!{ |e| e.downcase }
          @grape.unshift("Alle Rebsorten")
     elsif (params[:category_name] == "Alle Kategorien" and params[:country_name] != "Alle Länder")
        @country = Bottle.order(:country).pluck(:country).uniq
        @grape = Bottle.where(grape: params[:country_name]).pluck(:grape).uniq
        @grape.sort_by!{ |e| e.downcase }
        @grape.unshift("Alle Rebsorten")
     else
        @country = Bottle.where(category: category_name).pluck(:country).uniq 
        @country.sort_by!{ |e| e.downcase }
        @country.unshift("Alle Länder")
        @grape = Bottle.where(category: category_name).pluck(:grape).uniq
        @grape.sort_by!{ |e| e.downcase }
        @grape.unshift("Alle Rebsorten")
          
          
      end
  end 
         
    def index   
        
        @filterProducts = true
        
        
        
        
        
        @all_flasch = Bottle.order(:name)
        
        liste_namen = []
        @alle_flaschen = Bottle.all
        @alle_flaschen.each do |x|
            liste_namen << x.name
        end
        
        hash = Hash[@alle_flaschen.map { |l| [l.name] }]
        data=  @alle_flaschen.map(&:name)
        @data = data.to_json
        
        @liste_der_weine = liste_namen
       #     <%= text_field_tag :search, params[:search],  class:"form-control", placeholder: "Suchen", data: {autocomplete_source: @data} %>
        # @categories = Bottle.uniq.pluck(:category) 
        # @grape = Bottle.uniq.pluck(:grape)
        # @country = Bottle.uniq.pluck(:country) 
         
      
   # @flaschen = Bottle.search_wines(params[:search],params[:category], params[:grape])
    grape = params[:grape]
    category = params[:category]
    country = params[:country]
    search = params[:search]
    
    @flaschen = Bottle.search_wines(search,category,country,grape).order(price: :ASC).page(params[:page]).per(20)
  
    
    
    
 #   if grape != "Alle Rebsorten"
 #    @flaschen = Bottle.where(["lower(name) LIKE lower(?) AND category LIKE ? AND country LIKE ? AND grape LIKE ?","%#{params[:search]}%","%#{params[:category]}%","%#{params[:country]}%","%#{grape}%"]).order(price: :ASC).page(params[:page]).per(20)
 #   else 
 #   @flaschen = Bottle.where(["lower(name) LIKE lower(?) AND category LIKE ? AND country LIKE ?","%#{params[:search]}%","%#{params[:category]}%","%#{params[:country]}%"]).order(price: :ASC).page(params[:page]).per(20)
 #   # @flaschen = Bottle.search_wines(params[:search])
 #   end
 #    @flaschen = @flaschen.order(price: :ASC).page(params[:page]).per(20)
 #    
 #    
 #    
 #   
 #  
 #        
 #    
 #      
 #      
 #       params[:quantity] = 1   if params[:quantity].blank?
 #       @final_price = Bottle.calculate_price(@flaschen, params[:quantity])        
 #      
 #      @big_array = @flaschen.zip(@final_price)
    end
    
    def impressum
    end
    
    def kontakt
    end
    
    def servicebedingungen
    end
    
    
    def datenschutz
    end
    
    def create
        @auswahl = params[:category]
    end
    
    
   
    
        
    
    
end
