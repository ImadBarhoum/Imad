<script setup lang="js">
const {t} = useLocale()
useHead({title: t('signin')})
</script>
<script lang="js">
definePageMeta({
  layout: 'auth',
})
export default {
  data() {
    return {
      msg_text: '',
      msg_color: '',
      msg_show: false,
      loading: false,

      user: '',
      pwd: '',
      pwd_visible: false,
    }
  },
  async mounted() {

  },
  methods: {
    async login() {
      this.loading = true
      if (this.user === '' || this.pwd === '') {
        this.msg_text = this.$t('fields are required')
        this.msg_color = 'red'
        this.msg_show = true
      } else {
        const res = await useAuth().login(this.user, this.pwd,'agency')
        if (res === 1) {
          this.$router.push('/agency')
        } else if (res === 0) {
          this.msg_text = this.$t('email or password is incorrect');
          this.msg_color = 'red';
          this.msg_show = true;
        } else {
          this.msg_text = this.$t('server offline');
          this.msg_color = 'red';
          this.msg_show = true;
        }
      }
      this.loading = false
    },
  }
}
</script>

<template>
  <div class="d-flex justify-center">
    <v-img :src="$vuetify.theme.current.dark ? $pinia.state.value.Global.logo.dark : $pinia.state.value.Global.logo.light" max-width="200"></v-img>
  </div>
  <h2 class="text-center mt-3 mb-6">{{ $t('signin') }}</h2>
  <v-text-field :label="$t('email')" v-model="user" variant="outlined" prepend-inner-icon="fa fa-solid fa-at" tile @keyup.enter="login"></v-text-field>
  <v-text-field :label="$t('password')" v-model="pwd" variant="outlined" tile :type="pwd_visible ? 'text' : 'password'" prepend-inner-icon="fa-solid fa-lock"
                :append-inner-icon="pwd_visible ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'" @click:append-inner="pwd_visible = !pwd_visible"
                @keyup.enter="login"></v-text-field>
  <v-btn class="white_text" block color="indigo" elevation="0" tile size="large" @click="login" :loading="loading">{{ $t('login') }}</v-btn>
  <div class="d-flex justify-space-between mt-3">
    <nuxt-link to="/reset">{{ $t('reset password') }}</nuxt-link>
    <nuxt-link to="/register">{{ $t('register') }}</nuxt-link>
  </div>
  <div style="height: 120px;"></div>

  <v-snackbar v-model="msg_show" :color="msg_color" :timeout="3000" location="end">{{ msg_text }}
    <template v-slot:actions="{ attrs }">
      <v-btn text v-bind="attrs" @click="msg_show = false">{{ $t('cancel') }}</v-btn>
    </template>
  </v-snackbar>
</template>