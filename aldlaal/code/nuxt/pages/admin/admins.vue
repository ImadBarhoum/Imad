<script setup lang="js">
const {t} = useLocale()
useHead({title:t('admins')})
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
          {key: 'user', sortable: false, title: 'username',class:'table-cs-name'},
          {key: 'create_at', sortable: false, title: 'register date',width:120,align:'center'},
          {key: 'valid', sortable: false, title: 'active',width:120,align:'center'},
          {key: 'action', sortable: false, title: 'action',width:120,align:'center'},
        ],
        is_edit:false,
        dialog_add:false,
        dialog_remove:false,
        dialog_out:false,
        item:{
          id:0,
          user:'',
          pwd:'',
          valid:0
        }
      },
    }
  },
  async mounted() {
    if(this.$pinia.state.value.Panel.user.user !== 'admin'){this.$router.push('/404')}
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
      const res = await useApi('/admin/admins/get_page', {page:page,per_page:this.table.perPage});
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
      this.table.item.user = ''
      this.table.item.pwd = ''
      this.table.item.valid = 1
      this.table.dialog_add = true
    },
    dialog_edit(item){
      this.table.is_edit = true
      this.table.item.id = item.id
      this.table.item.user = item.user
      this.table.item.pwd = item.pwd
      this.table.item.valid = item.valid
      this.table.dialog_add = true
    },
    dialog_remove(id){
      this.table.item.id = id
      this.table.dialog_remove = true
    },
    async add_user(){
      if(this.table.item.user === '' || this.table.item.pwd === ''){
        this.snack(this.$t('fields_required'),'red')
      }else {
        await useApi('/admin/admins/add', {user: this.table.item.user, pwd: this.table.item.pwd, valid: this.table.item.valid});
        this.snack(this.$t('added_successfully'), 'success')
        this.table.dialog_add = false
        this.getData()
      }
    },
    async edit_user(){
      await useApi('/admin/admins/edit', {id:this.table.item.id,user:this.table.item.user,pwd:this.table.item.pwd,valid:this.table.item.valid});
      this.snack(this.$t('modified_successfully'),'success')
      this.table.dialog_add = false
      this.getData()
    },
    async remove_user(){
      await useApi('/admin/admins/remove', {id:this.table.item.id});
      this.snack(this.$t('deleted_successfully'),'success')
      this.table.dialog_remove = false
      this.getData()
    },
    async force_logout_all(){
      await useApi('/admin/admins/force_logout_admins', {id:this.table.item.id});
      this.snack(this.$t('logged_out_all'),'success')
      this.table.dialog_out = false
      await useAuth().logout()
      setTimeout(() => this.$router.push('/login'), 3000)
    }
  },
}
</script>
<template>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-user-tie me-3"></v-icon>{{$t('admins')}} <v-chip class="ms-1 px-4" v-if="table.total !== 0">{{table.total}}</v-chip></span>
    <v-spacer/>
    <v-btn class="mx-2" color="red" @click="table.dialog_out = true" :loading="loading">
      <span>{{ $t('logout') }}</span>
    </v-btn>
    <v-btn color="success" @click="dialog_add()" :loading="loading">{{$t('add')}}</v-btn>
  </v-card-title>
  <v-divider/>


  <v-data-table-server :headers="table.headers" :items="table.data" :items-length="table.total" hide-default-footer @update:options="options">


    <template v-slot:header.user="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.create_at="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.valid="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.action="{ column }">{{ $t(column.title) }}</template>


    <template v-slot:item.img="{ item }">
      <v-img v-if="!table.loading" :src="'/imgs/av_admin_small.webp'" width="56" :aspect-ratio="1/1" class="my-2" cover></v-img>
      <v-skeleton-loader v-else type="avatar" class="ma-3"></v-skeleton-loader>
    </template>
    <template v-slot:item.valid="{ item }">
      <v-chip v-if="item.valid == 1" color="success">{{ $t('yes') }}</v-chip>
      <v-chip v-else color="red">{{ $t('no') }}</v-chip>
    </template>
    <template v-slot:item.action="{ item }">
      <div class="d-flex" style="width: 70px">
        <v-btn class="mx-1" icon="fa-solid fa-pen" color="info" size="x-small" @click="dialog_edit(item)"></v-btn>
        <v-btn :disabled="item.user === 'admin'" class="mx-1" icon="fa-solid fa-trash" color="red" size="x-small" @click="dialog_remove(item.id)"></v-btn>
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




  <v-dialog v-model="table.dialog_add" max-width="320">
    <v-card class="pt-2">
      <v-card-text>
        <v-text-field :label="$t('user')" v-model="table.item.user" variant="outlined" :disabled="table.is_edit"/>
        <v-text-field :label="table.is_edit ? $t('new password') : $t('password')" v-model="table.item.pwd" variant="outlined"/>
      </v-card-text>
      <v-divider/>
      <div class="pa-2 d-flex justify-space-between">
        <v-switch v-model="table.item.valid" :label="$t('active')" hide-details inset color="primary" :false-value="0" :true-value="1" density="compact"></v-switch>
        <v-spacer/>
        <v-btn class="ms-1" :text="$t('close')" @click="table.dialog_add = false" elevation="0" color=""></v-btn>
        <v-btn v-if="!table.is_edit" class="ms-2" :text="$t('add')" @click="add_user()" elevation="0" color="success"></v-btn>
        <v-btn v-else class="ms-2" :text="$t('edit')" @click="edit_user()" elevation="0" color="primary"></v-btn>
      </div>
    </v-card>
  </v-dialog>

  <v-dialog v-model="table.dialog_remove" max-width="250">
    <v-container>
      <v-card class="pa-2">
        <v-card-text>{{ $t('are_you_sure') }}</v-card-text>
        <v-row class="mt-1">
          <v-col cols="6"><v-btn block :text="$t('no')" @click="table.dialog_remove = false" elevation="0" color="red"></v-btn></v-col>
          <v-col cols="6"><v-btn block :text="$t('yes')" @click="remove_user" elevation="0" color="success"></v-btn></v-col>
        </v-row>
      </v-card>
    </v-container>
  </v-dialog>

  <v-dialog v-model="table.dialog_out" max-width="320">
    <v-container>
      <v-card class="pa-2">
        <v-card-text>{{ $t('logout_all_admins') }}</v-card-text>
        <v-row class="mt-1">
          <v-col cols="6"><v-btn block :text="$t('no')" @click="table.dialog_out = false" elevation="0" color="red"></v-btn></v-col>
          <v-col cols="6"><v-btn block :text="$t('yes')" @click="force_logout_all" elevation="0" color="success"></v-btn></v-col>
        </v-row>
      </v-card>
    </v-container>
  </v-dialog>


</template>