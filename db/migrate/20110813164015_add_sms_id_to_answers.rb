class AddSmsIdToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :sms_id, :integer
  end

  def self.down
    remove_column :answers, :sms_id
  end
end
