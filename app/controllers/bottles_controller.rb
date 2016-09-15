class BottlesController < ApplicationController
    def index   
         @categories = Bottle.uniq.pluck(:category)
         
        @flaschen = Bottle.where(["name LIKE ? AND category LIKE ?","%#{params[:search]}%","%#{params[:category]}%"]).order(price: :ASC).page(params[:page]).per(20)
       
        @final_price = Bottle.calculate_price(@flaschen, params[:quantity])        
       
       @big_array = @flaschen.zip(@final_price)
    end
    
    def impressum
    end
    
    def kontakt
    end
    
end
