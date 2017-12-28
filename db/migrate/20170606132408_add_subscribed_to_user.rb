class AddSubscribedToUser < ActiveRecord::Migration[5.0]
  def change

    add_column :spree_users, :subscribed, :boolean, default: false
    add_index :spree_users, :subscribed

  end
end
