/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/components/**/*',
  ],
  theme: {
    extend: {
      colors: {
        'um_blue': '#00274C',
        'um_yellow': '#FFCB05',
        'laitan_blue': '#003366',
        'laitan_blue_light': '#003366',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
