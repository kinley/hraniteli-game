class CreateUserInfos < ActiveRecord::Migration
  def self.up
    create_table :user_infos do |t|
      t.integer :last_answered
      t.datetime :total_answer_time
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_infos
  end
end
