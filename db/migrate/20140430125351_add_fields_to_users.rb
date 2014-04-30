class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :is_coach, :boolean 
  	add_column :users, :token, :string
  	add_column :users, :avatar, :string
  	add_column :users, :phone, :string
  	add_column :users, :language, :string
  	add_column :users, :sport_id, :integer
  	add_column :users, :credit_card_id, :integer
  	add_column :users, :location_id, :integer
  	add_column :users, :experience, :integer
  	add_column :users, :qualification, :string
  	add_column :users, :achievements, :string
  	add_column :users, :description, :string
  end
end
