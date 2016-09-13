class Search < ActiveRecord::Base

def search_wines
    
    bottle = Bottle.all
    
    bottle = bottle.where(["name LIKE ?", "%#{keywords}%"]) if keywords.present?
    bottle = bottle.where(["category LIKE ?", category]) if category.present?
    bottle = bottle.where(["price >= ?", min_price]) if min_price.present?
    bottle = bottle.where(["price <= ?", max_price]) if max_price.present?
    bottle = bottle.where(["vintage LIKE ?", vintage]) if vintage.present?
    
    
    return bottle
end

    
    
end
