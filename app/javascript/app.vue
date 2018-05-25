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
          <b-nav-item :to="{name:'users_list'}" v-if="is_admin">Utenti
          </b-nav-item>
        </b-navbar-nav>

        <!-- Right aligned nav items -->
        <b-navbar-nav class="ml-auto">

          <!--<b-nav-form>-->
          <!--<b-form-input size="sm" class="mr-sm-2" type="text" placeholder="Search"/>-->
          <!--<b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>-->
          <!--</b-nav-form>-->

          <b-nav-item>
            Punti Referal: {{referal_points}}
          </b-nav-item>

          <b-nav-item>
            Punti Totali: {{total_points}}
          </b-nav-item>

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
              <em>{{first_name}} {{last_name}}</em>
            </template>
            <!--<b-dropdown-item href="#">Profile</b-dropdown-item>-->
            <b-dropdown-item :href="logout()">Signout</b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>

      </b-collapse>
    </b-navbar>

    <router-view></router-view>

    <div class="loader_modal_hider" v-if="store_loading_counter>0">
      <div class="loader_container">
        <pacman-loader :loading="true" :color="'#17a2b8'"></pacman-loader>
      </div>
    </div>

  </b-container>

</template>

<script>

  import Vue from 'vue'
  import VueRouter from 'vue-router'
  import Vuex from 'vuex'
  import {mapState} from 'vuex'
  import Performance from 'components/Performance.vue'
  import PerformancesList from 'components/PerformancesList.vue'
  import Ranking from 'components/Ranking.vue'
  import MatchesList from 'components/MatchesList.vue'
  import UserList from 'components/UserList'
  import logo from './images/logo_mini.jpg'
  import PacmanLoader from 'vue-spinner/src/PacmanLoader'

  import {ApolloClient} from 'apollo-client'
  import {ApolloLink, concat, execute, makePromise} from 'apollo-link';
  import {HttpLink} from 'apollo-link-http'
  import {InMemoryCache} from 'apollo-cache-inmemory'
  import VueApollo from 'vue-apollo'
  import {CLIENT_CONFIGURATION} from './graphql/base_client'


  Vue.use(Vuex);

  const store = new Vuex.Store({
    state: {
      user_id: null,
      user_roles: [],
      username: null,
      first_name: null,
      last_name: null,
      program_version: null,
      store_loading_counter: 0,
      referal_points: null,
      total_points: null
    },
    mutations: {
      set_current_user(state, user) {
        state.user_id = user.user_id;
        state.user_roles = user.roles;
        state.username = user.username;
        state.first_name = user.first_name;
        state.last_name = user.last_name;
        state.referal_points = user.referal_points;
        state.total_points = user.total_points;
        //TODO spostare in chiamata più adatta
        state.program_version = user.program_version;
        //   state.count++
      },
      increment_loading_counter(state) {
        state.store_loading_counter = state.store_loading_counter + 1;
      },
      decrement_loading_counter(state) {
        state.store_loading_counter = state.store_loading_counter - 1;
      }
    }
  });


  const httpLink = new HttpLink({
    // You should use an absolute URL here
    uri: Routes.graphql_path(),
    credentials: 'same-origin'
  });

  const authMiddleware = new ApolloLink((operation, forward) => {
    // add the authorization to the headers
    operation.setContext({
      headers: {
        'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content
      }
    });

    return forward(operation);
  });

  const start_connection = new ApolloLink((operation, forward) => {
    store.commit('increment_loading_counter');

    return forward(operation);
  })

  const end_connection = new ApolloLink((operation, forward) => {
    return forward(operation).map(response => {
      store.commit('decrement_loading_counter');
      return response;
    });
  })

  let link = concat(authMiddleware, httpLink);
  link = concat(start_connection, link);
  link = end_connection.concat(link);

  // Create the apollo client
  const apolloClient = new ApolloClient({
    link: link,
    cache: new InMemoryCache(),
    connectToDevTools: true
  });

  const apolloProvider = new VueApollo({
    defaultClient: apolloClient
  });

  // Install the vue plugin
  Vue.use(VueApollo);

  Vue.mixin({
    methods: {
      update_user_data:function () {
        console.log('dati del client');
        apolloClient.query({
          query: CLIENT_CONFIGURATION,
          fetchPolicy:"network-only"
        }).then((data) => {
          store.commit('set_current_user', data.data.client_configuration);
        })
      }
    }
  })



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
        children: [
          {
            path: ':id/edit',
            name: 'user_performance_edit',
            component: Performance
          }
        ]
      },
      {
        path: '/ranking',
        alias: '/',
        name: 'ranking',
        component: Ranking
      },
      {
        path: '/users',
        name: 'users_list',
        component: UserList
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
    provide: apolloProvider.provide(),
    data: function () {
      return {}
    },
    methods: {
      logout() {
        return Routes.destroy_user_session_path();
      }
    },
    created:function(){
      this.update_user_data();
    },
    computed: {
      logo() {
        return logo;
      },
      ...mapState([
        'first_name',
        'last_name',
        'program_version',
        'store_loading_counter',
        'user_roles',
        'referal_points',
        'total_points'
      ]),
      is_admin() {
        return _.includes(this.user_roles, 'admin') || _.includes(this.user_roles, 'judge');
      }
    },
    components: {
      Performance,
      PerformancesList,
      Ranking,
      PacmanLoader
    }
  }
</script>

