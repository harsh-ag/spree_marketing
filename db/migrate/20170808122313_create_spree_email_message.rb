class CreateSpreeEmailMessage < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_email_messages do |t|

      t.integer :spree_contact_id, index: true
      t.integer :spree_email_campaign_id, index: true
      t.string :external_id

      t.timestamp null: false

    end
  end
end
