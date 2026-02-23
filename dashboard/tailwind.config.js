/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}'
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#eef7ff',
          100: '#d7ecff',
          200: '#b8ddff',
          300: '#86c4ff',
          400: '#4ea3ff',
          500: '#257ff6',
          600: '#1964d3',
          700: '#1750ab',
          800: '#19458b',
          900: '#193c73'
        }
      }
    }
  },
  plugins: []
};
