require 'fileutils'

# Copy paste this erb line into views/layouts/application.html.erb where you want alerts:
# <%= render "shared/flash_notice" %>  

# Create stimulus controller for flash messages - alert / notice
# Create flash partial and shared directory, if dir not present
# Append classes to application.css file

# NOTE - This will completely rewrite flash_controller in javascript controllers.
# NOTE - This will create a shared folder in views if none present.
# NOTE - This will create a flash partial in shared folder.
# NOTE - Classes will be appended to application.css file.

# Method to write a file, overwriting existing content
def write_file(file_path, content)
  File.open(file_path, 'w') do |file|
    file.write(content)
  end
rescue => e
  puts "Error writing to #{file_path}: #{e.message}"
end

# Method to append content to a file if it doesn't already exist
def append_to_file(file_path, content)
  existing_content = File.read(file_path) if File.exist?(file_path)
  unless existing_content&.include?(content)
    File.open(file_path, 'a') do |file|
      file.puts(content)
    end
    puts "Appended CSS classes to #{file_path}."
  else
    puts "CSS classes already exist in #{file_path}. Skipping."
  end
rescue => e
  puts "Error appending to #{file_path}: #{e.message}"
end

# Ensure the stimulus javascript directory exists
javascript_dir = 'app/javascript/controllers'
FileUtils.mkdir_p(javascript_dir) unless Dir.exist?(javascript_dir)
puts "Created directory: #{javascript_dir}"

# Create stimulus flash controller file
inside(javascript_dir) do
  write_file('flash_controller.js', <<-CODE
  import { Controller } from "@hotwired/stimulus"

  // Flash controller for alerts and notices of app
  // Will fade out flash messages after 3 seconds
  // Prevents messages from hanging out until pages is refreshed.
  export default class extends Controller {
    connect() {
      setTimeout(() => {
        this.hide();
      }, 3000); // 3000 milliseconds = 3 seconds
    }
  
    hide() {
      this.element.style.transition = "opacity 1s";
      this.element.style.opacity = "0";
      setTimeout(() => {
        this.element.remove();
      }, 1000); // Wait for the transition to finish before removing the element
    }
  
    remove(event) {
      if (event.animationName === "fadeOut") {
        this.element.remove();
      }
    }
  }
CODE
end
puts "Created Stimulus controller: #{javascript_dir}/flash_controller.js"

# Ensure the views shared directory exists
view_share_dir = 'app/views/shared'
FileUtils.mkdir_p(view_share_dir) unless Dir.exist?(view_share_dir)
puts "Created directory: #{view_share_dir}"

# Create flash alert partial file
inside(view_share_dir) do
  write_file('_flash_notice.html.erb', <<-CODE
    <% if notice %>
      <div class="flash flash-notice mt-14 text-center w-full" data-controller="flash" data-action="animationend->flash#remove">
        <%= notice %>
      </div>
    <% end %>
    
    <% if alert %>
      <div class="flash flash-alert mt-14 text-center w-full" data-controller="flash" data-action="animationend->flash#remove">
        <%= alert %>
      </div>
    <% end %>
  CODE
end
puts "Created flash partial: #{view_share_dir}/_flash_notice.html.erb"

# Ensure the css directory exists
style_dir = 'app/assets/stylesheets'
FileUtils.mkdir_p(style_dir) unless Dir.exist?(style_dir)
puts "Created directory: #{style_dir}"

# Path to css file
file_path = File.join(style_dir, "application.css")

# Classes to append
classes_to_append = <<-CODE
 .flash {
  padding: 15px;
  margin-bottom: 10px;
  border: 1px solid transparent;
  border-radius: 4px;
  opacity: 1;
  transition: opacity 1s ease-out;
}

.flash-notice {
  color: #D4E157;
  background-color: #334155;
  border-color: #d6e9c6;
}

.flash-alert {
  color: #fc5a58;
  background-color: #334155;
  border-color: #ebccd1;
}
CODE

# Append Classes to css file
append_to_file(file_path, classes_to_append)
