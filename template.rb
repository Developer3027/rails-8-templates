# template.rb

# Helper method for styled console output to improve user feedback.
def say_status(status, message)
  say "\e[1m\e[32m#{status.to_s.rjust(12)}\e[0m\e[1m  #{message}\e[0m"
end

say_status :info, "Applying custom Tailwind CSS theme..."

# ----------------------------------------------------------------------------
# 1. DEFINE THE CUSTOM TAILWIND CSS CONFIGURATION
# ----------------------------------------------------------------------------
# This heredoc contains the custom colors, fonts, and animations.
# Using the `@theme` directive is the modern way to extend Tailwind in Rails.
tailwind_config = <<~CSS
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

# ----------------------------------------------------------------------------
# 2. CREATE OR REPLACE THE MAIN TAILWIND STYLESHEET
# ----------------------------------------------------------------------------
# The `create_file` method handles both creation and replacement.
# It automatically creates parent directories if they don't exist.
# Using `force: true` ensures it overwrites any existing file without
# prompting the user, which is ideal for an automated template.
tailwind_css_path = "app/assets/stylesheets/tailwind/application.css"
create_file tailwind_css_path, tailwind_config, force: true
say_status :replace, tailwind_css_path

# ----------------------------------------------------------------------------
# 3. DEFINE THE DOCUMENTATION CONTENT
# ----------------------------------------------------------------------------
# This markdown content will guide developers on how to use and
# modify the custom Tailwind theme.
tailwind_docs = <<~MARKDOWN
# Customizing Your Tailwind CSS Theme

This project uses a custom Tailwind CSS configuration located at `app/assets/stylesheets/tailwind/application.css`. This file allows for easy theme extension using Tailwind's `@theme` directive, which is the modern and recommended approach for customization in Rails.

## Understanding `app/assets/stylesheets/tailwind/application.css`

This file is your central hub for extending the default Tailwind theme. It's processed by Tailwind's JIT (Just-In-Time) compiler, making your custom values available as utility classes throughout your application.

For example, a variable `--color-ivory-500` inside `@theme` becomes available as `bg-ivory-500`, `text-ivory-500`, etc.

---

## How to Modify the Theme

### Adding New Colors 🎨

To add a new color palette, open the CSS file and add your custom properties within the `@theme` block. Follow the existing naming convention (`--color-<name>-<shade>`).

```css
@theme {
  /* ... existing colors */

  --color-slate-50: #f8fafc;
  --color-slate-100: #f1f5f9;
  /* ... more shades */
}
MARKDOWN
