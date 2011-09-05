class AddOpenDateToQuestions < ActiveRecord::Migration
  def self.up
  	add_column :questions, :open_date, :datetime
  end

  def self.down
  	remove_column :questions, :open_date
  end
end
