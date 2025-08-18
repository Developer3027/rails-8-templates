# rails8-templates
Rails 8 now has [Application tamplates](https://guides.rubyonrails.org/rails_application_templates.html). This is a great way to quickly and easily modify your fresh or existing app. Use this api to write reusable DSL to generate or customize your Rails app. I have created a few of these that I use. They are all called template.rb so I have placed them in seperate branches. You can use the template in a few different ways. To use a template you pass the "-m" flag in the command.

This template adds a ivory and pastel color theme config, including animations, to your Tailwind installation. It also creates a instructional markdown document in the root that outlines how to use and how to make modification. Pass the -c flag with Tailwind then the -m flag pointing to the template, (see 'How to impliment). This allows the CLI to install tailwind as it would normally and the template is a bonus, preset config, ready to run from bin/dev.

How to impliment.
1. Open the prefered branch and click on the template.rb file. Click on the "*raw*" button and use that url in the command.
2. Open the prefered branch and copy the template.rb code. Create a template.rb file in the folder you are going to create the new app and pass it in the command.

## Command for existing rails app

```bin/rails app:template LOCATION=https://raw.githubusercontent.com/Developer3027/rails8-templates/refs/heads/tailwind-8/template.rb```

## Command for new rails app

```rails new my-app -d postgresql -c tailwind -m https://raw.githubusercontent.com/Developer3027/rails8-templates/refs/heads/tailwind-8/template.rb```

The main branch template is just the base version I use when building any default app I want to play, learn, or explore with. This branch - template will rewrite one file and create another. The tailwind/application.css (add theme config) and markdown document in root.
