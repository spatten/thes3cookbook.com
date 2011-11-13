class SiteGenerator

  HTML_FILES_DIR = "/var/lpub/book_generator_repos/thes3cookbook_markdown/html_files"
  BOOK_FILE = "/var/lpub/book_generator_repos/thes3cookbook_markdown/manuscript/Book.txt"
  PUBLIC_DIR = File.expand_path('../../public', __FILE__)
  BOOK_OUTPUT_DIR = File.expand_path('../../public/book', __FILE__)
  
  def initialize
  end

  def clear
    FileUtils.rm_rf(PUBLIC_DIR)
  end

  def generate
    setup_directories
    write_index
    get_input_files
    write_book_files
  end

  def setup_directories
    FileUtils.mkdir_p(BOOK_OUTPUT_DIR)
  end

  def write_index
    File.open(File.join(PUBLIC_DIR, 'index.html'), 'w') do |file|
      file << "Hello"
    end
  end
  
  def get_input_files
    @files = File.read(BOOK_FILE).split("\n")
  end

  def write_book_files
    @files.each do |file|
      html_file = File.basename(file, File.extname(file)) + ".html"
      content = File.read(File.join(HTML_FILES_DIR, html_file))
      File.open(File.join(BOOK_OUTPUT_DIR, html_file), 'w') do |outfile|
        outfile << content
      end
    end
  end
end
