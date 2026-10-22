<script setup>
const localPath = useLocalePath()
const authData = usePanel().user
</script>

<script>
const localPath = useLocalePath()
const config = useRuntimeConfig().public
const c_dark = config.dark
const c_lang = config.lang
export default {
  data(){
    return{
      is_admin:0,
      drawer:false,
      menu1:[
        {icon: 'fa-solid fa-chart-line', title: 'statistics', to: localPath('/agency/statistics'),admin:0},
        {icon: 'fa-solid fa-home', title: 'ads', to: localPath('/agency/ads'),admin:0},
      ],
      menu2:[
        {icon: 'fa-solid fa-envelope', title: 'messages', to: localPath('/agency/messages'),admin:0},
      ],
      menu3:[
        {icon: 'fa-solid fa-building', title: 'agency', to: localPath('/agency/agency'),admin:0},
        {icon: 'fa-solid fa-sliders', title: 'settings', to: localPath('/agency/settings'),admin:0},
      ],
      menu4:[],
      lang:[
        {code: 'ar', name: 'arabic',img:'ps'},
        {code: 'en', name: 'english',img:'en'}
      ],
      profile:[
        {title: 'settings', icon: 'fa-solid fa-sliders me-3', to: localPath('/agency/settings'),admin:0}
      ]
    }
  },
  mounted() {
    this.drawer = this.$vuetify.display.mdAndUp
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
      this.$router.push('/login')
    }
  }
}
</script>

<template>
  <v-navigation-drawer v-model="drawer" fixed>
    <template v-slot:prepend>
      <NuxtLink to="#" style="text-decoration: none;align-items: center;">
        <v-img :src="$vuetify.theme.current.dark ? $pinia.state.value.Global.logo.dark : $pinia.state.value.Global.logo.light" contain class="my-0 mx-2" :aspect-ratio="1.5/1"></v-img>
      </NuxtLink>
      <v-divider class="mt-2"/>
    </template>

    <v-list nav>
      <v-list-item color="primary" class="mb-2" v-for="(item, idx) in menu1" :key="idx" :to="localPath(item.to)">
        <template v-slot:prepend>
          <v-icon class="ms-3"><i :class="item.icon"></i></v-icon>
        </template>
        <v-list-item-title v-text="$t(item.title)"></v-list-item-title>
      </v-list-item>
      <v-divider v-if="menu2.length !== 0" class="my-2"/>
      <v-list-item color="primary" class="mb-2" v-for="(item, idx) in menu2" :key="idx" :to="localPath(item.to)">
        <template v-slot:prepend>
          <v-icon class="ms-3"><i :class="item.icon"></i></v-icon>
        </template>
        <v-list-item-title v-text="$t(item.title)"></v-list-item-title>
      </v-list-item>
      <v-divider v-if="menu3.length !== 0" class="my-2"/>
      <v-list-item color="primary" class="mb-2" v-for="(item, idx) in menu3" :key="idx" :to="localPath(item.to)">
        <template v-slot:prepend>
          <v-icon class="ms-3"><i :class="item.icon"></i></v-icon>
        </template>
        <v-list-item-title v-text="$t(item.title)"></v-list-item-title>
      </v-list-item>
      <v-divider v-if="menu4.length !== 0" class="my-2"/>
      <v-list-item color="primary" class="mb-2" v-for="(item, idx) in menu4" :key="idx" :to="localPath(item.to)">
        <template v-slot:prepend>
          <v-icon class="ms-3"><i :class="item.icon"></i></v-icon>
        </template>
        <v-list-item-title v-text="$t(item.title)"></v-list-item-title>
      </v-list-item>
    </v-list>

    <template v-slot:append v-if="$pinia.state.value.Global.copyright[$vuetify.locale.current] !== ''">
      <v-divider/>
      <div class="text-center mb-2">
        <span style="font-size: 11px;">{{ $pinia.state.value.Global.copyright[$vuetify.locale.current] }}</span>
      </div>
    </template>
    <v-overlay v-if="$vuetify.display.mdAndDown" v-model="drawer" z-index="1005"></v-overlay>
  </v-navigation-drawer>

  <v-app-bar class="px-3" scroll-behavior="elevate">
    <v-app-bar-nav-icon @click.stop="drawer = !drawer" class="mx-1" icon="fa-solid fa-bars"/>
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
      <v-list min-width="100">
        <v-list-item v-for="(item,idx) in lang" link :key="idx" @click="changeLang(item.code)">
          <v-list-item-title>{{$t(item.name)}}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>
    <v-menu>
      <template v-slot:activator="{ props }">
        <v-btn v-bind="props" icon class="mx-1">
          <v-icon><i class="fa-solid fa-user"></i></v-icon>
        </v-btn>
      </template>
      <v-list min-width="130">
        <v-list-item v-for="(item,idx) in profile" link :to="localPath(item.to)" :key="idx">
          <v-list-item-title><v-icon>{{item.icon}}</v-icon>{{$t(item.title)}}</v-list-item-title>
        </v-list-item>
        <v-list-item link @click="logout">
          <v-list-item-title><v-icon>fa-solid fa-right-from-bracket me-3</v-icon>{{$t('logout')}}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>