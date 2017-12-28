require 'csv'

class Spree::ImportService::SheetProcessorService

  attr_reader :location, :headers, :bucket_url, :for_errors, :uploaded_headers
  attr_accessor :records_count

  def initialize(uploaded_file, for_errors=false, headers=[])
    self.class.const_set(:HEADERS, headers)
    self.class.const_set(:ERROR_FILE_HEADERS, HEADERS + [:errors])
    @for_errors = for_errors
    @headers = get_headers
    if uploaded_file
      @uploaded_file = uploaded_file
      @bucket_url = uploaded_file.attachment.path
    end
    @location = get_file_location
  end

  def rows
    open_file(bucket_url) if bucket_url
    records = ::CSV.foreach(location, headers: true, header_converters: :symbol)
    @uploaded_headers = records.first.headers
    @records_count = records.count
    records
  end

  def self.create_error_file(rows, headers)
    obj = self.new(nil, true, headers)
    obj.records_count = rows.count
    generate_error_csv(rows, obj.location)
    obj
  end

  def remove
    FileUtils.rm(location) if File.exist?(location)
  end

  private
    def open_file(bucket_url)
      begin
        File.open(location, 'wb') do |file|
          open(bucket_url) { |net| file.write(net.read) }
        end
      rescue OpenURI::HTTPError
        raise "could not open file"
      end
    end

    def self.generate_error_csv(rows, location)
      CSV.open(location, "wb") do |csv|
        csv << ERROR_FILE_HEADERS
        rows.each do |row|
          csv << row
        end
      end
    end

    def get_file_location
      File.join('/tmp', document_file_name)
    end

    def document_file_name
      for_errors ? 'invalid_records.csv' : @uploaded_file.attachment_file_name
    end

    def get_headers
      for_errors ? ERROR_FILE_HEADERS : HEADERS
    end
end
