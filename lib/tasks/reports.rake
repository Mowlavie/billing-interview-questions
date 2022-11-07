task :run_reports_handler => [:environment] do
  ReportsHandler.new.handle
end

task :reset_reports => [:environment] do
  ComputeCluster.destroy_all
  Event.destroy_all
  VirtualMachine.destroy_all
  
  FileUtils.rm_rf(Rails.root.join("lib/s3_files"))
  FileUtils.copy_entry Rails.root.join("lib/s3_files_template"), Rails.root.join("lib/s3_files")
end
