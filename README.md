# rails8-templates - Tailwind
Rails 8 now has [Application tamplates](https://guides.rubyonrails.org/rails_application_templates.html). This is a great way to quickly and easily modify your fresh or existing app. Use this api to write reusable DSL to generate or customize your Rails app. I have created a few of these that I use. They are all called template.rb so I have placed them in seperate branches. You can use the template in a few different ways. To use a template you pass the "-m" flag in the command.

With the recent update to rails 8 and tailwind, I noticed that the tailwind config file in the config folder is no longer present. This has caused some style issues with my projects. This template performs the base tasks of modifing the gitignore and workflow files and includes creating the tailwind config file with the default config. Refer to [tailwind docs](https://tailwindcss.com/docs/theme) for information on further configuration.

1. Open the prefered branch and click on the template.rb file. Click on the "*raw*" button and use that url in the command.
2. Open the prefered branch and copy the template.rb code. Create a template.rb file in the folder you are going to create the new app and pass it in the command.

## Main

```rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/Developer3027/rails-8-templates/refs/heads/tailwind/template.rb```

This template will modify default files and add one new file. The gitignore file to add the line to ignore the bundle folder inside the vendor folder. It will also add some configuration to the ci.yml file for the github workflow to set up pg and run bundle when setting up ruby by grabing the code before the ruby setup and setting the cache to true. Finally it will add a base tailwind config file to the config folder.
