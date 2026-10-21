// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  ssr: false,
  devtools: { enabled: true },

  devServer: {
    host: process.env.HOST,
    port: process.env.PORT
  },

  runtimeConfig:{
    public:{
      site_name: process.env.SITE_NAME,
      url_api: process.env.URL_API,
      url: process.env.URL,
      pwa: process.env.PWA,
      dark: process.env.DARK,
      lang: process.env.LANG
    }
  },

  app: {
    baseURL: '/',
    buildAssetsDir: 'src/',
    head: {
      titleTemplate: '%s - ' + process.env.SITE_NAME,
      title: '',
      meta: [
        {charset: 'utf-8'},
        {name: 'viewport', content: 'width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no'},
        {hid: 'description', name: 'description', content: process.env.SITE_DISC},
        {name: 'keywords', content: ''},
        {name: 'format-detection', content: 'telephone=no'},
        /*{ hid: 'og-image', property: 'og:image', content: process.env.URL+'/imgs/logo_pwa.png' },
        { hid: 'og-type', property: 'og:type', content: 'website' },
        { hid: 'og-title', property: 'og:title', content: process.env.SITE_NAME },
        { hid: 'og-description', property: 'og:description', content: '' },
        { hid: 'twitter-card', property: 'twitter-card', content: 'summary_large_image' },
        { hid: 'twitter-title', property: 'twitter:title', content: process.env.SITE_NAME },
        { hid: 'twitter-description', property: 'twitter:description', content: '' },
        { hid: 'twitter-image', property: 'twitter:image', content: process.env.URL+'/imgs/logo_pwa.png' },*/
      ],
      link: [
        {rel: 'icon', type: 'image/x-icon', href: '/imgs/fav.png'},
        //{rel: 'icon', type: 'image/x-icon', href: '/favicon.ico'},
        {
          rel: "stylesheet",
          href: "https://fonts.googleapis.com/css2?family=Cairo&family=Montserrat&display=swap"
        },
        {rel: "stylesheet", href: "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"}
      ],
      script: []
    }
  },

  css: [
    'assets/style.css',
    'leaflet/dist/leaflet.css',
    'leaflet-draw/dist/leaflet.draw.css'
  ],

  plugins: [
    '~/plugins/vuetify-theme.js',
  ],

  // Modules
  modules: [
    'vuetify-nuxt-module',
    ['@pinia/nuxt', {autoImports: ['defineStore']}],
    '@nuxtjs/i18n',
    '@nuxtjs/leaflet'
  ],

  pinia: {
    storesDirs: ['./stores/**']
  },

  i18n: {
    locales: [
      {name: 'ar', code: 'ar', iso: 'ar', file: 'ar.json', dir: 'rtl'},
      {name: 'en', code: 'en', iso: 'en', file: 'en.json', dir: 'ltr'}
    ],
    lazy: true,
    //langDir: './locales',
    defaultLocale: 'ar',
    detectBrowserLanguage: false,
    strategy: 'prefix_except_default'
  },

  vuetify: {
    moduleOptions: {},
    vuetifyOptions: {
      //styles:{configFile: '~/assets/variables.scss'},
      icons: {
        sets: []
      },
      theme: {
        defaultTheme: "light",
        themes: {
          light: {
            colors: {
              background: '#f5f5f5'
            },
            variables:{
              $treeviewCollapse:'fa-solid fa-home',
              $subgroup:'fa-solid fa-home',
              $dropdown:'fa-solid fa-home'
            }
          },
          dark: {}
        }
      }
    }
  },

  compatibilityDate: '2025-05-15'
})
