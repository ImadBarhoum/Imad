import { defineStore } from 'pinia'
export const usePanel = defineStore('Panel', {
    state: () => ({
        user:{
            user_type:'',
            id:0,
            user:'',
            token:''
        },
        map:{
            center:[33.461591,36.2873869],
            zoom: 9,
        }
    }),
    getters: {},
    actions: {

    },
})