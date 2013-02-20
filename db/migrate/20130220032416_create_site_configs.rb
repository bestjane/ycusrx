class CreateSiteConfigs < ActiveRecord::Migration
  def change
    create_table :site_configs do |t|
      t.string :key
      t.string :title
      t.text :content
      t.string :url
      t.string :cover

      t.timestamps
    end
  end
end
