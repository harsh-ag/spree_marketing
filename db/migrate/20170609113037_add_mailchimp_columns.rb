class AddMailchimpColumns < ActiveRecord::Migration[5.0]
  def change

    add_column :spree_contacts, :mailchimp_id, :string

  end
end
