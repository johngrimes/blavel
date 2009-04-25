module FileUtilities
  # Simulate file data from a file upload form
  def uploaded_file(path, content_type = "application/octet-stream", filename = nil)
    filename ||= File.basename(path)
    t = Tempfile.new(filename)
    FileUtils.copy_file(path, t.path)
    (class << t; self; end;).class_eval do
      alias local_path path
      define_method(:original_filename) { filename }
      define_method(:content_type) { content_type }
    end
    return t
  end
  
  # Save a remote file to a local path
  def save_remote_file(server, remote_path, local_path)
    Net::HTTP.start(server) { |http|
      response = http.get(remote_path)
      open(local_path, 'wb') { |file|
        file.write(response.body)
      }
    }
  end
end