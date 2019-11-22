class CreateEnemies < ActiveRecord::Migration[6.0]
  def change
    create_table :enemies do |t|
      t.string :name
      t.string :creature_type
      t.integer :health
      t.string :motto
      t.timestamps
   end
  end
end