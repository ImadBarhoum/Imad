import { defineStore } from 'pinia'
export const useGlobal = defineStore('Global', {
    state: () => ({
        logo:{
          light:'/imgs/logo.png',
          dark:'/imgs/logo_w.png'
        },
        copyright:{
            ar:'developed by sympaweb',
            en:'developed by sympaweb'
        }
    }),
    getters: {},
    actions: {

    },
})