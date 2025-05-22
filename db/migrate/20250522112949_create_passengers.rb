class CreatePassengers < ActiveRecord::Migration[7.1]
  def change
    create_table :passengers do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.boolean :has_child
      t.integer :ticket_id

      t.timestamps
    end
  end
end
