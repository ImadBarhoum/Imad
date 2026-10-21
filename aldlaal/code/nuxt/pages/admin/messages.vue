<script setup lang="js">
const router = useRouter()
const localPath = useLocalePath()
const config = useRuntimeConfig()
definePageMeta({
  layout:'admin'
})
</script>
<script lang="js">
export default {
  data(){
    return{
      owner_id:null,
      agencys: [],
      time:null,
      chats_page:1,
      chat_page:1,
      selectedChat: null,
      newMessage: '',
      chats: [],
      chat: [],
    }
  },
  async mounted() {
    await this.getAgencys()
    await this.getChats()
    await this.syncData()
  },
  beforeUnmount() {
    clearInterval(this.timer);
  },
  methods: {
    scrollToBottom() {
      this.$nextTick(() => {
        const container = this.$refs.messageContainer?.$el;
        if (container) {
          container.scrollTop = container.scrollHeight;
        }
      });
    },
    async getAgencys(){
      const res = await useApi('/admin/agencys/get_agencys', {});
      this.agencys = res.data
    },
    async getChats() {
      this.selectedChat = null
      const res = await useApi('/admin/chats/get_chats', {owner_id:this.owner_id,page: this.chats_page});
      this.chats = res.data
    },
    async selectChat(chat) {
      this.selectedChat = chat;
      this.newMessage = '';
      const res = await useApi('/admin/chats/get_chat', {owner_id:this.owner_id,page: this.chat_page,id: chat.user_id,ads_id:chat.ads_id});
      this.chat = res.data
      this.scrollToBottom();
    },
    async syncData() {
      this.timer = setInterval(async () => {
        try {
          if(this.selectedChat !== null){
            console.log(this.selectedChat)
            const res = await useApi('/admin/chats/sync_chat', {owner_id:this.owner_id,id: this.selectedChat.user_id,ads_id: this.selectedChat.ads_id});
            if (res && res.status === 1) {
              if (res.read === 1) {
                this.chat.forEach(item => {
                  if (item.read === 0) {
                    item.read = 1;
                  }
                });
              }
              for (const newItem of res.data) {
                const messageExists = this.chat.some(existingItem => existingItem.id === newItem.id);
                if (!messageExists) {
                  this.chat.push(newItem);
                }
              }
            }
          }
        } catch (error) {
          console.error("Failed to sync chat data:", error);
        }
      }, 3000);
    },
  }
}
</script>
<template>
  <v-row>
    <v-col cols="4" md="3" lg="3" style="height: 82vh">
      <v-card class="h-100 overflow-y-auto">

        <template v-if="chats.length > 0">
          <div class="mx-2 my-3">
            <v-select :label="$t('agency_name')" v-model="owner_id" :items="agencys" item-value="owner_id" item-title="name" @update:modelValue="getChats()" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details></v-select>
          </div>
          <v-divider/>
          <v-list>
            <v-list-item v-for="chat in chats" :key="chat.id" :value="chat.id" @click="selectChat(chat)" :active="selectedChat && selectedChat.id === chat.id" color="primary">
              <template v-slot:prepend><v-avatar :image="chat.ads_img !== '' ? config.public.url_api+'/uploads/imgs/md/'+chat.ads_img : '/imgs/no_img.webp'"></v-avatar></template>
              <v-list-item-title>{{ chat.ads_title }}</v-list-item-title>
              <v-list-item-subtitle v-if="chat.read == 1">{{ chat.msg }}</v-list-item-subtitle>
              <v-list-item-subtitle v-else><strong>{{ chat.msg }}</strong></v-list-item-subtitle>
            </v-list-item>
          </v-list>
        </template>

        <template v-else>
          <div class="mx-2 my-3">
            <v-select :label="$t('agency_name')" v-model="owner_id" :items="agencys" item-value="owner_id" item-title="name" @update:modelValue="getChats()" clear-icon="fa-solid fa-close" menu-icon="fa-solid fa-chevron-down" variant="outlined" density="compact" hide-details></v-select>
          </div>
          <v-divider/>
          <div class="d-flex align-center justify-center text-grey" style="height: 50vh;">
            <div class="text-center">
              <p>لا يوجد أي محادثات</p>
            </div>
          </div>
        </template>

      </v-card>
    </v-col>
    <v-col cols="8" md="9" lg="9" style="height: 82vh">
      <v-card class="h-100 d-flex flex-column">


        <template v-if="selectedChat">
          <v-toolbar color="surface">
            <v-avatar class="mx-4">
              <v-img :src="selectedChat.ads_img !== '' ? config.public.url_api+'/uploads/imgs/md/'+selectedChat.ads_img : '/imgs/no_img.webp'"></v-img>
            </v-avatar>
            <v-toolbar-title>{{ selectedChat.ads_title }}</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-btn v-if="false" icon="mdi-dots-vertical"></v-btn>
          </v-toolbar>
          <v-divider/>

          <v-container ref="messageContainer"  fluid class="flex-grow-1 overflow-y-auto pa-4 d-flex flex-column">
            <v-spacer></v-spacer>

            <div v-for="message in chat" :key="message.id" class="d-flex mb-4" :class="message.sender === 'me' ? 'justify-start' : 'justify-end'">
              <v-sheet :color="message.sender === 'me' ? 'primary' : 'surface-variant'" class="pa-3 rounded-lg" max-width="75%">
                <p class="text-body-1">{{ message.msg }}</p>
                <div class="text-caption text-right mt-1">{{ message.time }}</div>
              </v-sheet>
            </div>
          </v-container>

          <div class="pa-4">
            <v-text-field v-model="newMessage" label="الرسالة..." variant="outlined" append-inner-icon="fa-solid fa-send fa-flip-horizontal" hide-details disabled></v-text-field>
          </div>
        </template>

        <template v-else>
          <div class="d-flex fill-height align-center justify-center text-grey">
            <div class="text-center">
              <v-img src="/imgs/no_chat.webp" width="200"></v-img>
              <p>إختر محادثة</p>
            </div>
          </div>
        </template>



      </v-card>
    </v-col>
  </v-row>
</template>