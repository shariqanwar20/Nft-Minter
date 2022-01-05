module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      animation: {
        'gradient-x':'gradient-x 3s ease infinite',
    },
      keyframes: {
          'gradient-x': {
              '0%, 100%': {
                  'background-size':'200% 200%',
                  'background-position': 'left center'
              },
              '50%': {
                  'background-size':'200% 200%',
                  'background-position': 'right center'
              }
          }
      }
    },
    colors: {
      "background": "#0D1116",
      "font1": "#35AEE2",
      "font2": "#5AC36A",
    }
  },
  plugins: [],
}
