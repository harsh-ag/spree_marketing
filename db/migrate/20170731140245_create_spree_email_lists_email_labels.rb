class CreateSpreeEmailListsEmailLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_email_lists_email_labels do |t|

      t.integer :spree_email_label_id, index: true
      t.integer :spree_email_list_id, index: true
      t.timestamps null: false

    end
  end
end
