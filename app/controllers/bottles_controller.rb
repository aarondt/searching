class BottlesController < ApplicationController
    def index   
         @categories = Bottle.uniq.pluck(:category)
         
         
        @flaschen = Bottle.where(["lower(name) LIKE lower(?) AND category LIKE ?","%#{params[:search]}%","%#{params[:category]}%"]).order(price: :ASC).page(params[:page]).per(20)
       
        params[:quantity] = 1   if params[:quantity].blank?
        @final_price = Bottle.calculate_price(@flaschen, params[:quantity])        
       
       @big_array = @flaschen.zip(@final_price)
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
