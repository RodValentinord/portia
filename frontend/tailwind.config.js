const { createThemes } = require('tailwindcss-themer');

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx}',
    './src/app/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('tailwindcss-animate'),
    require('@tailwindcss/typography'),
    createThemes({
      default: {}, // necessário para habilitar @theme inline no globals.css
    }),
  ],
};
