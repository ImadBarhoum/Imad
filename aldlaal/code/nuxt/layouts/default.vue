<script setup lang="js">
//const router = useRouter()
//router.push('/')
// delete those ↑↑

useHome()
await useAuth().check()
</script>
<script lang="js">
export default {
  data(){
    return{
      msg_text:'',
      msg_color:'',
      msg_show:false,
      fab:false,
    }
  },
  async mounted() {

  },
  methods:{
    snack(msg='',color=''){
      if(msg !== '' && color !== ''){
        this.msg_text = this.$t(msg)
        this.msg_color = color
        this.msg_show = true
      }
    },
    onScroll (e) {
      if (typeof window === 'undefined') return
      const top = window.pageYOffset || e.target.scrollTop || 0
      this.fab = top > 100
    },
    goTop() {
      window.scrollTo({top: 0, behavior: 'smooth'});
    }
  }
}
</script>

<template>
  <v-layout v-if="true" class="ar d-block" :dir="$vuetify.locale.current === 'ar' ? 'rtl':'ltr'"
            :style="$vuetify.theme.current.dark ? '':'background-color:#f5f5f5'">
    <HomeMenus/>
    <v-main class="d-flex flex-column" style="min-height: 100vh;">
      <NuxtPage @snack="snack"/>
      <v-spacer/>
      <HomeFooter/>
      <v-fab color="info" size="small" :active="fab" class="me-4" icon="fa-solid fa-angle-up" location="bottom start" appear app @click="goTop()"
             v-scroll="onScroll"></v-fab>
    </v-main>
  </v-layout>
</template>