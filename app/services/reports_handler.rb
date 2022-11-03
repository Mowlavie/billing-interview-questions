# called with ReportsHandler.new("zadara").handle
require "s3_files"

class ReportsHandler
  def initialize(options = {})
    @bucket = options[:bucket]
    @s3_service = ENV["USE_S3"] ? S3.new : S3Files.new
    @status_to_event_mapping = {
      "created" => "restored",
    }
  end

  def handle
    @object_list = download_reports_list
    @reports = download_and_parse_reports
  end

  def download_reports_list
    @s3_service.list(bucket: @bucket)
    # Response is {cluster_id}/{type}.{uuid}.{datetime}.json
    # Example response
    #
    # [
    #   1234-1234-1234-1234/VM.5678-5678-5678-5678.20220122T11:22:33Z.json
    # ]
  end

  def download_and_parse_reports
    @object_list.each do |object|
      options = {
        bucket: @bucket,
        object: object,
      }
      body = @s3_service.download(options)
      # Example Body
      #  {
      #     cluster_uuid: "1234-1234-1234-1234",
      #     uuid: "5678-5678-5678-5678",
      #     status: "active"
      #  }
      handle_report(body)

      # We don't wamt to process the same report
      @s3_service.delete(options)
    end
  end

  def handle_report(body)
    json = JSON.parse(body).symbolize_keys
    compute_cluster = ComputeCluster.find_or_create_by(uuid: json[:cluster_uuid])
    compute_cluster.name = json[:cluster_name]
    compute_cluster.save
    vm = VirtualMachine.find_by(uuid: json[:uuid])
    if !vm
      vm = VirtualMachine.create(uuid: json[:uuid], compute_cluster_id: compute_cluster.id, status: "active", name: json[:name])
      Event.create(virtual_machine_id: vm.id, event_type: "created", created_at: Time.now)
      return
    end
    current_status = vm.status
    if current_status != json[:status]
      Event.create(virtual_machine_id: vm.id, event_type: @status_to_event_mapping[current_status], created_at: Time.now)
      vm.status = current_status
      vm.save
    end
  end
end
