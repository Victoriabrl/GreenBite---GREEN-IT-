<template>
  <div id="app">
    <AppHeader />
    <router-view/>
  </div>
</template>

<script>
import AppHeader from './components/Header.vue';  // Import the header component

export default {
  name: 'App',
  components: {   // Register the components so they can be used in the template
    AppHeader
  }
}
</script>

<style>
  #app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-bottom: 200px;
  }

  h1 {
    margin-top: 40px;
  }

  a {
    color: #2c3e50;
  }

  /************ PRODUCTS LIST ************/
  table {
    width: 80%;
    /* center the table */
    margin: 20px auto;
  }

  .products-list {
    margin: auto; /* Center the ul element */
    margin-top: 20px;
    display: flex;
    flex-wrap: wrap;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    text-align: center;
    max-width: 1300px;
    list-style-type: none; /* Remove dots */
  }

  .products-list li {
    margin: 0 20px 20px;
    text-align: center;
    position: relative;
    max-width: 200px;
  }
  
  .products-list li img {
    max-width: 100px;
    max-height: 100px;
  }

  .products-list tbody {
    text-align: center;
    font-size: 0.8em;
  }

  /************ Pagination ************/
  .pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
  }

  .pagination input[type="number"] {
    width: 70px;
    text-align: center;
  }
</style>
