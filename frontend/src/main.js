import Vue from 'vue'
import App from './App'
import router from './router'
import axios from 'axios'


Vue.config.productionTip = false
axios.defaults.withCredentials = true; // PASSPORT
Vue.prototype.$http = axios;
Vue.prototype.$apiBaseUrl = process.env.NODE_ENV === 'production' 
  ? 'https://your-backend-url.com/api'
  : 'http://localhost:9000/api';

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
