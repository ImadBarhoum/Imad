<script setup lang="js">
const {t} = useLocale()
const config = useRuntimeConfig()
useHead({title:t('statistics')})
definePageMeta({
  layout:'agency'
})
</script>
<script lang="js">
export default {
  emits: ['snack'],
  data() {
    return {
      loading: false,
      statistics: [
        { title: 'ads_sale', icon: 'fa-solid fa-home', total: '0' },
        { title: 'ads_rent', icon: 'fa-solid fa-home', total: '0' },
        { title: 'ads_pending', icon: 'fa-solid fa-hourglass-half', total: '0' },
        { title: 'ads_rejected', icon: 'fa-solid fa-ban', total: '0' },
      ]
    }
  },
  async mounted() {
    await this.getStatistics()
  },
  methods: {
    snack(msg = '', color = '') {
      this.$emit('snack', msg, color)
    },
    async getStatistics() {
      const res = await useApi('/agency/settings/statistics', {});
      this.statistics[0].total = res.data.ads_sale
      this.statistics[1].total = res.data.ads_rent
      this.statistics[2].total = res.data.ads_pending
      this.statistics[3].total = res.data.ads_rejected
    },
  },
}
</script>
<template>
  <v-card-title class="d-flex">
    <span><v-icon class="fa-solid fa-chart-simple me-3"></v-icon>{{ $t('statistics') }}</span>
    <v-spacer/>
  </v-card-title>
  <v-divider/>

  <v-row class="my-3 mx-2">
    <v-col v-for="(item,idx) in statistics" :key="idx" cols="12" sm="6" md="4" lg="3">
      <v-card variant="outlined">
        <v-card-text class="d-flex">{{$t(item.title)}}<v-spacer/><v-icon>{{item.icon}}</v-icon></v-card-text>
        <v-divider/>
        <h1 class="text-center my-4">{{item.total}}</h1>
      </v-card>
    </v-col>
  </v-row>

</template>