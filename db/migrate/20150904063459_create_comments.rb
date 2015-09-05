class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :product_id
      t.integer :user_id
      t.string :comment_text

      t.timestamps null: false
    end
  end
end
