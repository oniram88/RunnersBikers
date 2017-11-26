<style scoped>
</style>

<template>

  <b-container fluid>

    <b-navbar toggleable="md" type="dark" variant="info">

      <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

      <b-navbar-brand href="#">
        <img :src="logo" class="d-inline-block align-top" alt="Runners Bikers">
      </b-navbar-brand>

      <b-collapse is-nav id="nav_collapse">

        <b-navbar-nav>
          <b-nav-item to="/new_performance" >Nuova Prestazione
          </b-nav-item>
          <b-nav-item href="#/new_performance">Disabled</b-nav-item>
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
              <em>Utente</em>
            </template>
            <b-dropdown-item href="#">Profile</b-dropdown-item>
            <b-dropdown-item href="#">Signout</b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>

      </b-collapse>
    </b-navbar>

    <router-view></router-view>


  </b-container>

</template>

<script>

  import VueRouter from 'vue-router'
  import Performance from 'components/Performance.vue'
  import logo from './images/logo_mini.jpg'

  const router = new VueRouter({
    routes: [
      {path: '/new_performance', component: Performance}
    ] // short for `routes: routes`
  });

  export default {
    router,
    data: function () {
      return {}
    },
    computed:{
      logo(){
        return logo;
      }
    },
    components: {
      Performance
    }
  }
</script>

