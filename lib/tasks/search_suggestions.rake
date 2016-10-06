namespace :search_suggestions do 
    task :index => :environment do 
        SearchSuggestion.index_products
    end
end
