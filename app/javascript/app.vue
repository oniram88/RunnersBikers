<style scoped>
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
          <b-nav-item :to="{name:'performance_list'}">Lista Prestazioni
          </b-nav-item>
          <b-nav-item :to="{name:'new_performance'}">Nuova Prestazione
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

  Vue.use(Vuex);

  const store = new Vuex.Store({
    state: {
      user_id: null,
      user_roles: [],
      username: null
    },
    mutations: {
      set_current_user(state, user) {
        console.log(state, user);
        state.user_id = user.user_id;
        state.user_roles = user.roles;
        state.username = user.username;
        //   state.count++
      }
    }
  });


  axios.get(Routes.actual_user_base_infos_path({format: 'json'})).then(ris => {
    store.commit('set_current_user', ris.data);
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
        'username'
      ])
    },
    components: {
      Performance,
      PerformancesList,
      Ranking
    }
  }
</script>

