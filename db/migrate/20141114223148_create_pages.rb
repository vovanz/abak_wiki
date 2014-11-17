class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :name
      t.string :parent_url
      t.string :url_downcase
      t.text :content
    end
    add_index :pages, :url_downcase, :unique => true
  end
end
