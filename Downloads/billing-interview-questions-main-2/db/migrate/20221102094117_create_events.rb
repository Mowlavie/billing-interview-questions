class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.integer :virtual_machine_id
      t.string :event_type

      t.timestamps
    end
  end
end
