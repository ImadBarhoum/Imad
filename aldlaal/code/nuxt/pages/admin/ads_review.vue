<script setup lang="js">
const {t} = useLocale()
const localPath = useLocalePath()
const config = useRuntimeConfig()
const mapDefault = usePanel().map
useHead({title:t('ads_review')})
definePageMeta({
  layout:'admin'
})
</script>
<script lang="js">
export default {
  emits: ['snack'],
  data() {
    return {
      loading: false,
      options: {page: 1},
      table: {
        total: 1,
        loading: true,
        tab:null,
        imgSel:null,
        currentIndex: 0,
        pageCount: 1,
        perPage: 6,
        perPageItem: [6, 8, 10, 20],
        data: [],
        headers: [
          {key: 'img', sortable: false, title: '', width: 80, align: 'center'},
          {key: 'create_at', sortable: false, title: 'date', width: 140, align: ''},
          {key: 'title', sortable: false, title: 'title', width: 200, align: ''},
          {key: 'agency', sortable: false, title: 'agency_name', width: 130, align: ''},
          {key: 'purpose', sortable: false, title: 'purpose', width: 100, align: 'center'},
          {key: 'type', sortable: false, title: 'type', width: 100, align: 'center'},
          {key: 'state', sortable: false, title: 'state', width: 100, align: 'center'},
          {key: 'city', sortable: false, title: 'city', width: 100, align: 'center'},
          {key: 'bedrooms', sortable: false, title: 'bedrooms', width: 20, align: 'center'},
          {key: 'bathrooms', sortable: false, title: 'bathrooms', width: 20, align: 'center'},
          {key: 'garages', sortable: false, title: 'garages', width: 20, align: 'center'},
          {key: 'area_m2', sortable: false, title: 'area_m2', width: 80, align: 'center'},
          {key: 'price', sortable: false, title: 'price', width: 80, align: 'center'},
          {key: 'estate_status', sortable: false, title: 'estate_status', width: 100, align: 'center'},
          {key: 'status', sortable: false, title: 'status', width: 100, align: 'center'},
          {key: 'action', sortable: false, title: 'action', width: 135, align: 'center'},
        ],
        is_edit: false,
        dialog_add: false,
        dialog_remove: false,
        item: {
          id: null,
          agency_id: null,
          title: '',
          description: '',
          purpose: '',
          type: '',
          price: '',
          bedrooms: '',
          bathrooms: '',
          garages: '',
          area_m2: '',
          state: '',
          city: '',
          address: '',
          location: null,
          img: '',
          plan_img: '',
          imgs: [],
          estate_status: '',
          admin_review: '',
          status: 'active'
        },
        states:[],
        citys:[],
        citys2:[],
        agencys:[],
        purpose:['sale', 'rent'],
        types:['apartment', 'villa', 'land', 'commercial','chalet'],
        estate_status:['available','sold','rented'],
        status:['active','inactive'],
        admin_review:['pending','approved','rejected'],
        numbers:[0,1,2,3,4,5,6,7,8,9,10],
        search:{
          id:null,
          agency_id:null,
          title:'',
          description:'',
          purpose:null,
          type:null,
          bedrooms:null,
          bathrooms:null,
          garages:null,
          city:null,
          state:null,
          estate_status:'available',
          price_min:'',
          price_max:'',
          size_min:'',
          size_max:'',
        }
      },
    }
  },
  async mounted() {
    await this.getStates()
    await this.getAgencys()
    await this.initTable()
    await this.getData()
  },
  methods: {
    snack(msg = '', color = '') {
      this.$emit('snack', msg, color)
    },
    async initTable() {
      const perPage = localStorage.getItem('perPage')
      if (perPage != null) {
        this.table.perPage = parseInt(perPage)
      }
      this.table.loading = false
    },
    async getData(x=0) {
      this.table.loading = true
      if(x===1){this.options.page = 1}
      const {sortBy, sortDesc, page, itemsPerPage} = this.options
      const res = await useApi('/admin/properties/get_page', {
        page: page, per_page: this.table.perPage, admin_review: 'pending',
        id: this.table.search.id, agency_id: this.table.search.agency_id,
        title: this.table.search.title, description: this.table.search.description,
        purpose: this.table.search.purpose, type: this.table.search.type,
        bedrooms: this.table.search.bedrooms, bathrooms: this.table.search.bathrooms,
        garages: this.table.search.garages, city: this.table.search.city,
        state: this.table.search.state, estate_status: this.table.search.estate_status,
        price_min: this.table.search.price_min, price_max: this.table.search.price_max,
        size_min: this.table.search.size_min, size_max: this.table.search.size_max
      });
      this.table.data = res.data.items
      this.table.total = res.data.total
      this.table.pageCount = Math.ceil(this.table.total / this.table.perPage)
      this.table.loading = false
    },
    setperPage(v) {
      this.table.perPage = v
      localStorage.setItem('perPage', v)
      this.options.page = 1
      this.getData()
    },
    dialog_add() {
      this.table.is_edit = false
      this.table.item.id = 0
      this.table.item.agency_id = null
      this.table.item.title = ''
      this.table.item.description = ''
      this.table.item.purpose = null
      this.table.item.type = null
      this.table.item.price = ''
      this.table.item.bedrooms = null
      this.table.item.bathrooms = null
      this.table.item.garages = null
      this.table.item.area_m2 = ''
      this.table.item.state = null
      this.table.item.city = null
      this.table.item.address = ''
      this.table.item.location = null
      this.table.item.img = ''
      this.table.item.plan_img = ''
      this.table.item.imgs = []
      this.table.item.estate_status = 'available'
      this.table.item.admin_review = null
      this.table.item.status = 'active'
      this.getCitys();
      this.table.tab=null
      this.table.dialog_add = true
    },
    dialog_edit(item) {
      this.table.is_edit = true
      this.table.item.id = item.id
      this.table.item.agency_id = item.agency_id
      this.table.item.title = item.title
      this.table.item.description = item.description
      this.table.item.purpose = item.purpose
      this.table.item.type = item.type
      this.table.item.price = item.price
      this.table.item.bedrooms = item.bedrooms
      this.table.item.bathrooms = item.bathrooms
      this.table.item.garages = item.garages
      this.table.item.area_m2 = item.area_m2
      this.table.item.state = item.state
      this.table.item.city = item.city
      this.table.item.address = item.address
      this.table.item.location = item.location
      this.table.item.img = item.img
      this.table.item.plan_img = item.plan_img
      this.table.item.imgs = item.imgs
      this.table.item.estate_status = item.estate_status
      this.table.item.admin_review = item.admin_review
      this.table.item.status = item.status
      this.getCitys();
      this.table.tab=null
      this.table.dialog_add = true
    },
    async add() {
      const res = await useApi('/admin/properties/add', {
        agency_id: this.table.item.agency_id, title: this.table.item.title,
        description: this.table.item.description, purpose: this.table.item.purpose, type: this.table.item.type, price: this.table.item.price,area_m2: this.table.item.area_m2,
        bedrooms: this.table.item.bedrooms, bathrooms: this.table.item.bathrooms, garages: this.table.item.garages,
        state: this.table.item.state, city: this.table.item.city, address: this.table.item.address,
        location: this.table.item.location,
        img: this.table.item.img,plan_img: this.table.item.plan_img,imgs: this.table.item.imgs,status: this.table.item.status,estate_status: this.table.item.estate_status,admin_review: this.table.item.admin_review
      });
      if(res.status === 1){
        this.snack('added_successfully', 'success')
        this.getData()
      }
      this.table.dialog_add = false
    },
    dialog_remove(id) {
      this.table.item.id = id
      this.table.dialog_remove = true
    },
    async edit() {
      const res = await useApi('/admin/properties/edit', {
        id: this.table.item.id, agency_id: this.table.item.agency_id, title: this.table.item.title,
        description: this.table.item.description, purpose: this.table.item.purpose, type: this.table.item.type, price: this.table.item.price,area_m2: this.table.item.area_m2,
        bedrooms: this.table.item.bedrooms, bathrooms: this.table.item.bathrooms, garages: this.table.item.garages,
        state: this.table.item.state, city: this.table.item.city, address: this.table.item.address,
        location: this.table.item.location,
        img: this.table.item.img,plan_img: this.table.item.plan_img,imgs: this.table.item.imgs,status: this.table.item.status,estate_status: this.table.item.estate_status,admin_review: this.table.item.admin_review
      });
      if(res.status === 1){
        this.snack('modified_successfully', 'success')
        this.getData()
      }
      this.table.dialog_add = false
    },
    async remove() {
      await useApi('/admin/properties/remove', {id: this.table.item.id});
      this.snack('deleted_successfully', 'success')
      this.table.dialog_remove = false
      this.getData()
    },
    async getStates(){
      const res = await useApi('/others/get_states', {});
      this.table.states = res.data
    },
    async getCitys(x=0){
      if(x===1){
        this.table.item.city=null
        const res = await useApi('/others/get_citys', {state:this.table.item.state});
        this.table.citys2 = res.data
      }else{
        this.table.search.city=null
        const res = await useApi('/others/get_citys', {state:this.table.search.state});
        this.table.citys = res.data
      }
    },
    async getAgencys(){
      const res = await useApi('/admin/agencys/get_agencys', {});
      this.table.agencys = res.data
    },

    mapZone(polygon){},
    mapLocation(location){this.table.item.location = JSON.parse(JSON.stringify(location))},
    isNumber: function(evt) {
      evt = (evt) ? evt : window.event;
      var charCode = (evt.which) ? evt.which : evt.keyCode;
      if ((charCode > 31 && (charCode < 48 || charCode > 57)) && charCode !== 46) {
        evt.preventDefault();
      } else {
        return true;
      }
    },
    popUpload(id){
      let fileUpload
      if(id === 1){
        this.table.imgSel = 1
        fileUpload = document.getElementById('UploadImages')
      }else if(id === 2){
        this.table.imgSel = 2
        fileUpload = document.getElementById('UploadImages2')
      }
      else if(id === 3){
        this.table.imgSel = 3
        fileUpload = document.getElementById('UploadImages')
      }
      if (fileUpload != null) {
        fileUpload.value = ''
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
          if(this.table.imgSel === 1){
            this.table.item.imgs.push(res.img_name)
          }else if(this.table.imgSel === 2){
            this.table.item.img = res.img_name
          }
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
    removeImg(idx){
      if (idx > -1) {
        this.table.item.imgs.splice(idx, 1);
      }
    },
  },
}
</script>
<template>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-hourglass-half me-3"></v-icon>{{ $t('ads_review') }} <v-chip class="ms-1 px-4" v-if="table.total !== 0">{{ table.total }}</v-chip></span>
    <v-spacer/>
  </v-card-title>
  <v-divider/>
  <v-row class="my-2 px-2">
    <v-col class="px-2 py-1" cols="12" sm="4" md="6" lg="6">
      <v-text-field v-model="table.search.title" :label="$t('search')" hide-details variant="outlined" density="compact" append-inner-icon="fa-solid fa-search"></v-text-field>
    </v-col>
    <v-col class="px-2 py-1" cols="6" sm="4" md="3" lg="3">
      <v-select :label="$t('state')" v-model="table.search.state" :items="table.states" item-value="name_ar" item-title="name_ar" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details @update:modelValue="getCitys()">
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
      </v-select>
    </v-col>
    <v-col class="px-2 py-1" cols="6" sm="4" md="3" lg="3">
      <v-select :disabled="table.citys.length === 0" :label="$t('city')" v-model="table.search.city" :items="table.citys" item-value="name_ar" item-title="name_ar" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
      </v-select>
    </v-col>


    <v-col class="px-2 py-1" cols="6" sm="4" md="3" lg="3">
      <v-select :label="$t('purpose')" v-model="table.search.purpose" :items="table.purpose" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
        <template #selection="{ item }">{{ $t(item.title) }}</template>
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
      </v-select>
    </v-col>
    <v-col class="px-2 py-1" cols="6" sm="4" md="3" lg="3">
      <v-select :label="$t('type')" v-model="table.search.type" :items="table.types" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
        <template #selection="{ item }">{{ $t(item.title) }}</template>
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
      </v-select>
    </v-col>
    <v-col class="px-2 py-1" cols="6" sm="4" md="3" lg="3">
      <v-select :label="$t('agency_name')" v-model="table.search.agency_id" :items="table.agencys" item-value="id" item-title="name" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
      </v-select>
    </v-col>
    <v-col class="px-2 py-1" cols="6" sm="12" md="3" lg="3"><v-btn elevation="0" color="primary" block style="height: 40px;" @click="getData(1)">{{ $t('search') }}</v-btn></v-col>
  </v-row>
  <v-divider/>

  <v-data-table-server :headers="table.headers" :items="table.data" :items-length="table.total" hide-default-footer @update:options="options" sort-asc-icon="fa-solid fa-angle-up" sort-desc-icon="fa-solid fa-angle-down">

    <template v-slot:header.name="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.create_at="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.title="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.agency="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.purpose="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.type="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.state="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.city="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.bedrooms="{ column }"><span class="fa-solid fa-bed-front" style="font-size: 16px;"></span></template>
    <template v-slot:header.bathrooms="{ column }"><span class="fa-solid fa-shower" style="font-size: 16px;"></span></template>
    <template v-slot:header.garages="{ column }"><span class="fa-solid fa-warehouse" style="font-size: 16px;"></span></template>
    <template v-slot:header.area_m2="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.price="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.estate_status="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.status="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.action="{ column }">{{ $t(column.title) }}</template>

    <template v-slot:item.img="{ item }">
      <v-img v-if="!table.loading" :src="item.img !== undefined && item.img !== '' ? config.public.url_api+'/uploads/imgs/sm/'+item.img : '/imgs/agency.png'" width="56" :aspect-ratio="1/1" class="my-2" cover></v-img>
      <v-skeleton-loader v-else type="avatar" class="ma-3"></v-skeleton-loader>
    </template>
    <template v-slot:item.area_m2="{ item }">{{ item.area_m2 !== '' ? parseFloat(item.area_m2).toLocaleString() : '' }}</template>
    <template v-slot:item.price="{ item }">{{ item.price !== '' ? parseFloat(item.price).toLocaleString() : '' }}</template>
    <template v-slot:item.purpose="{ item }">
      <v-chip v-if="item.purpose !== ''" color="gray">{{ item.purpose !== '' ? $t(item.purpose):'' }}</v-chip>
    </template>
    <template v-slot:item.type="{ item }">
      <v-chip v-if="item.type !== ''" color="gray">{{ item.type !== '' ? $t(item.type):'' }}</v-chip>
    </template>
    <template v-slot:item.estate_status="{ item }">
      <v-chip v-if="item.estate_status !== ''" color="gray">{{ item.estate_status !== '' ? $t(item.estate_status):'' }}</v-chip>
    </template>
    <template v-slot:item.status="{ item }">
      <v-chip v-if="item.status !== ''" color="gray">{{ item.status !== '' ? $t(item.status):'' }}</v-chip>
    </template>
    <template v-slot:item.action="{ item }">
      <div class="d-flex" style="width: 70px">
        <v-btn v-if="false" class="mx-1 white_text" icon="fa-solid fa-eye" color="orange" size="x-small" :to="localPath('/client/'+item.id)"></v-btn>
        <v-btn class="mx-1" icon="fa-solid fa-pen" color="info" size="x-small" @click="dialog_edit(item)"></v-btn>
        <v-btn class="mx-1" icon="fa-solid fa-trash" color="red" size="x-small" @click="dialog_remove(item.id)"></v-btn>
      </div>
    </template>
  </v-data-table-server>


  <v-divider class="mb-2"/>
  <div class="d-flex mx-3 mx-sm-1">
    <div style="width: 60px;" class="me-2">
      <v-select :items="table.perPageItem" v-model.number="table.perPage" @update:modelValue="setperPage" hide-details density="compact" width="90" menu-icon="fa-solid fa-chevron-down"></v-select>
    </div>
    <v-spacer/>
    <span class="me-2 grey--text my-auto">{{ $t('page') }} {{ options.page }} {{ $t('of') }} {{ Math.ceil(table.pageCount) }}</span>
    <v-pagination :disabled="table.loading" v-model="options.page" :length="table.pageCount" :total-visible="0" style="width: 100px;" next-icon="fa-solid fa-angle-right" prev-icon="fa-solid fa-angle-left" @update:modelValue="getData()"></v-pagination>
  </div>

  <v-dialog v-model="table.dialog_add" width="500" :height="$vuetify.display.smAndDown ? '100%':''" persistent transition="dialog-bottom-transition">
    <v-card :height="$vuetify.display.smAndDown ? '100%':''">

      <div>
        <v-tabs v-model="table.tab" grow>
          <v-tab value="1">{{$t('general')}}</v-tab>
          <v-tab value="2">{{$t('details')}}</v-tab>
          <v-tab value="3">{{$t('images')}}</v-tab>
          <v-tab value="4">{{$t('location')}}</v-tab>
        </v-tabs>
        <v-divider/>
      </div>

      <v-tabs-window class="px-3 py-3" v-model="table.tab" :style="['overflow: auto; ',!$vuetify.display.smAndUp ? 'height: 100%;':'min-height: 200px;']">
        <v-tabs-window-item class="pt-3" value="1" eager>
          <v-row class="px-2">
            <v-col class="pa-1" cols="12" sm="12"><v-text-field v-model="table.item.title" label="العنوان *" variant="outlined" hide-details autofocus clearable density="compact" append-inner-icon="fa-solid fa-house"></v-text-field></v-col>
            <v-col class="pa-1" cols="12" sm="6"><v-text-field v-model="table.item.area_m2" label="المساحة" variant="outlined" hide-details clearable density="compact" append-inner-icon="fa-solid fa-expand" @keypress="isNumber($event)"></v-text-field></v-col>
            <v-col class="pa-1" cols="12" sm="6"><v-text-field v-model="table.item.price" label="السعر" variant="outlined" hide-details clearable density="compact" append-inner-icon="fa-solid fa-money-bill" @keypress="isNumber($event)"></v-text-field></v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('type')" v-model="table.item.type" :items="table.types" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #selection="{ item }">{{ $t(item.title) }}</template>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
              </v-select>
            </v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('purpose')" v-model="table.item.purpose" :items="table.purpose" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #selection="{ item }">{{ $t(item.title) }}</template>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
              </v-select>
            </v-col>
            <v-col class="pa-1" cols="12" sm="12">
              <client-only>
                <Editor v-model="table.item.description"/>
              </client-only>
            </v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('agency_name')" v-model="table.item.agency_id" :items="table.agencys" item-value="id" item-title="name" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
              </v-select>
            </v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('review')" v-model="table.item.admin_review" :items="table.admin_review" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #selection="{ item }">{{ $t(item.title) }}</template>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
              </v-select>
            </v-col>
          </v-row>
        </v-tabs-window-item>

        <v-tabs-window-item class="pt-3" value="2" eager>

          <v-row class="px-2">
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('state')" v-model="table.item.state" :items="table.states" item-value="name_ar" item-title="name_ar" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details @update:modelValue="getCitys(1)">
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
              </v-select>
            </v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :disabled="table.citys2.length === 0" :label="$t('city')" v-model="table.item.city" :items="table.citys2" item-value="name_ar" item-title="name_ar" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
              </v-select>
            </v-col>
            <v-col class="pa-1" cols="12" sm="12">
              <v-text-field v-model="table.item.address" :label="$t('address')" hide-details variant="outlined" density="compact" append-inner-icon="fa-solid fa-map"></v-text-field>
            </v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('bedrooms')" v-model="table.item.bedrooms" :items="table.numbers" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
              </v-select>
            </v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('bathrooms')" v-model="table.item.bathrooms" :items="table.numbers" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
              </v-select>
            </v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('garages')" v-model="table.item.garages" :items="table.numbers" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
              </v-select>
            </v-col>
            <v-col class="pa-1" cols="12" sm="6">
              <v-select :label="$t('estate_status')" v-model="table.item.estate_status" :items="table.estate_status" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
                <template #selection="{ item }">{{ $t(item.title) }}</template>
                <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
              </v-select>
            </v-col>
          </v-row>

        </v-tabs-window-item>

        <v-tabs-window-item value="3" eager>

          <input class="d-none" id="UploadImages2" type="file" accept="image/*" @change=uploadImage>
          <h4 class="font-weight-medium mb-3"><span class="fa-solid fa-image me-2"></span>{{$t('main_image')}}</h4>

          <v-hover v-slot="{ isHovering, props }">
            <v-card class="mb-4" outlined @click="popUpload(2)">
              <v-img class="align-center justify-center text-center" :src="table.item.img !== '' ? config.public.url_api+'/uploads/imgs/md/'+table.item.img : '/imgs/agency.png'" :aspect-ratio="4/3" cover v-bind="props">
                <v-fade-transition>
                  <v-icon v-if="isHovering" size="80" color="blue-lighten-4">fa-solid fa-plus</v-icon>
                </v-fade-transition>
              </v-img>
            </v-card>
          </v-hover>



          <v-divider class="mt-3"/>
          <input class="d-none" id="UploadImages" type="file" accept="image/*" multiple @change=uploadImage>
          <h4 class="d-flex font-weight-medium mt-3"><span class="fa-solid fa-images me-2 pt-1"></span>{{$t('other_images')}}</h4>

          <v-slide-group v-model="table.currentIndex" class="py-3" show-arrows next-icon="fa-solid fa-chevron-right" prev-icon="fa-solid fa-chevron-left">
            <v-slide-group-item v-for="(img, idx) in table.item.imgs" :key="idx" v-slot="{ isSelected, toggle }">
              <v-card style="background-color: white !important; border-color: gray !important;" class="text-center pt-2 me-2" width="80" height="70" variant="outlined" elevation="2">
                <v-hover v-slot="{ isHovering, props }">
                  <v-img class="align-center justify-center text-center" :src="img !== '' ? config.public.url_api+'/uploads/imgs/md/'+img : '/imgs/agency.png'" cover v-bind="props" @click="removeImg(idx)" style="background-color: white !important; border-color: gray !important;">
                    <v-fade-transition>
                      <v-icon v-if="isHovering" size="40" color="red-lighten-1">fa-solid fa-close</v-icon>
                    </v-fade-transition>
                  </v-img>
                </v-hover>
              </v-card>
            </v-slide-group-item>
            <v-slide-group-item v-slot="{ isSelected, toggle }">
              <v-card style="background-color: white !important; border-color: gray !important;" class="text-center pt-2" width="80" height="70" variant="outlined" elevation="2" @click="popUpload(1)">
                <v-icon size="48" color="black">fa-solid fa-plus</v-icon>
              </v-card>
            </v-slide-group-item>
          </v-slide-group>

          <v-divider class="mt-3"/>
          <h4 class="font-weight-medium my-3"><span class="fa-solid fa-image me-2"></span>{{$t('plan image')}}</h4>
          <v-hover v-slot="{ isHovering, props }">
            <v-card class="mb-4" outlined @click="popUpload(3)">
              <v-img class="align-center justify-center text-center" :src="table.item.plan_img !== '' ? config.public.url_api+'/uploads/imgs/md/'+table.item.plan_img : '/imgs/agency.png'" :aspect-ratio="4/3" cover v-bind="props">
                <v-fade-transition>
                  <v-icon v-if="isHovering" size="80" color="blue-lighten-4">fa-solid fa-plus</v-icon>
                </v-fade-transition>
              </v-img>
            </v-card>
          </v-hover>

        </v-tabs-window-item>
        <v-tabs-window-item value="4">
          <SelectArea class="mt-3" :marker="table.item.location" :zoom="mapDefault.zoom" :center="mapDefault.center" @result_polygon="mapZone" @result_marker="mapLocation" :options="1" style="height: 320px;"/>
        </v-tabs-window-item>
      </v-tabs-window>

      <v-divider/>
      <template v-slot:actions>
        <v-switch v-model="table.item.status" :label="table.item.status === 'active' ? $t('active') : $t('inactive')" hide-details inset color="primary" false-value="inactive" true-value="active" density="compact"></v-switch>
        <v-spacer/>
        <v-btn class="ms-auto" :text="$t('close')" @click="table.dialog_add = false"></v-btn>
        <v-btn v-if="!table.is_edit" class="ms-2" :text="$t('add')" @click="add()" elevation="0" color="success"></v-btn>
        <v-btn v-else class="ms-2" :text="$t('edit')" @click="edit()" elevation="0" color="primary"></v-btn>
      </template>
    </v-card>
  </v-dialog>




  <v-dialog v-model="table.dialog_remove" max-width="250">
    <v-container>
      <v-card class="pa-2">
        <v-card-text>{{$t('are_you_sure')}}</v-card-text>
        <v-row class="mt-1">
          <v-col cols="6">
            <v-btn block :text="$t('no')" @click="table.dialog_remove = false" elevation="0" color="red"></v-btn>
          </v-col>
          <v-col cols="6">
            <v-btn block :text="$t('yes')" @click="remove" elevation="0" color="success"></v-btn>
          </v-col>
        </v-row>
      </v-card>
    </v-container>
  </v-dialog>

</template>