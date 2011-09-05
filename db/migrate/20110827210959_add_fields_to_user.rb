class AddFieldsToUser < ActiveRecord::Migration
  def self.up
	add_column :users, :surname, :string
	add_column :users, :middlename, :string
	add_column :users, :birthday, :date
  end

  def self.down
	remove_column :users, :surname
	remove_column :users, :middlename
	remove_column :users, :birthday
  end
end
