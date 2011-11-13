class SiteGenerator

  HTML_FILES_DIR = "/var/lpub/book_generator_repos/thes3cookbook_markdown/html_files"
  BOOK_FILE = "/var/lpub/book_generator_repos/thes3cookbook_markdown/manuscript/Book.txt"
  TOC_FILE = "/var/lpub/book_generator_repos/thes3cookbook_markdown/output/toc.html"

  PROJECT_ROOT = File.expand_path('../..', __FILE__)
  PUBLIC_DIR = File.join(PROJECT_ROOT, 'public')
  LAYOUTS_DIR = File.join(PROJECT_ROOT, 'layouts')
  BOOK_OUTPUT_DIR = File.join(PUBLIC_DIR, 'book')
  
  def initialize
    @layout = File.read(File.join(LAYOUTS_DIR, 'site.html'))
  end

  def clear
    FileUtils.rm_rf(PUBLIC_DIR)
  end

  def generate
    setup_directories
    get_input_files
    write_index
    write_book_files
    copy_js_and_css
  end

  private
  
  def setup_directories
    FileUtils.mkdir_p(BOOK_OUTPUT_DIR)
  end

  def write_index
    File.open(File.join(PUBLIC_DIR, 'index.html'), 'w') do |file|
      file << content_in_layout("hello")
    end
  end
  
  def get_input_files
    @files = File.read(BOOK_FILE).split("\n")
    @toc = File.read(TOC_FILE)
  end

  def write_book_files
    @files.each do |file|
      html_file = File.basename(file, File.extname(file)) + ".html"
      content = File.read(File.join(HTML_FILES_DIR, html_file))
      File.open(File.join(BOOK_OUTPUT_DIR, html_file), 'w') do |outfile|
        outfile << content_in_layout(content)
      end
    end
  end

  def copy_js_and_css
    `cp -r #{File.join(PROJECT_ROOT, "static/*")} #{PUBLIC_DIR}`
  end

  def content_in_layout(content)
    Mustache.render(@layout, :content => content, :toc => @toc)
  end
end
