class CreateFights < ActiveRecord::Migration[6.0]
  def change
    create_table :fights do |t|
      t.integer :player_id
      t.integer :enemy_id
      t.string :location
      t.boolean :player_won
      t.timestamps
   end
  end
end
