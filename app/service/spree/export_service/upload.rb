class Spree::ExportService::Upload

  def initialize(file_path, upload_file_name)
    @s3 = Aws::S3::Resource.new
    @file_path = file_path
    @upload_file_name = upload_file_name
    @object = @s3.bucket(ENV['SHINSHU_BUCKET_NAME']).object(@upload_file_name)
  end

  def push
    @object.upload_file(@file_path, acl: 'public-read')
    @object.public_url
  end

end
