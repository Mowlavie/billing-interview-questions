class S3Files
  def initialize
    @s3_files_root = Rails.root.join("lib/s3_files")
  end

  def list(options)
    files = Dir.glob(File.join(@s3_files_root, "**/*")).reject { |fn| File.directory?(fn) }
  end

  def download(options)
    File.read(File.join(options[:object]))
  end

  def delete(options = {})
    if File.exist?(options[:object])
      File.delete(options[:object])
    end
  end
end
