class CreateLegalHostingAbuseResourceActivityTypes < ActiveRecord::Migration
  def change
    create_table :legal_hosting_abuse_resource_activity_types do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end