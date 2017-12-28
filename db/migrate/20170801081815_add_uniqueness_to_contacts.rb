class AddUniquenessToContacts < ActiveRecord::Migration[5.0]
  def change

    add_index :spree_contacts_email_lists, [:spree_email_list_id, :spree_contact_id], unique: true, name: :spree_contacts_email_lists_contact_list

  end
end
