class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :turn
      t.integer :game_state
      t.integer :num_players

      t.timestamps
    end
  end
end
