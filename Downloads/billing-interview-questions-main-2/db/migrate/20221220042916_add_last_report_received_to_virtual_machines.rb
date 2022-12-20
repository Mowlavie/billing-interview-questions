class AddLastReportReceivedToVirtualMachines < ActiveRecord::Migration[7.0]
  def change
    add_column :virtual_machines, :last_report_received, :datetime
  end
end
