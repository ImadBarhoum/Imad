<script setup lang="js">
const router = useRouter()
const panel = usePanel()
const localPath = useLocalePath()
definePageMeta({
  layout:'empty'
})
const res = await useAuth().check()
if(panel.user.user_type === 'admin'){
  router.push(localPath('/admin'))
}else if(panel.user.user_type === 'agency'){
  router.push(localPath('/agency'))
}else{
  await useAuth().logout()
  router.push(localPath('/login'))
}
</script>
<template>
  <h1></h1>
</template>