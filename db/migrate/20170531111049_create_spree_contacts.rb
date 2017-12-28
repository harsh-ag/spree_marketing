class CreateSpreeContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_contacts do |t|
      t.string :email, index: true
      t.integer :placed_orders_count, default: 0, index: true
      t.decimal :avg_order_value, precision: 8, scale: 2
      t.datetime :last_placed_order_at
      t.datetime :optin_date
      t.datetime :optout_date
      t.string :location, index: true
      t.string :data_source

      t.timestamp null: false
    end
  end
end
