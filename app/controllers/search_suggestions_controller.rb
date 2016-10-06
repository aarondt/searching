class SearchSuggestionsController < ApplicationController
    def index
        
        #render json: %w[foo bar]
        render json: SearchSuggestion.terms_for(params[:search])
        
        
       #  liste_namen = []
    #    @alle_flaschen = Bottle.where("name LIKE ?", "%#{params[:search]}")
     #   @alle_flaschen.each do |x|
      #      liste_namen << x.name
      #  end
        
       #render json: @alle_flaschen.map(&:name)
    end 


end
