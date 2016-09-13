class CreateBottles < ActiveRecord::Migration
  def change
    create_table :bottles do |t|
       t.string :name
       t.integer :shop_id
       t.decimal :price
       t.string :vinyard
       t.string  :vintage
       t.string :grape
       t.string :country
       t.integer :shop_id
       t.string :product_url
       t.string :image_url
       t.string :category
       t.string :general_info
       t.decimal :price_per_litre
       t.string :inhalt
       t.string :price_per_litre_string
       t.timestamps null: false
      
      
    end
  end
end