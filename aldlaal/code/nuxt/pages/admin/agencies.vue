<script setup lang="js">
const {t} = useLocale()
const localPath = useLocalePath()
const config = useRuntimeConfig()
useHead({title:t('agencys')})
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
        pageCount: 1,
        perPage: 6,
        perPageItem: [6, 8, 10, 20],
        data: [],
        headers: [
          {key: 'img', sortable: false, title: '', width: 80, align: 'center'},
          {key: 'name', sortable: false, title: 'agency_name', class: 'table-cs-name'},
          {key: 'owner', sortable: false, title: 'agency_owner', class: 'table-cs-name'},
          {key: 'state', sortable: false, title: 'state', width: 180, align: 'center'},
          {key: 'city', sortable: false, title: 'city', width: 180, align: 'center'},
          {key: 'email', sortable: false, title: 'agency email', width: 180, align: 'center'},
          {key: 'phone', sortable: false, title: 'agency phone', width: 160, align: 'center'},
          {key: 'ads', sortable: false, title: 'ads', width: 70, align: 'center'},
          {key: 'reviews', sortable: false, title: 'reviews', width: 70, align: 'center'},
          {key: 'create_at', sortable: false, title: 'register date', width: 140, align: ''},
          {key: 'action', sortable: false, title: 'action', width: 135, align: 'center'},
        ],
        is_edit: false,
        dialog_add: false,
        dialog_remove: false,
        item: {
          id: 0,
          img: '',
          owner: '',
          name: '',
          description: '',
          phone: '',
          email: '',
          state: '',
          city: '',
          address: '',
          status: 'approved'
        },
        states:[],
        citys:[],
        search:{
          name:''
        }
      },
    }
  },
  async mounted() {
    await this.getStates()
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
    async getData() {
      this.table.loading = true
      const {sortBy, sortDesc, page, itemsPerPage} = this.options
      const res = await useApi('/admin/agencys/get_page', {page: page, per_page: this.table.perPage,name: this.table.search.name,status: 'approved'});
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
    dialog_edit(item) {
      this.table.is_edit = true
      this.table.item.id = item.id
      this.table.item.name = item.name
      this.table.item.phone = item.phone
      this.table.item.email = item.email
      this.table.item.description = item.description
      this.table.item.state = item.state
      this.table.item.city = item.city
      this.table.item.address = item.address
      this.table.item.img = item.img
      this.table.item.status = item.status
      this.getCitys();
      this.table.dialog_add = true
    },
    dialog_remove(id) {
      this.table.item.id = id
      this.table.dialog_remove = true
    },
    async edit() {
      if(this.table.item.name === ''){
        this.snack(this.$t('agency name') +' '+ this.$t('required'), 'red')
      }else{
        const res = await useApi('/admin/agencys/edit', {
          id: this.table.item.id, name: this.table.item.name,
          phone: this.table.item.phone, email: this.table.item.email, description: this.table.item.description,
          state: this.table.item.state, city: this.table.item.city, address: this.table.item.address,
          img: this.table.item.img,status: this.table.item.status
        });
        if(res.status === 1){
          this.snack('modified_successfully', 'success')
          this.getData()
        }
        this.table.dialog_add = false
      }
    },
    async remove() {
      await useApi('/admin/agencys/remove', {id: this.table.item.id});
      this.snack('deleted_successfully', 'success')
      this.table.dialog_remove = false
      this.getData()
    },
    async getStates(){
      const res = await useApi('/others/get_states', {});
      this.table.states = res.data
      this.getCitys();
    },
    async getCitys(){
      //this.table.item.city=null
      const res = await useApi('/others/get_citys', {state:this.table.item.state});
      this.table.citys = res.data
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
          this.table.item.img = res.img_name;
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
    <span><v-icon class="fa-solid fa-users me-3"></v-icon>{{ $t('agencys') }} <v-chip class="ms-1 px-4" v-if="table.total !== 0">{{ table.total }}</v-chip></span>
    <v-spacer/>
    <div class="d-none d-md-flex mt-3 mt-md-0">
      <div :style="$vuetify.display.smAndDown ? 'width: 100%;':'width: 180px;'">
        <v-text-field class="mx-2" :label="$t('agency name')" v-model="table.search.name" hide-details variant="outlined" density="compact" @keyup.enter="getData"></v-text-field>
      </div>
    </div>
    <v-btn height="38" color="info" @click="getData()" :loading="loading">{{$t('search')}}</v-btn>
  </v-card-title>
  <div class="d-flex d-md-none my-3 mt-md-0">
    <div :style="$vuetify.display.smAndDown ? 'width: 100%;':'width: 180px;'">
      <v-text-field class="mx-2" :label="$t('email')" v-model="table.search.name" hide-details variant="outlined" density="compact" @keyup.enter="getData"></v-text-field>
    </div>
  </div>
  <v-divider/>


  <v-data-table-server :headers="table.headers" :items="table.data" :items-length="table.total" hide-default-footer @update:options="options" sort-asc-icon="fa-solid fa-angle-up" sort-desc-icon="fa-solid fa-angle-down">

    <template v-slot:header.name="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.create_at="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.owner="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.description="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.state="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.city="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.email="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.phone="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.ads="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.reviews="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.action="{ column }">{{ $t(column.title) }}</template>

    <template v-slot:item.img="{ item }">
      <v-img v-if="!table.loading" :src="item.img !== undefined && item.img !== '' ? config.public.url_api+'/uploads/imgs/sm/'+item.img : '/imgs/agency.png'" width="56" :aspect-ratio="1/1" class="my-2" cover></v-img>
      <v-skeleton-loader v-else type="avatar" class="ma-3"></v-skeleton-loader>
    </template>
    <template v-slot:item.name="{ item }">
      <v-chip v-if="item.name !== ''" color="gray">{{ item.name !== '' ? item.name:'' }}</v-chip>
    </template>
    <template v-slot:item.owner="{ item }">
      <v-chip v-if="item.owner !== ''" color="gray">{{ item.owner !== '' ? item.owner:'' }}</v-chip>
    </template>
    <template v-slot:item.state="{ item }">
      <v-chip v-if="item.state !== ''" color="gray">{{ item.state !== '' ? item.state:'' }}</v-chip>
    </template>
    <template v-slot:item.city="{ item }">
      <v-chip v-if="item.city !== ''" color="gray">{{ item.city !== '' ? item.city:'' }}</v-chip>
    </template>
    <template v-slot:item.phone="{ item }">
      <v-chip v-if="item.phone !== ''" color="gray">{{ item.phone !== '' ? item.phone:'' }}</v-chip>
    </template>
    <template v-slot:item.email="{ item }">
      <v-chip v-if="item.email !== ''" color="gray">{{ item.email !== '' ? item.email:'' }}</v-chip>
    </template>
    <template v-slot:item.ads="{ item }">
      <v-chip v-if="item.ads !== ''" color="gray">{{ item.ads !== '' ? item.ads:'' }}</v-chip>
    </template>
    <template v-slot:item.reviews="{ item }">
      <v-chip v-if="item.reviews !== ''" color="green">{{item.rate}} ({{item.reviews}})</v-chip>
    </template>
    <template v-slot:item.action="{ item }">
      <div class="d-flex" style="width: 70px">
        <v-btn v-if="false" class="mx-1 white_text" icon="fa-solid fa-eye" color="orange" size="x-small" :to="localPath('/client/'+item.id)"></v-btn>
        <v-btn class="mx-1" icon="fa-solid fa-pen" color="info" size="x-small" @click="dialog_edit(item)"></v-btn>
        <v-btn v-if="false" class="mx-1" icon="fa-solid fa-trash" color="red" size="x-small" @click="dialog_remove(item.id)"></v-btn>
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


  <input class="d-none" id="UploadImages" type="file" accept="image/*" @change=uploadImage>
  <v-dialog v-model="table.dialog_add" max-width="650">
    <v-card class="pt-2">
      <v-card-text>
        <v-row>
          <v-col cols="12" sm="6">
            <v-text-field :label="$t('agency name')" v-model="table.item.name" variant="outlined"/>
            <v-text-field :label="$t('agency phone')" v-model="table.item.phone" placeholder="" variant="outlined"/>
            <v-text-field :label="$t('agency email')" v-model="table.item.email" variant="outlined"/>
            <v-textarea rows="2" :label="$t('description')" v-model="table.item.description" variant="outlined"></v-textarea>
            <v-autocomplete :label="$t('state')" v-model="table.item.state" :items="table.states" item-value="name_ar" item-title="name_ar" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" @update:modelValue="getCitys()">
              <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
            </v-autocomplete>
            <v-autocomplete :disabled="table.item.state === null || table.states.length === 0" :label="$t('city')" v-model="table.item.city" :items="table.citys" item-value="name_ar" item-title="name_ar" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
              <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
            </v-autocomplete>
          </v-col>

          <v-col cols="12" sm="6">
            <v-text-field :label="$t('address')" v-model="table.item.address" variant="outlined"/>
            <v-select :label="$t('status')" v-model="table.item.status" :items="[{title:'pending',value:'pending'},{title:'approved',value:'approved'},{title:'rejected',value:'rejected'},]" item-value="value" item-title="title" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
              <template #selection="{ item }">{{ $t(item.title) }}</template>
              <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{$t(item.title)}}</v-list-item></template>
            </v-select>
            <v-hover v-slot="{ isHovering, props }">
              <v-card class="mb-4" outlined @click="popUpload()">
                <v-img class="align-center justify-center text-center" :src="table.item.img !== '' ? config.public.url_api+'/uploads/imgs/md/'+table.item.img : '/imgs/agency.png'" :aspect-ratio="1/1" cover v-bind="props">
                  <v-fade-transition>
                    <v-icon v-if="isHovering && !$vuetify.display.mobile" size="80" color="blue-lighten-4">fa-solid fa-plus</v-icon>
                  </v-fade-transition>
                </v-img>
              </v-card>
            </v-hover>
          </v-col>
        </v-row>




      </v-card-text>
      <v-divider/>
      <div class="pa-2 d-flex justify-space-between">
        <v-spacer/>
        <v-btn class="ms-1" :text="$t('close')" @click="table.dialog_add = false" elevation="0" color=""></v-btn>
        <v-btn class="ms-2" :text="$t('edit')" @click="edit()" elevation="0" color="primary"></v-btn>
      </div>
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