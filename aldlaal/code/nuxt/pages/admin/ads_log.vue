<script setup lang="js">
const {t} = useLocale()
const localPath = useLocalePath()
const config = useRuntimeConfig()
useHead({title:t('ads_log')})
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
          {key: 'agency', sortable: false, title: 'agency name', width: 180, align: 'center'},
          {key: 'content', sortable: false, title: 'action', class: 'table-cs-name'},
          {key: 'create_at', sortable: false, title: 'date', width: 180, align: 'center'},
          {key: 'action', sortable: false, title: 'action', width: 80, align: 'center'},
        ],
        dialog_remove: false,
        item:{
          id:0,
        },
        search:{
          agency:null,
        },
        agencies:[],
      },
    }
  },
  async mounted() {
    await this.initTable()
    await this.getData()
    await this.getAgencys()
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
      const res = await useApi('/admin/agencys/agency_log', {page: page, per_page: this.table.perPage,id: this.table.search.agency});
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
    dialog_remove(id) {
      this.table.item.id = id
      this.table.dialog_remove = true
    },
    async remove() {
      await useApi('/admin/agencys/remove_agency_log', {id: this.table.item.id});
      this.snack('deleted_successfully', 'success')
      this.table.dialog_remove = false
      this.getData()
    },
    async getAgencys(){
      const res = await useApi('/admin/agencys/get_agencys', {});
      this.table.agencies = res.data
    },
  },
}
</script>
<template>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-clipboard-list me-3"></v-icon>{{ $t('ads_log') }} <v-chip class="ms-1 px-4" v-if="table.total !== 0">{{ table.total }}</v-chip></span>
    <v-spacer/>
    <div class="d-none d-md-flex mt-3 mt-md-0">
      <div :style="$vuetify.display.smAndDown ? 'width: 100%;':'width: 180px;'">
        <v-autocomplete class="mx-2" :label="$t('agencys')" v-model="table.search.agency" :items="table.agencies" item-value="id" item-title="name" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact">
          <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
        </v-autocomplete>
      </div>
    </div>
    <v-btn height="38" color="info" @click="getData()" :loading="loading">{{$t('search')}}</v-btn>
  </v-card-title>
  <div class="d-flex d-md-none my-3 mt-md-0">
    <div :style="$vuetify.display.smAndDown ? 'width: 100%;':'width: 180px;'">
      <v-autocomplete class="mx-2" :label="$t('agencys')" v-model="table.search.agency" :items="table.agencies" item-value="id" item-title="name" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact">
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
      </v-autocomplete>
    </div>
  </div>
  <v-divider/>


  <v-data-table-server :headers="table.headers" :items="table.data" :items-length="table.total" hide-default-footer @update:options="options" sort-asc-icon="fa-solid fa-angle-up" sort-desc-icon="fa-solid fa-angle-down">

    <template v-slot:header.agency="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.content="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.create_at="{ column }">{{ $t(column.title) }}</template>
    <template v-slot:header.action="{ column }">{{ $t(column.title) }}</template>

    <template v-slot:item.img="{ item }">
      <v-img v-if="!table.loading" :src="item.img !== undefined && item.img !== '' ? config.public.url_api+'/uploads/imgs/sm/'+item.img : '/imgs/log.webp'" width="56" :aspect-ratio="1/1" class="my-2" cover></v-img>
      <v-skeleton-loader v-else type="avatar" class="ma-3"></v-skeleton-loader>
    </template>
    <template v-slot:item.agency="{ item }">
      <v-chip v-if="item.agency !== ''" color="gray">{{ item.agency !== '' ? item.agency:'' }}</v-chip>
    </template>
    <template v-slot:item.create_at="{ item }">
      <v-chip v-if="item.create_at !== ''" color="gray">{{ item.create_at !== '' ? item.create_at:'' }}</v-chip>
    </template>
    <template v-slot:item.action="{ item }">
      <div class="d-flex" style="width: 70px">
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