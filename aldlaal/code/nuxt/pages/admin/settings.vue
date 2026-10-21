<script setup lang="js">
const {t} = useLocale()
const config = useRuntimeConfig()
useHead({title:t('settings')})
definePageMeta({
  layout:'admin'
})
</script>
<script lang="js">
export default {
  emits:['snack'],
  data () {
    return {
      loading:false,
      data:{
        site_name:'',
        site_description:'',
        site_email:'',
        site_phone:'',
        usd_value:'',
        mini_version_apk:'',
        mini_version_ios:'',
        maintenance:null,
        auto_publish:null,
        sociel_fb:'',
        sociel_insta:'',
        sociel_whats:'',
        sociel_youtube:'',
        sociel_tiktok:'',
        sociel_x:''
      },
    }
  },
  async mounted() {
    await this.getData()
  },
  methods: {
    snack(msg='',color=''){this.$emit('snack',msg,color)},
    async getData(){
      this.loading = true
      const res = await useApi('/admin/settings/get_info', {});
      this.data = res.data
      this.loading = false
    },
    async add(){
      await useApi('/admin/settings/save_info', this.data);
      this.snack('modified_successfully','success')
      this.getData()
    },
    appFilterInput(event,app) {
      let value = event.target.value;
      value = value.replace(/[^0-9.]/g, '');
      const parts = value.split('.');
      if (parts.length > 2) {
        value = value.slice(0, value.lastIndexOf('.'));
      }
      if (parts.length === 2 && parts[1].length > 2) {
        parts[1] = parts[1].slice(0, 2);
        value = parts.join('.');
      }
      if(app === 1){
        this.data.mini_version_apk = value;
      }else if(app === 2){
        this.data.mini_version_ios = value;
      }else if(app === 3){
        this.data.usd_value = value;
      }
    }
  },
}
</script>
<template>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-sliders me-3"></v-icon>{{$t('settings')}}</span>
    <v-spacer/>
    <v-btn color="info" @click="add()" :loading="loading">{{$t('save')}}</v-btn>
  </v-card-title>
  <v-divider/>

  <v-row class="my-3">
    <v-col cols="12" sm="6" md="4"><v-text-field :label="$t('site_name')" v-model="data.site_name" variant="outlined" hide-details></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field :label="$t('phone')" v-model="data.site_phone" variant="outlined" hide-details></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field :label="$t('email')" v-model="data.site_email" variant="outlined" hide-details></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field :label="$t('mini_android_version')" v-model="data.mini_version_apk" variant="outlined" hide-details @input="appFilterInput($event,1)"></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field :label="$t('mini_ios_version')" v-model="data.mini_version_ios" variant="outlined" hide-details @input="appFilterInput($event,2)"></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4">
      <v-select :label="$t('maintenance_mode')" v-model="data.maintenance" :items="[{id:0,name:'disable'},{id:1,name:'enable'}]" item-title="name" item-value="id" hide-details clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
        <template #selection="{ item }">{{ $t(item.title) }}</template>
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
      </v-select>
    </v-col>
    <v-col cols="12" sm="6" md="4">
      <v-select :label="$t('auto_publish')" v-model="data.auto_publish" :items="[{id:0,name:'auto'},{id:1,name:'manual'},{id:1,name:'only_verify'}]" item-title="name" item-value="id" hide-details clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
        <template #selection="{ item }">{{ $t(item.title) }}</template>
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
      </v-select>
    </v-col>
    <v-col v-if="false" cols="12" sm="6" md="4"><v-text-field :label="$t('exchange_value_usd')" v-model="data.usd_value" variant="outlined" hide-details @input="appFilterInput($event,3)"></v-text-field></v-col>
  </v-row>
  <v-divider/>
  <v-row class="my-3">
    <v-col cols="12" sm="6" md="4"><v-text-field label="FACEBOOK" v-model="data.sociel_fb" variant="outlined" hide-details></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field label="INSTAGRAM" v-model="data.sociel_insta" variant="outlined" hide-details></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field label="WHATSAPP" v-model="data.sociel_whats" variant="outlined" hide-details></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field label="YOUTUBE" v-model="data.sociel_youtube" variant="outlined" hide-details></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field label="TIKTOK" v-model="data.sociel_tiktok" variant="outlined" hide-details></v-text-field></v-col>
    <v-col cols="12" sm="6" md="4"><v-text-field label="X" v-model="data.sociel_x" variant="outlined" hide-details></v-text-field></v-col>

  </v-row>

</template>