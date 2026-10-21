<script setup lang="js">
const {t} = useLocale()
const config = useRuntimeConfig()
useHead({title:t('ads')})
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
      options: {page:1},
      table: {
        total:1,
        loading:true,
        pageCount: 1,
        perPage: 6,
        perPageItem: [6, 8, 10, 20],
        data:[],
        headers: [
          {key: 'img', sortable: false, title: '',width:80,align:'center'},
          {key: 'slug', sortable: false, title: 'الإعلان',class:'table-cs-name'},
          //{key: 'type', sortable: false, title: 'نوعه',width:120,align:'center'},
          {key: 'valid', sortable: false, title: 'فعالة؟',width:120,align:'center'},
          {key: 'action', sortable: false, title: 'الإجراء',width:120,align:'center'},
        ],
        is_edit:false,
        dialog_add:false,
        dialog_remove:false,
        dialog_adsText:false,
        dialog_notification:false,
        ads_text:'',
        item:{
          id:0,
          img:'',
          slug:null,
          route:null,
          route_id:null,
          valid:0
        },
        slugs:[
          {'id':'main', 'name':'الرئيسية 16:9'},
        ],
        types:[
          {'id':'ads', 'name':'إعلان'},
          {'id':'link', 'name':'رابط'},
        ],
        type_data:[],
      },
    }
  },
  async mounted() {
    await this.initTable()
    await this.getData()
  },
  methods: {
    snack(msg='',color=''){this.$emit('snack',msg,color)},
    async initTable() {
      const perPage = localStorage.getItem('perPage')
      if (perPage != null) {
        this.table.perPage = parseInt(perPage)
      }
      this.table.loading = false
    },
    async getData(){
      this.table.loading = true
      const { sortBy, sortDesc, page, itemsPerPage } = this.options
      const res = await useApi('/admin/ads/get_page', {page:page,per_page:this.table.perPage});
      this.table.data = res.data.items
      this.table.total = res.data.total
      this.table.pageCount = Math.ceil(this.table.total/this.table.perPage)
      this.table.loading = false
    },
    setperPage(v) {
      this.table.perPage = v
      localStorage.setItem('perPage', v)
      this.options.page = 1
      this.getData()
    },
    dialog_add(){
      this.table.is_edit = false
      this.table.item.id = 0
      this.table.item.img = ''
      this.table.item.slug = 'main'
      this.table.item.route = null
      this.table.item.route_id = null
      this.table.item.valid = 1
      this.getSelType();
      this.table.dialog_add = true
    },
    dialog_edit(item){
      this.table.is_edit = true
      this.table.item.id = item.id
      this.table.item.img = item.img
      this.table.item.slug = item.slug
      this.table.item.route = item.route
      this.table.item.route_id = item.route_id
      this.table.item.valid = item.valid
      this.getSelType();
      this.table.dialog_add = true
    },
    dialog_remove(id){
      this.table.item.id = id
      this.table.dialog_remove = true
    },
    async add(){
      if(this.table.item.img != '' && this.table.item.slug != null){
        await useApi('/admin/ads/add', {slug: this.table.item.slug,route: this.table.item.route,route_id: this.table.item.route_id, img: this.table.item.img, valid: this.table.item.valid});
        this.snack('تم الإضافة بنجاح', 'success')
        this.table.dialog_add = false
        this.getData()
      }else{
        this.snack('بيانات الإعلان مطلوبة','red')
      }
    },
    async edit(){
      if(this.table.item.img != '' && this.table.item.slug != null){
        await useApi('/admin/ads/edit', {id: this.table.item.id, slug: this.table.item.slug, route: this.table.item.route,route_id: this.table.item.route_id, img: this.table.item.img, valid: this.table.item.valid});
        this.snack('تم التعديل بنجاح', 'success')
        this.table.dialog_add = false
        this.getData()
      }else{
        this.snack('بيانات الإعلان مطلوبة','red')
      }
    },
    async remove(){
      await useApi('/admin/ads/remove', {id:this.table.item.id});
      this.snack('تم الحذف بنجاح','success')
      this.table.dialog_remove = false
      this.getData()
    },
    async getSelType(s=false) {
      if(s){this.table.item.route_id = null}
      if(this.table.item.route !== undefined && this.table.item.route !== null){
        const res = await useApi('/admin/ads/get_sel_type', {route: this.table.item.route});
        this.table.type_data = res.data
      }
    },

    popUpload(){
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
          const res = await useApi('/img/save', { img_name: compressedImage });
          this.table.item.img = res.img_name;
          this.loading = false;
        };
      }
    },
    compressImage(imageDataUrl,quality=0.8) {
      return new Promise((resolve) => {
        if (imageDataUrl.startsWith('data:image/gif')) {
          return resolve(imageDataUrl);
        }

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
    <span><v-icon class="fa-solid fa-panorama me-3"></v-icon>{{$t('ads')}} <v-chip class="ms-1 px-4" v-if="table.total !== 0">{{table.total}}</v-chip></span>
    <v-spacer/>
    <v-btn color="success" @click="dialog_add()" :loading="loading"><v-icon>fa-solid fa-plus</v-icon></v-btn>
  </v-card-title>
  <v-divider/>


  <v-data-table-server :headers="table.headers" :items="table.data" :items-length="table.total" hide-default-footer @update:options="options">

    <template v-slot:item.img="{ item }">
      <v-img v-if="!table.loading" :src="item.img !== '' ? config.public.url_api+'/uploads/imgs/sm/'+item.img : '/imgs/category_small.webp'" width="56" :aspect-ratio="1/1" class="my-2" cover></v-img>
      <v-skeleton-loader v-else type="avatar" class="ma-3"></v-skeleton-loader>
    </template>
    <template v-slot:item.slug="{ item }">
      <v-chip color="gray">{{ table.slugs.find(({id}) => id === item.slug)?.name }}</v-chip>
    </template>
    <template v-slot:item.route="{ item }">
      <v-chip color="gray">{{ table.types.find(({id}) => id === item.route)?.name }}</v-chip>
    </template>
    <template v-slot:item.valid="{ item }">
      <v-chip v-if="item.valid == 1" color="success">نعم</v-chip>
      <v-chip v-else color="red">لا</v-chip>
    </template>
    <template v-slot:item.action="{ item }">
      <div class="d-flex" style="width: 70px">
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
    <span class="me-2 grey--text my-auto">{{$t('page')}} {{ options.page }} {{$t('of')}} {{ Math.ceil(table.pageCount) }}</span>
    <v-pagination :disabled="table.loading" v-model="options.page" :length="table.pageCount" :total-visible="0" style="width: 100px;" next-icon="fa-solid fa-angle-right" prev-icon="fa-solid fa-angle-left" @update:modelValue="getData()"></v-pagination>
  </div>



  <input class="d-none" id="UploadImages" type="file" accept="image/*" @change=uploadImage>
  <v-dialog v-model="table.dialog_add" max-width="450">
    <v-card class="pt-2">
      <v-card-text>
        <v-select label="الإعلان" v-model="table.item.slug" :items="table.slugs" item-value="id" item-title="name" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" @update:modelValue="">
          <template #item="{ item, props: { onClick } }">
            <v-list-item @click="onClick">{{ item.title }}</v-list-item>
          </template>
        </v-select>

        <v-row>
          <v-col cols="6">
            <v-select label="نوع الإعلان" v-model="table.item.route" :items="table.types" item-value="id" item-title="name" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" @update:modelValue="getSelType(true)">
              <template #item="{ item, props: { onClick } }">
                <v-list-item @click="onClick">{{ item.title }}</v-list-item>
              </template>
            </v-select>
          </v-col>
          <v-col cols="6">
            <v-autocomplete v-if="table.item.route == 'ads'" label="الإعلان" v-model="table.item.route_id" :items="table.type_data" item-value="id" item-title="name" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
              <template #item="{ item, props: { onClick } }">
                <v-list-item @click="onClick">{{ item.title }}</v-list-item>
              </template>
            </v-autocomplete>
            <v-text-field v-if="table.item.route == 'link'" label="الرابط" v-model="table.item.route_id" hide-details variant="outlined"></v-text-field>
          </v-col>
        </v-row>


        <v-hover v-slot="{ isHovering, props }">
          <v-card class="mb-4" outlined @click="popUpload()">
            <v-img class="align-center justify-center text-center" :src="table.item.img !== '' ? config.public.url_api+'/uploads/imgs/md/'+table.item.img : '/imgs/category_big.webp'" :aspect-ratio="1/1" cover v-bind="props">
              <v-fade-transition>
                <v-icon v-if="isHovering && !$vuetify.display.mobile" size="80" color="blue-lighten-4">fa-solid fa-plus</v-icon>
              </v-fade-transition>
            </v-img>
          </v-card>
        </v-hover>
      </v-card-text>
      <v-divider/>
      <div class="pa-2 d-flex justify-space-between">
        <v-switch v-model="table.item.valid" label="فعالة؟" hide-details inset color="primary" :false-value="0" :true-value="1" density="compact"></v-switch>
        <v-spacer/>
        <v-btn class="ms-1" :text="$t('close')" @click="table.dialog_add = false" elevation="0" color=""></v-btn>
        <v-btn v-if="!table.is_edit" class="ms-2" :text="$t('add')" @click="add()" elevation="0" color="success"></v-btn>
        <v-btn v-else class="ms-2" :text="$t('edit')" @click="edit()" elevation="0" color="primary"></v-btn>
      </div>
    </v-card>
  </v-dialog>

  <v-dialog v-model="table.dialog_remove" max-width="250">
    <v-container>
      <v-card class="pa-2">
        <v-card-text>هل أنت متأكد ؟</v-card-text>
        <v-row class="mt-1">
          <v-col cols="6"><v-btn block :text="$t('no')" @click="table.dialog_remove = false" elevation="0" color="red"></v-btn></v-col>
          <v-col cols="6"><v-btn block :text="$t('yes')" @click="remove" elevation="0" color="success"></v-btn></v-col>
        </v-row>
      </v-card>
    </v-container>
  </v-dialog>

</template>