class CreateSpreeEmailLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_email_labels do |t|

      t.string :name
      t.timestamps null: false

    end
  end
end
