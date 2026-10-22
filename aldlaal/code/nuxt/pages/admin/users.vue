<script setup lang="js">
const {t} = useLocale()
const localPath = useLocalePath()
const config = useRuntimeConfig()
useHead({title:t('users')})
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
          {key: 'name', sortable: false, title: 'fullname', class: 'table-cs-name'},
          {key: 'state', sortable: false, title: 'state', width: 140, align: 'center'},
          {key: 'city', sortable: false, title: 'city', width: 140, align: 'center'},
          {key: 'email', sortable: false, title: 'email', width: 160, align: 'center'},
          {key: 'phone', sortable: false, title: 'phone', width: 160, align: 'center'},
          {key: 'verify', sortable: false, title: 'verify', width: 70, align: 'center'},
          {key: 'status', sortable: false, title: 'active', width: 70, align: 'center'},
          {key: 'create_at', sortable: false, title: 'register date', width: 140, align: ''},
          {key: 'action', sortable: false, title: 'action', width: 135, align: 'center'},
        ],
        is_edit: false,
        dialog_show: false,
        dialog_add: false,
        dialog_remove: false,
        item: {
          id: 0,
          img: '',
          name: '',
          phone: '',
          email: '',
          state: '',
          city: '',
          verify: 'no',
          status: 'active',
          docs : [],
          doc_id:'',
          doc_img:'',
        },
        states:[],
        citys:[],
        search:{
          email:''
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
      const res = await useApi('/admin/users/get_page', {page: page, per_page: this.table.perPage,email: this.table.search.email});
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
      this.table.item.img = item.img
      this.table.item.name = item.name
      this.table.item.phone = item.phone
      this.table.item.email = item.email
      this.table.item.state = item.state
      this.table.item.city = item.city
      this.table.item.verify = item.verify
      this.table.item.status = item.status
      this.table.item.docs = item.docs
      this.table.tab = 0
      this.table.dialog_show = true
    },
    dialog_edit(item) {
      this.table.is_edit = true
      this.table.item.id = item.id
      this.table.item.name = item.name
      this.table.item.phone = item.phone
      this.table.item.email = item.email
      this.table.item.state = item.state
      this.table.item.city = item.city
      this.table.item.status = item.status
      this.table.item.verify = item.verify
      this.getCitys();
      this.table.dialog_add = true
    },
    dialog_remove(id) {
      this.table.item.id = id
      this.table.dialog_remove = true
    },
    async edit() {
      if(this.table.item.name === ''){
        this.snack(this.$t('fullname') +' '+ this.$t('required'), 'red')
      }else if(this.table.item.email === ''){
        this.snack(this.$t('email') +' '+ this.$t('required'), 'red')
      }else{
        const res = await useApi('/admin/users/edit', {id: this.table.item.id, name: this.table.item.name, phone: this.table.item.phone, email: this.table.item.email, state: this.table.item.state, city: this.table.item.city, status: this.table.item.status});
        if(res.status === 1){
          this.snack('modified_successfully', 'success')
          this.table.dialog_add = false
          this.getData()
        }else if(res.status === 2){
          this.snack('email_registered2another', 'red')
        }else if(res.status === 3){
          this.snack('email_invalid', 'red')
        }
      }
    },
    async remove() {
      await useApi('/admin/users/remove', {id: this.table.item.id});
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
      this.table.item.city=null
      const res = await useApi('/others/get_citys', {state:this.table.item.state});
      this.table.citys = res.data
    },
    async idVerify(typee,id){
      var res = await useApi('/admin/users/set_doc_status', {id: id,type: typee});
      if(res.status === 1){
        await this.getData()
        this.table.item.verify = res.data.activated !== '' ? res.data.activated : this.table.item.verify
        this.table.item.docs = res.data.docs
        this.snack('تم التعديل بنجاح', 'success')
      }
      this.table.dialog_doc_img = false
    },
    showDocDiaglog(id,img){
      this.table.item.doc_id = id
      this.table.item.doc_img = img
      this.table.dialog_doc_img = true
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
    <span><v-icon class="fa-solid fa-users me-3"></v-icon>{{ $t('users') }} <v-chip class="ms-1 px-4" v-if="table.total !== 0">{{ table.total }}</v-chip></span>
    <v-spacer/>
    <div class="d-none d-md-flex mt-3 mt-md-0">
      <div :style="$vuetify.display.smAndDown ? 'width: 100%;':'width: 180px;'">
        <v-text-field class="mx-2" :label="$t('email')" v-model="table.search.email" hide-details variant="outlined" density="compact" @keyup.enter="getData"></v-text-field>
      </div>
    </div>
    <v-btn height="38" color="info" @click="getData()" :loading="loading">{{$t('search')}}</v-btn>
  </v-card-title>
  <div class="d-flex d-md-none my-3 mt-md-0">
    <div :style="$vuetify.display.smAndDown ? 'width: 100%;':'width: 180px;'">
      <v-text-field class="mx-2" :label="$t('email')" v-model="table.search.email" hide-details variant="outlined" density="compact" @keyup.enter="getData"></v-text-field>
    </div>
  </div>
  <v-divider/>


  <v-data-table-server :headers="table.headers" :items="table.data" :items-length="table.total" hide-default-footer @update:options="options" sort-asc-icon="fa-solid fa-angle-up" sort-desc-icon="fa-solid fa-angle-down">

    <template v-slot:header.name="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.create_at="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.state="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.city="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.email="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.phone="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.verify="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.status="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.action="{ column }">{{ $t(column.title) }}</template>

    <template v-slot:item.img="{ item }">
      <v-img v-if="!table.loading" :src="item.img !== undefined && item.img !== '' ? config.public.url_api+'/uploads/imgs/sm/'+item.img : '/imgs/av_client_small.webp'" width="56" :aspect-ratio="1/1" class="my-2" cover></v-img>
      <v-skeleton-loader v-else type="avatar" class="ma-3"></v-skeleton-loader>
    </template>
    <template v-slot:item.name="{ item }">
      <v-chip v-if="item.name !== ''" color="gray">{{ item.name !== '' ? item.name:'' }}</v-chip>
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
    <template v-slot:item.verify="{ item }">
      <v-chip v-if="item.verify == 'yes'" color="success">{{$t('yes')}}</v-chip>
      <v-chip v-else color="red">{{$t('no')}}</v-chip>
    </template>
    <template v-slot:item.status="{ item }">
      <v-chip v-if="item.status == 'active'" color="success">{{$t('yes')}}</v-chip>
      <v-chip v-else color="red">{{$t('no')}}</v-chip>
    </template>
    <template v-slot:item.action="{ item }">
      <div class="d-flex" style="width: 70px">
        <v-btn class="mx-1 white_text" icon="fa-solid fa-eye" color="orange" size="x-small" @click="dialog_show(item)"></v-btn>
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

  <v-dialog v-model="table.dialog_show" max-width="600">
    <v-card :height="$vuetify.display.smAndDown ? '100%':''">

      <div>
        <v-tabs v-model="table.tab" bg-color="info" grow>
          <v-tab value="1">بيانات عامة</v-tab>
          <v-tab value="2">إثبات الهوية</v-tab>
        </v-tabs>
        <v-divider/>
      </div>

      <v-tabs-window v-model="table.tab" :style="['overflow: auto; ',!$vuetify.display.smAndUp ? 'height: 100%;':'']">
        <v-tabs-window-item value="1">
          <v-table>
            <tbody>
            <tr><td>الإسم</td><td><v-chip color="gray">{{ table.item.name }}</v-chip></td></tr>
            <tr><td>رقم الهاتف</td><td><v-chip color="gray">{{ table.item.phone }}</v-chip></td></tr>
            <tr><td>الإيميل</td><td><v-chip color="gray">{{ table.item.email }}</v-chip></td></tr>
            <tr><td>المحافظة</td><td><v-chip color="gray">{{ table.item.state }}</v-chip></td></tr>
            <tr><td>المدينة</td><td><v-chip color="gray">{{ table.item.city }}</v-chip></td></tr>
            <tr><td>موثق؟</td><td><v-chip v-if="table.item.verify == 'yes'" color="success">نعم</v-chip><v-chip v-else color="red">لا</v-chip></td></tr>
            <tr><td>فعال؟</td><td><v-chip v-if="table.item.status == 'active'" color="success">نعم</v-chip><v-chip v-else color="red">لا</v-chip></td></tr>
            </tbody>
          </v-table>
        </v-tabs-window-item>
        <v-tabs-window-item value="2">
          <div class="mt-2 px-2" style="min-height:400px; width:100%">
            <v-table>
              <tbody>
              <tr>
                <td><h3>الحالة : <v-chip :color="table.item.verify === 'yes' ? 'success' : 'red'">{{ table.item.verify === 'yes' ? 'موثق':'غير موثق'}}</v-chip></h3></td>
                <td></td>
                <td class="text-left">
                  <v-btn v-if="table.item.verify === 'no'" color="success" @click="idVerify(1,table.item.id)">توثيق الأن</v-btn>
                  <v-btn v-else-if="table.item.verify === 'yes'" color="red" @click="idVerify(0,table.item.id)">إزالة التوثيق</v-btn>
                </td>
              </tr>
              <tr v-for="(item,idx) in table.item.docs" :key="idx">
                <td>
                  <v-chip>{{item.doc_type}}</v-chip></td>
                <td>
                  <v-chip v-if="item.active === 0" color="red">مرفوضة</v-chip>
                  <v-chip v-else-if="item.active === 1" color="success">مقبول</v-chip>
                  <v-chip v-else-if="item.active === 2" color="orange">قيد الإنتضار</v-chip>
                </td>
                <td class="text-left">
                  <v-btn class="mx-1" icon="fa-solid fa-eye" color="info" size="x-small" @click="showDocDiaglog(item.id,item.img)"><v-icon></v-icon>
                    <v-tooltip text="عرض" activator="parent" location="bottom"></v-tooltip>
                  </v-btn>
                </td>
              </tr>
              </tbody>
            </v-table>
            <div class="mt-3" v-if="table.item.docs.length === 0">
              <center><v-img src="/imgs/id_verify_big.webp" width="200"/></center>
              <h3 class="text-center">لا يوجد أي وثائق</h3>
            </div>
          </div>
        </v-tabs-window-item>
      </v-tabs-window>

      <v-divider/>
      <div class="pa-2 d-flex justify-space-between">
        <v-spacer/>
        <v-btn class="ms-1" :text="$t('close')" @click="table.dialog_show = false" elevation="0" color=""></v-btn>
      </div>
    </v-card>
  </v-dialog>

  <v-dialog v-model="table.dialog_doc_img" max-width="600">
    <v-container>
      <v-card class="pa-2">
        <v-img :src="table.item.doc_img !== '' ? config.public.url_api+'/uploads/imgs/md/'+table.item.doc_img : '/imgs/id_verify_big.webp'" :aspect-ratio="4/3"/>
        <v-divider/>
        <div class="pa-2 d-flex justify-space-between">
          <v-btn class="ms-1" :text="$t('close')" @click="table.dialog_doc_img = false" elevation="0" color=""></v-btn>
          <v-spacer/>
          <v-btn class="mx-1" icon="fa-solid fa-check" color="success" size="x-small" @click="idVerify(2,table.item.doc_id)"><v-icon></v-icon>
            <v-tooltip text="قبول" activator="parent" location="bottom"></v-tooltip>
          </v-btn>
          <v-btn class="mx-1" icon="fa-solid fa-ban" color="red" size="x-small" @click="idVerify(3,table.item.doc_id)"><v-icon></v-icon>
            <v-tooltip text="رفض" activator="parent" location="bottom"></v-tooltip>
          </v-btn>
          <v-btn class="mx-1" icon="fa-solid fa-trash white_text" color="orange" size="x-small" @click="idVerify(4,table.item.doc_id)"><v-icon></v-icon>
            <v-tooltip text="حذف" activator="parent" location="bottom"></v-tooltip>
          </v-btn>
        </div>
      </v-card>
    </v-container>
  </v-dialog>

  <input class="d-none" id="UploadImages" type="file" accept="image/*" @change=uploadImage>
  <v-dialog v-model="table.dialog_add" max-width="320">
    <v-card class="pt-2">
      <v-card-text>
        <v-text-field :label="$t('fullname')" v-model="table.item.name" variant="outlined"/>
        <v-text-field :label="$t('phone')" v-model="table.item.phone" placeholder="" variant="outlined"/>
        <v-text-field :label="$t('email')" v-model="table.item.email" variant="outlined"/>
        <v-autocomplete :label="$t('state')" v-model="table.item.state" :items="table.states" item-value="name_ar" item-title="name_ar" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" @update:modelValue="getCitys()">
          <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
        </v-autocomplete>
        <v-autocomplete :disabled="table.item.state === null || table.states.length === 0" :label="$t('city')" v-model="table.item.city" :items="table.citys" item-value="name_ar" item-title="name_ar" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
          <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
        </v-autocomplete>
        <v-hover v-slot="{ isHovering, props }" v-if="false">
          <v-card class="mb-4" outlined @click="popUpload()">
            <v-img class="align-center justify-center text-center" :src="table.item.img !== '' ? config.public.url_api+'/uploads/imgs/md/'+table.item.img : '/imgs/av_client_big.webp'" :aspect-ratio="1/1" cover v-bind="props">
              <v-fade-transition>
                <v-icon v-if="isHovering && !$vuetify.display.mobile" size="80" color="blue-lighten-4">fa-solid fa-plus</v-icon>
              </v-fade-transition>
            </v-img>
          </v-card>
        </v-hover>
      </v-card-text>
      <v-divider/>
      <div class="pa-2 d-flex justify-space-between">
        <v-switch v-model="table.item.status" :label="$t('active')" hide-details inset color="primary" false-value="inactive" true-value="active" density="compact"></v-switch>
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