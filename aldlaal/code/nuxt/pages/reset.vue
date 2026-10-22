<script setup lang="js">
const {t} = useLocale()
useHead({title: t('reset password')})
</script>
<script lang="js">
definePageMeta({
  layout: 'auth',
})
export default {
  emits: ['snack'],
  data() {
    return {
      loading: false,
      otp_timer: false,
      otp_timer_count: 60,
      otp_timer_id:null,
      pwd_visible: false,

      email: '',
      pwd: '',
      otp: '',
    }
  },
  async mounted() {

  },
  methods: {
    snack(msg = '', color = '') {
      this.$emit('snack', msg, color)
    },
    async reset_password(){
      this.loading = true
      if(this.email === '' || this.pwd === '' || this.otp === '') {
        this.snack('fields_required', 'red')
      }else{
        const res = await useApi('/reset_password', {email: this.email,pwd: this.pwd,otp: this.otp,role: 'agency'});
        if(res.status === 1){
          this.snack('pwd_changed_success', 'success')
          this.$router.push('/login')
        }else if(res.status === 2){
          this.snack('email_invalid', 'red')
        }else if(res.status === 3){
          this.snack('email_not_available', 'red')
        }else if(res.status === 4){
          this.snack(this.$t('password_less') + '8 ' + this.$t('characters'), 'red')
        }else if(res.status === 6){
          this.snack('otp_invalid', 'red')
        }
      }
      this.loading = false
    },
    async send_otp(){
      if(this.email !== ''){
        this.loading = true
        const res = await useApi('/send_email_otp', {email: this.email,type: 'reset',role: 'agency'});
        if(res.status === 1){
          this.snack('otp_sent', 'success')
          this.otp_timer = true
          this.otp_timer_id = setInterval(() => {
            this.otp_timer_count--;
            if (this.otp_timer_count === 0) {clearInterval(this.otp_timer_id);this.otp_timer = false;this.otp_timer_count = 60;}
          }, 1000);
        }else if(res.status === 2){
          this.snack('email_invalid', 'red')
        }else if(res.status === 3){
          this.snack('otp_timer', 'red')
        }else if(res.status === 4){
          this.snack('please_try_again_later', 'red')
        }else if(res.status === 5){
          this.snack('email_not_available', 'red')
        }
      }else{
        this.snack('email_required', 'red')
      }
      this.loading = false
    },
    numberFilterInput(event,inpt) {
      let value = event.target.value;
      value = value.replace(/\D/g, '');
      if(inpt === 1){
        this.phone = value;
      }else if(inpt === 2){
        this.otp = value;
      }
    }
  }
}
</script>

<template>
  <div class="d-flex justify-center">
    <v-img :src="$vuetify.theme.current.dark ? $pinia.state.value.Global.logo.dark : $pinia.state.value.Global.logo.light" max-width="200"></v-img>
  </div>
  <h2 class="mt-3 mb-6">{{ $t('reset password') }}</h2>
  <v-text-field :label="$t('email')" v-model="email" variant="outlined" prepend-inner-icon="fa fa-solid fa-at" tile></v-text-field>
  <v-text-field :label="$t('new_password')" v-model="pwd" variant="outlined" tile :type="pwd_visible ? 'text' : 'password'" prepend-inner-icon="fa-solid fa-lock"
                :append-inner-icon="pwd_visible ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'" @click:append-inner="pwd_visible = !pwd_visible"
  ></v-text-field>
  <div class="d-flex justify-space-between">
    <v-text-field :label="$t('otp')" v-model="otp" variant="outlined" prepend-inner-icon="fa fa-solid fa-envelope-open-text" tile @input="numberFilterInput($event,2)" maxlength="6"></v-text-field>
    <v-btn class="white_text" color="info" elevation="0" tile size="large" @click="send_otp" :disabled="otp_timer" :loading="loading" style="height: 56px;">{{ !otp_timer ? $t('send') : '('+ otp_timer_count +')' }}</v-btn>
  </div>
  <v-btn class="white_text" block color="indigo" elevation="0" tile size="large" @click="reset_password" :loading="loading">{{ $t('reset') }}</v-btn>
  <div class="d-flex justify-space-between mt-3">
    <nuxt-link to="/login">{{ $t('login') }}</nuxt-link>
  </div>
  <div style="height: 120px;"></div>

  <v-snackbar v-model="msg_show" :color="msg_color" :timeout="3000" location="end">{{ msg_text }}
    <template v-slot:actions="{ attrs }">
      <v-btn text v-bind="attrs" @click="msg_show = false">{{ $t('cancel') }}</v-btn>
    </template>
  </v-snackbar>
</template>