<script setup lang="ts">
useGlobal()
const config = useRuntimeConfig()
const c_pwa = config.public.pwa
</script>
<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>