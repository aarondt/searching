class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.string :shop_logo
      t.timestamps null: false
      t.decimal :versandkosten
      t.integer :mindest_bestellmenge
      t.decimal :versandkostenfrei_ab_betrag
      t.integer :versandkostenfrei_ab_menge
      t.decimal :verpackungsrabatt
      t.integer :verpackungsrabatt_menge
      t.decimal :mengenrabatt
      t.integer :mengenrabatt_menge
    end
  end
end
