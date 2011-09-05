class AddIndexToPages < ActiveRecord::Migration
  def self.up
  	add_index :pages, :href, :unique => true
  end

  def self.down
  	remove_index :pages, :href
  end
end
