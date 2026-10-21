export default defineNuxtPlugin((nuxtApp) => {
    if (process.client) {
        nuxtApp.hook('vuetify:ready', (vuetify) => {
            const darkMode = localStorage.getItem('dark') === 'true';
            vuetify.theme.global.name.value = darkMode ? 'dark' : 'light';
        });
    }
});