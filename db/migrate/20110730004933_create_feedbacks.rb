class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.string :from
      t.string :email
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
