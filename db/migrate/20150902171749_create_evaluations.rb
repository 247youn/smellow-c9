class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :product_id
      t.integer :user_id
      t.integer :rate
      t.timestamps null: false
    end
  end
end
