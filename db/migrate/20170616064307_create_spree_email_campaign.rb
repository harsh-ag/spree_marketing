class CreateSpreeEmailCampaign < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_email_campaigns do |t|
      t.string :name
      t.string :external_id, null: false
      t.references :spree_email_list, index: true
      t.string :template_name
      t.datetime :scheduled_at

      t.timestamp null: false
    end
  end
end
