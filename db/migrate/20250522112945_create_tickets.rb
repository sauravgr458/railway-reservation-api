class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.string :status, default: 'waiting_list', null: false
      t.string :berth_type
      t.integer :berth_number

      t.timestamps
    end
  end
end
