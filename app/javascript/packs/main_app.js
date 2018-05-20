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
import bFormSlider from 'vue-bootstrap-slider';
import VueNumeric from 'vue-numeric'
import format from 'number-format.js'
import moment from 'moment-timezone';
moment.locale('it');


import 'bootstrap-vue/dist/bootstrap-vue.css';
import '../styles/style.scss';
import 'bootstrap-slider/dist/css/bootstrap-slider.css';

import {icon} from 'vue-fontawesome';

Vue.use(BootstrapVue);
Vue.use(VueRouter);
Vue.use(bFormSlider);
Vue.use(VueNumeric);


Vue.component('vf-icon', icon);

Vue.filter('distance_format', function (value) {
  if (!value) return '';
  return format( "0,00", parseFloat(value));
});

Vue.filter('points_format', function (value) {
  if (!value) return '';
  return format( "0,000", parseFloat(value));
});

Vue.filter('timezone', function (value,) {
  if (!value) return '';
  return moment(value).tz('Europe/Rome')
});

Vue.filter('time_format', function (value,format='l') {
  if (!value) return '';
  return value.format(format);
});

Vue.filter('calendar', function (value,) {
  if (!value) return '';
  return value.calendar()
});



document.addEventListener('DOMContentLoaded', () => {
  document.body.appendChild(document.createElement('main_app'))
  const app = new Vue(App).$mount('main_app')

  console.log(app)
});


