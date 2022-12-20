class CreateVirtualMachines < ActiveRecord::Migration[7.0]
  def change
    create_table :virtual_machines do |t|
      t.string :name
      t.string :uuid
      t.string :status
      t.integer :compute_cluster_id
      t.boolean :deleted, default: false, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
