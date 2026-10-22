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
    if (res === 1) {
      this.$router.push('/')
    } else if (res === 2) {
      //this.$router.push('/offline')
    } else {
      this.checkAuth = true
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
  <v-app theme="light">
    <v-row v-if="checkAuth" class="pa-0 ma-0">
      <v-col cols="12" sm="6" md="7" lg="7" xl="8" class="pa-0 d-none d-sm-block">
        <v-sheet
            style="height: 100%;background-image: url('/imgs/bg_login.svg');background-position: right;background-repeat: no-repeat;background-size: cover;"></v-sheet>
      </v-col>
      <v-col cols="12" sm="6" md="5" lg="5" xl="4" class="d-flex align-center">
        <v-container class="px-sm-4 px-md-10">
          <NuxtPage @snack="snack"/>
        </v-container>
      </v-col>
    </v-row>
    <v-container v-else>
      <div class="d-flex justify-center align-center" style="height: 90vh">
        <v-progress-circular indeterminate :size="80" :width="5"></v-progress-circular>
      </div>
    </v-container>
    <v-snackbar v-model="msg_show" :color="msg_color" :timeout="3000" location="end">{{ msg_text }}
      <template v-slot:actions="{ attrs }">
        <v-btn text v-bind="attrs" @click="msg_show = false">{{ $t('cancel') }}</v-btn>
      </template>
    </v-snackbar>
  </v-app>
</template>