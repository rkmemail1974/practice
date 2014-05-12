class CreateTerritories < ActiveRecord::Migration
  def change
    create_table :territories do |t|
      t.integer :owner_id
      t.integer :num_armies
      t.integer :geo_state
      t.integer :game_id

      t.timestamps
    end
  end
end
