<style scoped lang="scss">

  .loader_modal_hider {
    top: 0px;
    position: absolute;
    bottom: 0px;
    left: 0px;
    right: 0px;
    z-index: 1000;
    background-color: #cccccca3;
    .loader_container {
      position: relative;
      width: 100px;
      vertical-align: middle;
      top: 50%;
      left: 50%;

    }
  }


</style>

<template>

  <b-container fluid>

    <b-navbar toggleable="md" type="dark" variant="info">

      <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

      <b-navbar-brand href="#/">
        <img :src="logo" class="d-inline-block align-top" alt="Runners Bikers">
      </b-navbar-brand>

      <b-collapse is-nav id="nav_collapse">

        <b-navbar-nav>
          <b-nav-item :to="{name:'ranking'}">Classifica
          </b-nav-item>
          <b-nav-item :to="{name:'performance_list'}">Lista Sessioni
          </b-nav-item>
          <b-nav-item :to="{name:'new_performance'}">Nuova Sessione
          </b-nav-item>
          <b-nav-item :to="{name:'matches'}">Sfide
          </b-nav-item>
        </b-navbar-nav>

        <!-- Right aligned nav items -->
        <b-navbar-nav class="ml-auto">

          <!--<b-nav-form>-->
          <!--<b-form-input size="sm" class="mr-sm-2" type="text" placeholder="Search"/>-->
          <!--<b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>-->
          <!--</b-nav-form>-->

          <b-nav-item>
            Versione: {{program_version}}
          </b-nav-item>
          <!--<b-nav-item-dropdown text="Lang" right>-->
          <!--<b-dropdown-item href="#">EN</b-dropdown-item>-->
          <!--<b-dropdown-item href="#">ES</b-dropdown-item>-->
          <!--<b-dropdown-item href="#">RU</b-dropdown-item>-->
          <!--<b-dropdown-item href="#">FA</b-dropdown-item>-->
          <!--</b-nav-item-dropdown>-->

          <b-nav-item-dropdown right>
            <!-- Using button-content slot -->
            <template slot="button-content">
              <em>{{username}}</em>
            </template>
            <!--<b-dropdown-item href="#">Profile</b-dropdown-item>-->
            <b-dropdown-item :href="logout()">Signout</b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>

      </b-collapse>
    </b-navbar>

    <router-view></router-view>

    <div class="loader_modal_hider" v-if="ajax_loading">
      <div class="loader_container">
        <pacman-loader :loading="true" :color="'#17a2b8'"></pacman-loader>
      </div>
    </div>

  </b-container>

</template>

<script>

  import Vue from 'vue'
  import axios from 'axios'
  import VueRouter from 'vue-router'
  import Vuex from 'vuex'
  import {mapState} from 'vuex'
  import Performance from 'components/Performance.vue'
  import PerformancesList from 'components/PerformancesList.vue'
  import Ranking from 'components/Ranking.vue'
  import MatchesList from 'components/MatchesList.vue'
  import logo from './images/logo_mini.jpg'
  import PacmanLoader from 'vue-spinner/src/PacmanLoader'

  Vue.use(Vuex);

  const store = new Vuex.Store({
    state: {
      user_id: null,
      user_roles: [],
      username: null,
      program_version: null,
      ajax_loading: false
    },
    mutations: {
      set_current_user(state, user) {
        console.log(state, user);
        state.user_id = user.user_id;
        state.user_roles = user.roles;
        state.username = user.username;
        //TODO spostare in chiamata più adatta
        state.program_version = user.program_version;
        //   state.count++
      },
      set_loading_state(state, status) {
        state.ajax_loading = status;
      }
    }
  });


  axios.get(Routes.actual_user_base_infos_path({format: 'json'})).then(ris => {
    store.commit('set_current_user', ris.data);
  });

  axios.interceptors.request.use((config) => {
    // Do something before request is sent
    store.commit('set_loading_state', true);
    return config;
  }, (error) => {
    // Do something with request error
    store.commit('set_loading_state', false);
    return Promise.reject(error);
  });

  // Add a response interceptor
  axios.interceptors.response.use((response) => {
    // Do something with response data
    store.commit('set_loading_state', false);
    return response;
  }, (error) => {
    // Do something with response error
    store.commit('set_loading_state', false);
    return Promise.reject(error);
  });

  const router = new VueRouter({
    routes: [
      {
        path: '/performances',
        name: 'performance_list',
        component: PerformancesList,
        children: [
          {
            path: 'new',
            name: 'new_performance',
            component: Performance
          },
          {
            path: ':id/edit',
            name: 'performance_edit',
            component: Performance
          }
        ]
      },
      {
        path: '/matches',
        name: 'matches',
        component: MatchesList,
        children: [
          {
            path: 'user/:user_id/performances/:id/edit_performance',
            name: 'match_performance_edit',
            component: Performance
          }
        ]
      },
      {
        path: '/users/:user_id/performances',
        name: 'user_performance_list',
        component: PerformancesList,
      },
      {
        path: '/ranking',
        alias: '/',
        name: 'ranking',
        component: Ranking
      },
      {
        path: '*',
        redirect: '/'
      }
    ] // short for `routes: routes`
  });

  export default {
    router,
    store,
    data: function () {
      return {}
    },
    methods: {
      logout() {
        return Routes.destroy_user_session_path();
      }
    },
    computed: {
      logo() {
        return logo;
      },
      ...mapState([
        'username',
        'program_version',
        'ajax_loading'
      ])
    },
    components: {
      Performance,
      PerformancesList,
      Ranking,
      PacmanLoader
    }
  }
</script>

