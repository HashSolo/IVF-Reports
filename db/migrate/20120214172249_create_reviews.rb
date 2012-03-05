class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :clinic_id
      t.integer :user_id
      t.integer :rating
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
