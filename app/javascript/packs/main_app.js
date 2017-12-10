/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you set extractStyles to true
// in config/webpack/loaders/vue.js) to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue'
import App from '../app.vue'
import BootstrapVue from 'bootstrap-vue'
import VueRouter from 'vue-router'
import axios from 'axios'
import bFormSlider from 'vue-bootstrap-slider';

import 'bootstrap-vue/dist/bootstrap-vue.css';
import '../styles/style.scss';
import 'bootstrap-slider/dist/css/bootstrap-slider.css';

import {icon} from 'vue-fontawesome';

Vue.use(BootstrapVue);
Vue.use(VueRouter);
Vue.use(bFormSlider);


Vue.component('vf-icon', icon);

import moment from 'moment';
moment.locale('it');


let token = document.getElementsByName('csrf-token')[0].getAttribute('content');
axios.defaults.headers.common['X-CSRF-Token'] = token;
axios.defaults.headers.common['Accept'] = 'application/json';


document.addEventListener('DOMContentLoaded', () => {
  document.body.appendChild(document.createElement('main_app'))
  const app = new Vue(App).$mount('main_app')

  console.log(app)
});


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from './app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
