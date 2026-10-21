<script setup lang="js">
const router = useRouter()
const localPath = useLocalePath()
definePageMeta({
  layout:'agency'
})
router.push(localPath('/agency/ads'))
</script>
<template></template>