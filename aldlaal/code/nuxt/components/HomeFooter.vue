<script lang="js">
export default {
  data(){
    return{

    }
  },
  async mounted() {

  },
  methods:{

  }
}
</script>
<template>
  <v-sheet color="grey-darken-4">
    <div style="width: 100%;">
      <v-container>
        <v-row class="mt-2">
          <v-col cols="12" sm="6" md="3">
            <h3 class="mb-3">إسم الموقع</h3>
            <div>أي محتوى....</div>
          </v-col>
          <v-col cols="12" sm="6" md="3">
            <h3 class="mb-3">{{$t('contact')}}</h3>
            <div><a href="#" style="text-decoration: none;color: white"><span class="mb-2 me-2 fa-solid fa-phone"></span></a></div>
            <div><a href="#" style="text-decoration: none;color: white"><span class="mb-2 me-2 fa-solid fa-at"></span></a></div>
            <div><span class="mb-2 me-2 fa-solid fa-city"></span></div>
          </v-col>
          <v-col cols="12" sm="6" md="3">
            <h3 class="mb-3">{{$t('social media')}}</h3>
            <div><a href="#" target="_blank" style="text-decoration: none;color: white"><span class="mb-2 me-2 fa-brands fa-facebook"></span>{{$t('facebook')}}</a></div>
            <div><a href="#" target="_blank" style="text-decoration: none;color: white"><span class="mb-2 me-2 fa-brands fa-instagram"></span>{{$t('instagram')}}</a></div>
            <div><a href="#" target="_blank" style="text-decoration: none;color: white"><span class="mb-2 me-2 fa-brands fa-x"></span>{{$t('twitter')}}</a></div>
          </v-col>
          <v-col class="align-center" cols="12" sm="6" md="3">
            <v-img :src="$pinia.state.value.Global.logo.dark" :aspect-ratio="3/1"></v-img>
          </v-col>
        </v-row>
      </v-container>
      <v-divider thickness="2" color="white"/>
      <v-container class="py-3" style="font-size: 12px;" >
        <div class="d-flex">
          <div><v-icon class="mx-1" size="12">fa-solid fa-copyright</v-icon> {{ new Date().getFullYear() }}</div>
          <v-spacer/>
          <div>{{ $pinia.state.value.Global.copyright[$vuetify.locale.current] }}</div>
        </div>
      </v-container>
    </div>
  </v-sheet>
</template>