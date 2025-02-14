# rails8-templates - Flash-Fade
Rails 8 now has [Application tamplates](https://guides.rubyonrails.org/rails_application_templates.html). This is a great way to quickly and easily modify your fresh or existing app. Use this api to write reusable DSL to generate or customize your Rails app. I have created a few of these that I use. They are all called template.rb so I have placed them in seperate branches. You can use the template in a few different ways. To use a template you pass the "-m" flag in the command.

This template will create a stimulus controller called flash that controls the notice and alert partial. It creates a shared folder in app/views if none exists and creates the flash partial. It will review the application.css file and add the flash classes if none are present. You need to copy paste the erb command into the application.html.erb file in the app/views/layouts folder. This will allow the flash alerts or notices to render through the partial.

``` <%= render "shared/flash_notice" %> ```

1. Open the prefered branch and click on the template.rb file. Click on the "*raw*" button and use that url in the command.
2. Open the prefered branch and copy the template.rb code. Create a template.rb file in the folder you are going to create the new app and pass it in the command.

## Flash-Fade new rails command with pg and tailwind

```rails new my-app -d postgresql -c tailwind -m https://https://raw.githubusercontent.com/Developer3027/rails-8-templates/refs/heads/flash-fade/template.rb```
