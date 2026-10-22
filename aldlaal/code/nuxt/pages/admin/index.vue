<script setup lang="js">
const router = useRouter()
const localPath = useLocalePath()
definePageMeta({
  layout:'admin'
})
router.push(localPath('/admin/statistics'))
</script>
<template></template>