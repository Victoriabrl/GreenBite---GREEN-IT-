<template>
    <div>
  
      <div v-if="action === 'show'">
        <h1>{{ currentProduct.ProductName }}</h1>
        {{ currentProduct }}
  
      </div>
  
  
      <!--
      <div v-if="action === 'edit'">
      </div>
      -->
      <!-- v-model is a two-way data-binding, when the input changes, the variable changes too -->
  
  
  
      <!-- when on: /books/list/all -->
      <div  v-if="action === 'list'">   <!-- v-if is a conditional rendering -->
        <h1>Products List</h1>
  
        <ul class="games-list">
          <li v-for="product of productArray" v-bind:key="product.ProductID" class="zoom-hover">
            <a :href="'/#/products/show/' + product.ProductID">
              <table class="table table-bordered">
                <thead>
                  <tr>
                    <th colspan="3">
                        {{ product.ProductName }}
                    </th>
                  </tr>
                  <tr>
                    <th colspan="3">
                    </th>
                  </tr>
                </thead>
              </table>
            </a>
          </li>
            {{ productArray }}
        </ul>
  
  
      </div>
  
    </div>
  </template>
  
  
  <script>
  export default {
    name: 'Games',
    props: ['action', 'id'],  // properties that can be passed to the component
    // action: show, edit, list
    // id: book_id
    data() {
      return {   // variables that can be used in the template
        //user_role: 'GUEST',
        pageNumber: 1,
        pageSize: 30,
        numberOfPages: 0,
  
        productArray: [],
  
        currentProduct: {
          /*[0] is game
          */
          /*
          id: 0,
          primary_name: "xxx",
          description: "xxx",
          yearpublished: 0,
          minplayers: 0,
          maxplayers: 0,
          playingtime: 0,
          minplaytime: 0,
          maxplaytime: 0,
          minage: 0,
          bgg_rank: 0,
          average_rating: 0.00,
          bayes_average: 0.000,
          users_rated : 0,
          url: "xxx",
          thumbnail: "xxx",
          owned: 0,
          trading: 0,
          wanting: 0,
          wishing: 0*/
        }
      };
    },
  
    methods: {   // logic that can be called from the template
  
      async getAllData(pageNumber, pageSize) {
        try {
          let responseProduct = await this.$http.get('http://localhost:9000/api/products/list');
          this.productArray = await responseProduct.data;
  
        } catch (exception) {
          console.log(exception);
        }
      },
  
  
      async refreshcurrentProduct() {
        if (this.$props.id === "all" || this.$props.id === "0") {
          this.currentProduct = {
            /*
            id: 0,
            primary_name: "xxx",
            description: "xxx",
            yearpublished: 0,
            minplayers: 0,
            maxplayers: 0,
            playingtime: 0,
            minplaytime: 0,
            maxplaytime: 0,
            minage: 0,
            bgg_rank: 0,
            average_rating: 0.00,
            bayes_average: 0.000,
            users_rated : 0,
            url: "xxx",
            thumbnail: "xxx",
            owned: 0,
            trading: 0,
            wanting: 0,
            wishing: 0*/
          };
          return;
        }
        try {
          let responseProduct = await this.$http.get("http://localhost:9000/api/products/show/" + this.$props.id);
          this.currentProduct = responseProduct.data;
  
        } catch (ex) {
          console.log(ex);
        }
      }
    },
  
    watch: {   // watch for changes in the variables
      id: function(newId, oldId) {
        this.refreshcurrentProduct();
      },
  
      action: function(newAction, oldAction) {
        if (newAction === 'list') {
          this.getAllData();
        }
      },
  
      pageNumber: function(newPageNumber, oldPageNumber) {
        this.getAllData();
      },
  
      pageSize: function(newPageSize, oldPageSize) {
        this.getAllData();
      }
    },
  
    created() {   // executed when the component is created
      //this.getUserRole();
      this.getAllData();
      this.refreshcurrentProduct();
    }
  };
  </script>
  
  <!-- Add "scoped" attribute to limit CSS to this component only -->
  <style scoped>
    h1, h2 {
      font-weight: normal;
    }
  
    a {
      color: #000000;
      text-decoration: none;
    }
  
    a:hover {
      text-decoration: underline;
    }
  
    .new-button {
      padding: 10px;
      margin-bottom: 20px;
      margin-top: -30px;
    }
  
  
    /************ GAMES LIST ************/
    .games-list {
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
  
    .games-list li {
      margin: 0 20px 20px;
      text-align: center;
      position: relative;
      max-width: 200px;
    }
    
    .games-list li img {
      max-width: 100px;
      max-height: 100px;
    }
  
    .games-list tbody {
      text-align: center;
      font-size: 0.8em;
    }
  
    /************ Pagination ************/
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      /* space between the buttons */
      gap: 10px;
    }
  
    .pagination input[type="number"] {
      width: 70px;
      text-align: center;
    }
  
    table {
      width: 80%;
      /* center the table */
      margin: 20px auto;
    }
    
  
  </style>