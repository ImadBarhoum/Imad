<script setup lang="js">
const {t} = useLocale()
const mapDefault = usePanel().map
const config = useRuntimeConfig()
useHead({title:t('map')})
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
      ads: [],
      state:null,
      city:null,
      states:[],
      citys:[],
      // CONFIG FOR MAP
      url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      center: usePanel().map.center,
      mapInstance: null,
    }
  },
  async mounted() {
    await this.getStates()
    await this.getAds()
  },
  methods: {
    snack(msg='',color=''){this.$emit('snack',msg,color)},
    async getAds() {
      const res = await useApi('/admin/properties/get_map', {state: this.state,city:this.city});
      this.ads = res.data
    },
    async getStates(){
      const res = await useApi('/others/get_states', {});
      this.states = res.data
    },
    async getCitys(){
      this.city=null
      const res = await useApi('/others/get_citys', {state:this.state});
      this.citys = res.data
    },
    onMapReady(leafletMap) {
      this.mapInstance = leafletMap
      this.mapInstance.setView(this.center, usePanel().map.zoom)
    },
  },
  watch: {
    center(newCenter) {
      if (this.mapInstance) {
        this.mapInstance.setView(newCenter, this.mapInstance.getZoom())
      }
    }
  }
}
</script>
<template>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-map-location me-3"></v-icon>{{$t('map')}}</span>
    <v-spacer/>
    <div style="width: 160px;">
      <v-select :label="$t('state')" v-model="state" :items="states" item-value="name_ar" item-title="name_ar" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details @update:modelValue="getCitys()">
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
      </v-select>
    </div>
    <div class="mx-2" style="width: 160px;">
      <v-select :disabled="citys.length === 0" :label="$t('city')" v-model="city" :items="citys" item-value="name_ar" item-title="name_ar" clearable clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details>
        <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
      </v-select>
    </div>
    <div style="width: 50px;'">
      <v-btn elevation="0" color="info" variant="flat" @click="getAds()"><span class="fa-solid fa-search"></span></v-btn>
    </div>
  </v-card-title>
  <v-divider/>

  <div class="mt-2" style="height:75vh; width:100%">
    <LMap ref="map" :zoom="mapDefault.zoom" :center="mapDefault.center" :use-global-leaflet="false" :options="{ attributionControl: false }" @ready="onMapReady">
      <LTileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"/>
      <div v-if="ads.length !== 0">
        <div v-for="(item,idx) in ads" :key="idx">
          <div v-if="item.location.hasOwnProperty('lat')">
            <LMarker :lat-lng="[item.location.lat,item.location.lng]">
              <LIcon icon-url="/imgs/marker/marker-icon-green.png" icon-size="24"/>
              <LPopup>
                <div>
                  <center><v-img :src="item.img !== '' ? config.public.url_api+'/uploads/imgs/md/'+item.img : '/imgs/agency.png'" style="object-fit: cover;min-width: 200px;" :aspect-ratio="4/3"></v-img></center>
                </div>
                <p class="text-center ar ma-0 mt-1" dir="rtl">{{ item.title }}</p>
                <v-btn v-if="false" class="ar" elevation="0" color="info" rounded variant="outlined" size="small" block>تفاصيل</v-btn>
              </LPopup>
            </LMarker>
          </div>
        </div>
      </div>
    </LMap>
  </div>

</template>