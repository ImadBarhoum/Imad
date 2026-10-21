<script setup lang="js">
const {t} = useLocale()
useHead({title: t('register')})
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
      states:[],
      citys:[],

      otp: '',
      email: '',
      pwd: '',
      name: '',
      phone: '',
      state: null,
      city: null,

    }
  },
  async mounted() {
    await this.getStates()
  },
  methods: {
    snack(msg = '', color = '') {
      this.$emit('snack', msg, color)
    },
    async register() {
      this.loading = true
      if(this.name === '' || this.phone === '' || this.city === null || this.state === null || this.email === '' || this.pwd === '' || this.otp === '') {
        this.snack('fields_required', 'red')
      }else{
        const res = await useApi('/register', {role: 'agency', name: this.name, phone: this.phone, city: this.city, state: this.state, email: this.email, pwd: this.pwd, otp: this.otp});
        if(res.status === 1){
          this.snack('register_successfully', 'success')
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
        this.otp_timer = true
        this.otp_timer_id = setInterval(() => {
          this.otp_timer_count--;
          if (this.otp_timer_count === 0) {clearInterval(this.otp_timer_id);this.otp_timer = false;this.otp_timer_count = 60;}
        }, 1000);
        const res = await useApi('/send_email_otp', {email: this.email,type: 'register',role: 'agency'});
        if(res.status === 1){
          this.snack('otp_sent', 'success')
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
  <h2 class="mt-3 mb-6">{{ $t('register') }}</h2>
  <v-text-field :label="$t('fullname')" v-model="name" variant="outlined" prepend-inner-icon="fa fa-solid fa-user" tile></v-text-field>
  <v-text-field :label="$t('phone')" v-model="phone" variant="outlined" prepend-inner-icon="fa fa-solid fa-phone" tile @input="numberFilterInput($event,1)" maxlength="12"></v-text-field>
  <v-autocomplete :label="$t('state')" v-model="state" :items="states" item-value="name_ar" item-title="name_ar" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" @update:modelValue="getCitys()">
    <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
  </v-autocomplete>
  <v-autocomplete :disabled="state === null || states.length === 0" :label="$t('city')" v-model="city" :items="citys" item-value="name_ar" item-title="name_ar" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined">
    <template #item="{ item, props: { onClick } }" ><v-list-item @click="onClick">{{item.title}}</v-list-item></template>
  </v-autocomplete>
  <v-divider class="mb-4"/>
  <v-text-field :label="$t('email')" v-model="email" variant="outlined" prepend-inner-icon="fa fa-solid fa-at" tile></v-text-field>
  <v-text-field :label="$t('password')" v-model="pwd" variant="outlined" tile :type="pwd_visible ? 'text' : 'password'" prepend-inner-icon="fa-solid fa-lock"
                :append-inner-icon="pwd_visible ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'" @click:append-inner="pwd_visible = !pwd_visible"
               ></v-text-field>
  <div class="d-flex justify-space-between">
    <v-text-field :label="$t('otp')" v-model="otp" variant="outlined" prepend-inner-icon="fa fa-solid fa-envelope-open-text" tile @input="numberFilterInput($event,2)" maxlength="6"></v-text-field>
    <v-btn class="white_text" color="info" elevation="0" tile size="large" @click="send_otp" :disabled="otp_timer" :loading="loading" style="height: 56px;">{{ !otp_timer ? $t('send') : '('+ otp_timer_count +')' }}</v-btn>
  </div>
  
  <v-btn class="white_text" block color="indigo" elevation="0" tile size="large" @click="register" :loading="loading">{{ $t('register') }}</v-btn>
  <div class="d-flex justify-space-between my-3">
    <nuxt-link to="/login">{{ $t('login') }}</nuxt-link>
  </div>

  <v-snackbar v-model="msg_show" :color="msg_color" :timeout="3000" location="end">{{ msg_text }}
    <template v-slot:actions="{ attrs }">
      <v-btn text v-bind="attrs" @click="msg_show = false">{{ $t('cancel') }}</v-btn>
    </template>
  </v-snackbar>
</template>