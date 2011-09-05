class AddPromoToAnswers < ActiveRecord::Migration
  def self.up
	add_column :answers, :promo_used, :boolean
  end

  def self.down
	remove_column :answers, :promo_used	
  end
end
