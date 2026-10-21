<script setup lang="js">
import { VueEditor } from "vue3-editor";
</script>
<script lang="js">
export default {
  props: {
    modelValue: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      customToolbar: [
        [{ header: [false, 1, 2, 3, 4, 5, 6] }],
        ["bold", "italic", "underline", "strike"],
        [
          { align: "" },
          { align: "center" },
          { align: "right" },
          { align: "justify" }
        ],
        ["blockquote", "code-block"],
        [{ list: "ordered" }, { list: "bullet" }, { list: "check" }],
        [{ indent: "-1" }, { indent: "+1" }],
        [{ color: [] }, { background: [] }],
        ["link", "image", "video"],
        [{ direction: "rtl" }],
        ["clean"]
      ],
    };
  },
  computed: {
    content: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('update:modelValue', value);
      },
    },
  },
};
</script>
<template>
  <client-only>
    <VueEditor v-model="content" :editor-toolbar="customToolbar" dir="ltr"/>
  </client-only>
</template>