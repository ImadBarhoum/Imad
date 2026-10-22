<script setup>
const props = defineProps({
  error: Object,
  required: true,
});
const handleError = () => clearError({ redirect: '/' });
setTimeout(handleError, 5000);
</script>

<template>
  <v-app theme="light">
    <v-sheet class="d-flex justify-center align-center" style="height: 100vh;">
      <div>
        <v-img src="/imgs/error.png" width="350"></v-img>
        <div class="text-center">
          <h1 class="mb-4">{{ error.statusCode }}</h1>
          <v-btn color="info" @click="handleError" width="130" variant="tonal">{{ $t('home') }}</v-btn>
          <div style="height: 120px;"></div>
        </div>
      </div>
    </v-sheet>
  </v-app>
</template>