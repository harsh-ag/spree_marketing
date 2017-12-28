class CreateSpreeContactsEmailLists < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_contacts_email_lists do |t|

      t.integer :spree_email_list_id, index: true
      t.integer :spree_contact_id, index: true
      t.boolean :subscribed, default: true
      t.index :subscribed

      t.timestamp null: false
    end
  end
end
