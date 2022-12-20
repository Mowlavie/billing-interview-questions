class CreateComputeClusters < ActiveRecord::Migration[7.0]
  def change
    create_table :compute_clusters do |t|
      t.string :name
      t.string :uuid

      t.timestamps
    end
  end
end
