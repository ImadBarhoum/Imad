<script setup lang="js">
const config = useRuntimeConfig().public
const authData = usePanel().user
const c_dark = config.dark
const c_lang = config.lang
</script>
<script lang="js">
const localPath = useLocalePath()
export default {
  data(){
    return{
      logo: '/imgs/logo.png',
      logo_w: '/imgs/logo.png',
      drawer:false,
      menu:[
        {name:'home',to:'/',icon:'fa-solid fa-house'},
        {name:'about',to:'/about',icon:'fa-solid fa-circle-info'},
        {name:'contact',to:'/contact',icon:'fa-solid fa-paper-plane-top'},
      ],
      lang:[
        {code: 'ar', name: 'arabic',img:'ps'},
        {code: 'en', name: 'english',img:'en'}
      ],
    }
  },
  async mounted() {

  },
  methods:{
    darkmode() {
      this.$vuetify.theme.global.name = this.$vuetify.theme.global.current.dark ? 'light' : 'dark'
      localStorage.setItem('dark', this.$vuetify.theme.current.dark.toString())
    },
    changeLang(code){
      this.$vuetify.locale.current = code
    },
    async logout(){
      await useAuth().logout()
      window.location.reload()
    }
  }
}
</script>
<template>
  <v-navigation-drawer v-model="drawer" temporary>
    <template v-slot:prepend>
      <NuxtLink to="#" style="text-decoration: none;align-items: center;">
        <v-img :src="$vuetify.theme.current.dark ? $pinia.state.value.Global.logo.dark : $pinia.state.value.Global.logo.light" contain class="my-4 mx-2" :aspect-ratio="3/1"></v-img>
      </NuxtLink>
      <v-divider class="mt-2"/>
    </template>
    <v-list nav>
      <v-list-item color="primary" class="mb-2" v-for="(item, idx) in menu" :key="idx" :to="localPath(item.to)">
        <template v-slot:prepend>
          <v-icon class="ms-3"><i :class="item.icon"></i></v-icon>
        </template>
        <v-list-item-title v-text="$t(item.name)"></v-list-item-title>
      </v-list-item>
    </v-list>
    <template v-slot:append v-if="$pinia.state.value.Global.copyright[$vuetify.locale.current] !== ''">
      <v-divider/>
      <div class="text-center mb-2">
        <span style="font-size: 11px;">{{ $pinia.state.value.Global.copyright[$vuetify.locale.current] }}</span>
      </div>
    </template>
    <v-overlay v-model="drawer" z-index="1007"></v-overlay>
  </v-navigation-drawer>

  <v-app-bar class="px-3" scroll-behavior="elevate">
    <v-app-bar-nav-icon @click.stop="drawer = !drawer" class="mx-1 d-inline-flex d-md-none" icon="fa-solid fa-bars"/>
    <NuxtLink to="/" style="text-decoration: none;">
      <v-img :src="$vuetify.theme.current.dark ? $pinia.state.value.Global.logo.dark : $pinia.state.value.Global.logo.light" width="150" class="me-4 ms-md-4"></v-img>
    </NuxtLink>
    <div class="d-none d-md-inline-flex">
      <v-btn color="primary" class="px-4 mx-1 font-weight-bold" variant="text" v-for="(item,idx) in menu" :to="localPath(item.to)" :key="idx" :prepend-icon="item.icon" min-width="120" height="42">{{$t(item.name)}}</v-btn>
    </div>
    <v-spacer/>
    <v-btn v-if="c_dark === '1'" icon @click="darkmode()" class="mx-1">
      <v-icon><i class="fa-solid fa-moon"></i></v-icon>
      <v-tooltip :text="$t('dark mode')" activator="parent" location="bottom"></v-tooltip>
    </v-btn>
    <v-menu v-if="c_lang === '1'">
      <template v-slot:activator="{ props }">
        <v-btn v-bind="props" icon class="mx-1">
          <v-icon><i class="fa-light fa-language"></i></v-icon>
        </v-btn>
      </template>
      <v-list min-width="130">
        <v-list-item :class="item.img !== '' ? 'ps-0':''" v-for="(item,idx) in lang" link :key="idx" @click="changeLang(item.code)">
          <template v-slot:prepend v-if="item.img !== ''">
            <v-img :src="'/imgs/flags/'+item.img+'.png'" :aspect-ratio="1.5/1" height="22"></v-img>
          </template>
          <v-list-item-title>
            {{$t(item.name)}}
          </v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>
    <v-menu v-if="authData.user_type === 'admin' || authData.user_type === 'agency'">
      <template v-slot:activator="{ props }">
        <v-btn v-bind="props" icon class="mx-1">
          <v-icon><i class="fa-solid fa-user"></i></v-icon>
        </v-btn>
      </template>
      <v-list min-width="140">
        <v-list-item v-if="authData.user_type === 'admin'" link :to="localPath('/admin')"><v-list-item-title><v-icon>fa-solid fa-user-tie me-3</v-icon>{{$t('dashboard')}}</v-list-item-title></v-list-item>
        <v-list-item v-if="authData.user_type === 'agency'" link :to="localPath('/agency')"><v-list-item-title><v-icon>fa-solid fa-user-tie me-3</v-icon>{{$t('dashboard')}}</v-list-item-title></v-list-item>
        <v-list-item link @click="logout">
          <v-list-item-title><v-icon>fa-solid fa-right-from-bracket me-3</v-icon>{{$t('logout')}}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>