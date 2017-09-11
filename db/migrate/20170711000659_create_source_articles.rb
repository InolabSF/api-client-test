class CreateSourceArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :source_articles do |t|
      t.integer :entry_id
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
