class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :user_id
      t.string :title, :null => false
      t.text :content
      t.text :content_html
      t.integer :hit, :default => 0
      t.boolean :sticky, :default => false 
      t.boolean :comments_closed, :default => false
      t.integer :comments_count, :default => 0
      t.string :last_replied_by
      t.datetime :last_replied_at
      t.datetime :involved_at
      
      t.timestamps
    end
  end
end
