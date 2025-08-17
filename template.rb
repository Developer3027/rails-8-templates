# template.rb

# 1. Define CSS Content
# This heredoc stores the custom theme configuration for Tailwind CSS.
tailwind_css_content = <<~CSS
  @theme {
    --color-ivory-50: #fefdfb;
    --color-ivory-100: #fdf9f3;
    --color-ivory-200: #faf2e7;
    --color-ivory-300: #f6e8d7;
    --color-ivory-400: #f0d9c3;
    --color-ivory-500: #e8c7a6;
    --color-ivory-600: #d4a574;
    --color-ivory-700: #b8834a;
    --color-ivory-800: #8f6238;
    --color-ivory-900: #6b4a2a;

    --color-pastel-pink: #f8d7da;
    --color-pastel-lavender: #e2d5f1;
    --color-pastel-mint: #d1f2eb;
    --color-pastel-peach: #fdebd0;
    --color-pastel-sky: #cce7ff;
    --color-pastel-sage: #e8f5e8;

    --font-family-sans: 'Inter var', ui-sans-serif, system-ui, sans-serif;
  }

  @keyframes fadeIn {
    0% { opacity: 0; }
    100% { opacity: 1; }
  }

  @keyframes slideUp {
    0% { transform: translateY(10px); opacity: 0; }
    100% { transform: translateY(0); opacity: 1; }
  }

  @theme {
    --animate-fade-in: fadeIn 0.5s ease-in-out;
    --animate-slide-up: slideUp 0.3s ease-out;
  }
CSS

# 2. Handle the CSS File
# This ensures the default Tailwind CSS file is replaced with our custom theme.
# Using `remove_file` with `force: true` handles both cases where the file
# does or does not exist, simplifying the logic.
tailwind_css_path = "app/assets/tailwind/application.css"

remove_file tailwind_css_path, force: true
create_file tailwind_css_path, tailwind_css_content

say "✅ Custom Tailwind CSS theme has been applied.", :green

# 3. Create the Markdown Documentation File
# This creates a helpful guide in the project root for developers to understand
# and modify the new Tailwind theme configuration.
create_file "tailwind-config.md", <<~MARKDOWN
# Tailwind CSS Theme Configuration

This file outlines the custom theme properties added to your Tailwind CSS setup via the `tailwind-rails` gem.

## Location

The theme configuration is located in: `app/assets/tailwind/application.css`

## Modifying the Theme

You can modify the theme directly within the `@theme` block in the `application.css` file. The current theme is an ivory and patel theme intended to show configuration.

### Colors

Custom colors are defined using CSS variables. You can add new variables or change existing ones.

**Example:**
```css
@theme {
  --color-ivory-50: #fefdfb;
  /* ... other colors */
  --color-new-brand-blue: #0055a4;
}
MARKDOWN

say "✅ Custom Tailwind theme doc created in root.", :green
