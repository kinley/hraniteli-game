class CreateSms < ActiveRecord::Migration
  def self.up
    create_table :sms do |t|
    	t.datetime :date
    	t.string :msg
    	t.string :msg_trans
    	t.integer :operator_id
    	t.integer :country_id
    	t.string :operator
    	t.string :user_id
    	t.string :smsid
    	t.integer :num
    	t.float :cost
    	t.boolean :test
    	t.float :cost_rur
    	t.string :sign

      t.timestamps
    end
  end

  def self.down
    drop_table :sms
  end
end
