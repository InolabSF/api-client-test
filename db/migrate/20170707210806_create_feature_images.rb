class CreateFeatureImages < ActiveRecord::Migration[5.0]
  def change
    create_table :feature_images do |t|
      t.integer :entry_id
      t.string :url

      t.timestamps
    end
  end
end
