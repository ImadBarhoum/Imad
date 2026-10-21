<script setup lang="js">
const {t} = useLocale()
const config = useRuntimeConfig()
useHead({title:t('agency')})
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
        description:'',
        email:'',
        phone:'',
        state:'',
        city:'',
        address:'',
        img:'',
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
      const res = await useApi('/agency/agency/get_info', {});
      this.data = res.data
      this.loading = false
    },
    async edit(){
      await useApi('/agency/agency/edit', this.data);
      this.snack('modified_successfully','success')
      this.getData()
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

    popUpload() {
      let fileUpload
      fileUpload = document.getElementById('UploadImages')
      if (fileUpload != null) {
        fileUpload.value = null
        fileUpload.click()
      }
    },
    async uploadImage(e) {
      this.loading = true;
      const images = e.target.files;
      for (let i = 0; i < images.length; i++) {
        const imageFile = images[i];
        const reader = new FileReader();
        reader.readAsDataURL(imageFile);
        reader.onload = async (e) => {
          const compressedImage = await this.compressImage(e.target.result);
          const res = await useApi('/img/save', {img_name: compressedImage});
          this.data.img = res.img_name;
          this.loading = false;
        };
      }
    },
    compressImage(imageDataUrl,quality=0.8) {
      return new Promise((resolve) => {
        const img = new Image()
        img.src = imageDataUrl
        img.onload = () => {
          const canvas = document.createElement('canvas');
          const ctx = canvas.getContext('2d');
          const maxWidth = 800
          const maxHeight = 800
          let width = img.width
          let height = img.height
          if (width > height) {
            if (width > maxWidth) {
              height *= maxWidth / width
              width = maxWidth
            }
          } else {
            if (height > maxHeight) {
              width *= maxHeight / height
              height = maxHeight
            }
          }
          canvas.width = width
          canvas.height = height
          let outputFormat = 'image/jpeg';
          if (imageDataUrl.startsWith('data:image/png')) {
            outputFormat = 'image/png';
            ctx.clearRect(0, 0, canvas.width, canvas.height);
          } else if (imageDataUrl.startsWith('data:image/webp')) {
            outputFormat = 'image/webp';
            ctx.clearRect(0, 0, canvas.width, canvas.height);
          }
          ctx.drawImage(img, 0, 0, width, height)
          resolve(canvas.toDataURL(outputFormat, quality));
        };
      });
    },
  },
}
</script>
<template>
  <input class="d-none" id="UploadImages" type="file" accept="image/*" @change=uploadImage>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-building me-3"></v-icon>{{$t('agency')}}</span>
    <v-spacer/>
    <v-btn color="info" @click="edit()" :loading="loading" width="100">{{$t('save')}}</v-btn>
  </v-card-title>
  <v-divider/>

  <v-row class="my-3">
    <v-col cols="12" md="6">
      <v-text-field class="mb-4" :label="$t('agency name')" v-model="data.name" variant="outlined" hide-details></v-text-field>
      <v-textarea rows="3" class="mb-4" :label="$t('description')" v-model="data.description" variant="outlined" hide-details></v-textarea>
      <v-row>
        <v-col cols="6">
          <v-text-field :label="$t('agency email')" v-model="data.email" variant="outlined" hide-details></v-text-field>
        </v-col>
        <v-col cols="6">
          <v-text-field :label="$t('agency phone')" v-model="data.phone" variant="outlined" hide-details></v-text-field>
        </v-col>
        <v-col cols="6">
          <v-select :label="$t('state')" v-model="data.state" :items="states" item-value="name_ar" item-title="name_ar" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" @update:modelValue="getCitys()">
            <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
          </v-select>
        </v-col>
        <v-col cols="6">
          <v-select :disabled="data.state === null || states.length === 0" :label="$t('city')" v-model="data.city" :items="citys" item-value="name_ar" item-title="name_ar" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
            <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
          </v-select>
        </v-col>
      </v-row>
      <v-text-field class="mb-4" :label="$t('address')" v-model="data.address" variant="outlined" hide-details></v-text-field>
    </v-col>
    <v-col cols="12" md="6">

      <v-hover v-slot="{ isHovering, props }">
        <v-card class="mb-4" outlined @click="popUpload()">
          <v-img class="align-center justify-center text-center" :src="data.img !== '' ? config.public.url_api+'/uploads/imgs/md/'+data.img : '/imgs/agency.png'" :aspect-ratio="4/3" cover v-bind="props">
            <v-fade-transition>
              <v-icon v-if="isHovering && !$vuetify.display.mobile" size="80" color="blue-lighten-4">fa-solid fa-plus</v-icon>
            </v-fade-transition>
          </v-img>
        </v-card>
      </v-hover>

    </v-col>




  </v-row>
</template>