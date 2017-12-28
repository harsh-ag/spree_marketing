class CreateSpreeEmailLists < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_email_lists do |t|
      t.string :type
      t.string :name
      t.string :variant_sku
      t.index :variant_sku
      t.string :search_options
      t.string :external_id
      t.index :external_id

      t.timestamp null: false
    end
  end
end
