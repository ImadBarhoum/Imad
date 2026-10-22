<script setup lang="js">
const {t} = useLocale()
const localPath = useLocalePath()
const config = useRuntimeConfig()
useHead({title:t('reports')})
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
          {key: 'report_at', sortable: false, title: 'date', width: 140, align: ''},
          {key: 'title', sortable: false, title: 'title', width: 180, align: ''},
          {key: 'agency', sortable: false, title: 'agency_name', width: 130, align: ''},
          {key: 'state', sortable: false, title: 'state', width: 100, align: 'center'},
          {key: 'city', sortable: false, title: 'city', width: 100, align: 'center'},
          {key: 'report_type', sortable: false, title: 'type', width: 100, align: 'center'},
          {key: 'report_note', sortable: false, title: 'note',class:'table-cs-name'},
          {key: 'action', sortable: false, title: 'action', width: 120, align: 'center'},
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
          location:null,
          img: '',
          plan_img: '',
          imgs: [],
          estate_status: '',
          admin_review: '',
          status: 'active'
        },
        numbers:[0,1,2,3,4,5,6,7,8,9,10],
      },
    }
  },
  async mounted() {
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
      const res = await useApi('/admin/properties/get_reports', {page: page, per_page: this.table.perPage});
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
    dialog_show(item) {
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
      this.table.tab=null
      this.table.dialog_add = true
    },
    dialog_remove(id) {
      this.table.item.id = id
      this.table.dialog_remove = true
    },
    async remove() {
      await useApi('/admin/properties/remove_report', {id: this.table.item.id});
      this.snack('deleted_successfully', 'success')
      this.table.dialog_remove = false
      this.getData()
    },

    popUpload(id){
      let fileUpload
      if(id === 1){
        this.table.imgSel = 1
        fileUpload = document.getElementById('UploadImages')
      }else if(id === 2){
        this.table.imgSel = 2
        fileUpload = document.getElementById('UploadImages2')
      }else if(id === 3){
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
          }else if(this.table.imgSel === 3){
            this.table.item.plan_img = res.img_name
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
  },
}
</script>
<template>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-triangle-exclamation me-3"></v-icon>{{ $t('reports') }} <v-chip class="ms-1 px-4" v-if="table.total !== 0">{{ table.total }}</v-chip></span>
    <v-spacer/>
  </v-card-title>
  <v-divider/>

  <v-data-table-server :headers="table.headers" :items="table.data" :items-length="table.total" hide-default-footer @update:options="options" sort-asc-icon="fa-solid fa-angle-up" sort-desc-icon="fa-solid fa-angle-down">

    <template v-slot:header.name="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.report_at="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.title="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.agency="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.report_type="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.state="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.city="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.report_note="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.action="{ column }">{{ $t(column.title) }}</template>

    <template v-slot:item.img="{ item }">
      <v-img v-if="!table.loading" :src="item.img !== undefined && item.img !== '' ? config.public.url_api+'/uploads/imgs/sm/'+item.img : '/imgs/agency.png'" width="56" :aspect-ratio="1/1" class="my-2" cover></v-img>
      <v-skeleton-loader v-else type="avatar" class="ma-3"></v-skeleton-loader>
    </template>
    <template v-slot:item.report_type="{ item }">
      <v-chip v-if="item.report_type !== ''" color="gray">{{ item.report_type !== '' ? $t(item.report_type):'' }}</v-chip>
    </template>
    <template v-slot:item.action="{ item }">
      <div class="d-flex" style="width: 70px">
        <v-btn v-if="false" class="mx-1 white_text" icon="fa-solid fa-eye" color="orange" size="x-small" @click="dialog_show(item)"></v-btn>
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