class StringFile < StringIO
  def initialize(file_content, file_name, file_type)
    super(file_content)

    @file_name = file_name
    @file_type = file_type
  end

  def content_type
    @file_type
  end

  def original_filename
    @file_name
  end
end