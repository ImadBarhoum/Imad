<script setup lang="js">
const {t} = useLocale()
const config = useRuntimeConfig()
useHead({title:t('settings')})
definePageMeta({
  layout:'agency'
})
</script>
<script lang="js">
export default {
  emits:['snack'],
  data () {
    return {
      loading:false,
      data:{
        name:'',
        email:'',
        phone:'',
        state:'',
        city:'',
      },
      pwd:'',
      pwd_new:'',
      states:[],
      citys:[],
    }
  },
  async mounted() {
    await this.getStates()
    await this.getData()
  },
  methods: {
    snack(msg='',color=''){this.$emit('snack',msg,color)},
    async getData(){
      this.loading = true
      const res = await useApi('/agency/settings/get_info', {});
      this.data = res.data
      this.loading = false
    },
    async edit(){
      await useApi('/agency/settings/edit', this.data);
      this.snack('modified_successfully','success')
      this.getData()
    },
    async edit_pwd(){
      const res = await useApi('/agency/settings/edit_pwd', {pwd: this.pwd,pwd_new: this.pwd_new});
      if(res.status === 1){
        this.snack('pwd_changed_success','success')
        this.getData()
        this.new = ''
        this.pwd_new = ''
      }else{
        this.snack('incorrect password','red')
      }
    },
    async getStates(){
      const res = await useApi('/others/get_states', {});
      this.states = res.data
      this.getCitys();
    },
    async getCitys(){
      this.data.city=null
      const res = await useApi('/others/get_citys', {state:this.data.state});
      this.citys = res.data
    },
  },
}
</script>
<template>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-sliders me-3"></v-icon>{{$t('settings')}}</span>
    <v-spacer/>
  </v-card-title>
  <v-divider/>

  <v-row class="my-3">
    <v-col cols="12" md="6">
      <v-text-field class="mb-4" :label="$t('email')" v-model="data.email" variant="outlined" hide-details disabled></v-text-field>
      <v-text-field class="mb-4" :label="$t('name')" v-model="data.name" variant="outlined" hide-details></v-text-field>
      <v-text-field class="mb-4" :label="$t('phone')" v-model="data.phone" variant="outlined" hide-details></v-text-field>
      <v-select :label="$t('state')" v-model="data.state" :items="states" item-value="name_ar" item-title="name_ar" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" @update:modelValue="getCitys()">
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
      </v-select>
      <v-select :disabled="data.state === null || states.length === 0" :label="$t('city')" v-model="data.city" :items="citys" item-value="name_ar" item-title="name_ar" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
      </v-select>
      <div class="d-flex justify-end">
        <v-btn color="info" @click="edit()" :loading="loading" width="120">{{$t('save')}}</v-btn>
      </div>
    </v-col>
    <v-col cols="12" md="6">
      <v-text-field class="mb-4" :label="$t('password')" v-model="pwd" variant="outlined" hide-details></v-text-field>
      <v-text-field class="mb-4" :label="$t('new password')" v-model="pwd_new" variant="outlined" hide-details></v-text-field>
      <div class="d-flex justify-end">
        <v-btn color="info" @click="edit_pwd()" :loading="loading" width="120">{{$t('save')}}</v-btn>
      </div>
    </v-col>




  </v-row>
</template>