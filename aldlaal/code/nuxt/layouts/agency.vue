<script setup lang="js">
usePanel()
</script>
<script lang="js">
export default {
  data() {
    return {
      checkAuth: false,
      msg_text: '',
      msg_color: '',
      msg_show: false,
    }
  },
  async mounted() {
    const res = await useAuth().check()
    if (res === 0) {
      this.$router.push('/login')
    } else if (res === 2) {
      //this.$router.push('/offline')
      this.$router.push('/')
    } else {
      if(usePanel().user.user_type === 'user'){
        this.checkAuth = true
      }else{
        this.$router.push('/')
      }
    }
  },
  methods: {
    snack(msg = '', color = '') {
      if (msg !== '' && color !== '') {
        this.msg_text = this.$t(msg)
        this.msg_color = color
        this.msg_show = true
      }
    }
  }
}
</script>

<template>
  <v-layout class="ar noselect" v-if="checkAuth" :dir="$vuetify.locale.current === 'ar' ? 'rtl':'ltr'"
            :style="$vuetify.theme.current.dark ? '':'background-color:#f5f5f5;'">
    <AgencyMenus/>
    <v-main style="min-height: 100vh;">
      <v-container fluid>
        <v-card class="pa-md-5 pb-10 pb-md-10" min-height="87vh" elevation="0">
          <NuxtPage @snack="snack"/>
        </v-card>
      </v-container>
    </v-main>
    <v-snackbar v-model="msg_show" :color="msg_color" :timeout="3000" location="end">{{ msg_text }}
      <template v-slot:actions="{ attrs }">
        <v-btn text v-bind="attrs" @click="msg_show = false">{{ $t('cancel') }}</v-btn>
      </template>
    </v-snackbar>
  </v-layout>
  <v-container v-else>
    <div class="d-flex justify-center align-center" style="height: 90vh">
      <v-progress-circular indeterminate :size="80" :width="5"></v-progress-circular>
    </div>
  </v-container>
</template>