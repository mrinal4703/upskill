/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/main/webapp/WEB-INF/jsp/*.{jsp,html}",
    "./src/main/resources/templates/*.html",
    "./node_modules/flowbite/**/*.js",
    "node_modules/preline/dist/*.js"
  ],
  theme: {
    extend: {
      screens: {
        'max-md': {'max': '1024px'},
      },
      colors: {
        'hexablue': '#4e80b5',
      },
    },
  },
  plugins: [
    require('flowbite/plugin'),
    require('preline/plugin'),
    require('@tailwindcss/forms')
  ],
}
