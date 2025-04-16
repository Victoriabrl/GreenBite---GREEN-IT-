<template>
  <div>

    <div v-if="action === 'show'">
      <h1>{{ currentProduct.ProductName }}</h1>
      <p>{{ currentProduct.Description }}</p>
      <p>
        Sold by <a :href="'/#/vendors/show/'+ currentProduct.VendorID">{{ currentProduct.BusinessName }}</a>
      </p>

      {{ currentProduct }}
    </div>


    <div  v-if="action === 'list'">
      <div>
        <h1>What are you looking for?</h1>
        <!-- Checkboxes for the filters ('Vegetable', 'Fruit', 'Dairy', 'Meat', 'Grain', 'Snack')
         Ticking a checkbox will add the filter to the filterArray and unticking it will remove it from the filterArray -->
        <div class="filter-checkboxes">
          <label v-for="category in ['Vegetable', 'Fruit', 'Dairy', 'Meat', 'Grain', 'Snack']" :key="category" class="filter-checkbox">
            <input 
              type="checkbox" 
              :value="category" 
              v-model="filterArray"
            >
            <!--@change="getAllData()"-->
            {{ category }}
          </label><br/>
          <input type="button" @click="getAllDataWithFilters()" value="Apply"/>
        </div>


      </div>

      <div><!-- v-if="filter === 1">-->
        <h1>Products List</h1>
        <ul class="products-list">
          <li v-for="product of productArray" v-bind:key="product.ProductID" class="zoom-hover">
            <a :href="'/#/products/show/' + product.ProductID">
              <table class="table table-bordered">
                <thead>
                  <tr>
                    <th colspan="2">
                        {{ product.ProductName }}
                    </th>
                  </tr>
                </thead>

                <tbody>
                  <tr>
                    <td>{{ product.Price }}€</td>
                    <td>{{ product.Quantity }} kg</td>
                  </tr>
                  <tr>
                    <td colspan="2">
                      Good before: {{ product.DueDate }}
                    </td>
                  </tr>
                </tbody>
              </table>
            </a>
          </li>
            {{ productArray }}
        </ul>
      </div>
    </div>

  </div>
</template>
  
  
<script>
  export default {
    name: 'Products',
    props: ['action', 'id'],  // properties that can be passed to the component
    filter: 0,

    data() {
      return {   // variables that can be used in the template
        pageNumber: 1,
        pageSize: 30,
        numberOfPages: 0,
  
        filterArray: [],
        productArray: [],
        currentProduct: {

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

      async getAllDataWithFilters(pageNumber, pageSize) {
        try {
          // concatenate the filterArray into a string with commas
          let filterString = this.filterArray.join(',');
          let responseProduct = await this.$http.get('http://localhost:9000/api/products/categories/' + filterString);
          this.productArray = await responseProduct.data;
  
        } catch (exception) {
          console.log(exception);
        }
      },
  
  
      async refreshcurrentProduct() {
        if (this.$props.id === "all" || this.$props.id === "0") {
          this.currentProduct = {
            
          };
          return;
        }
        try {
          let responseProduct = await this.$http.get("http://localhost:9000/api/products/show/" + this.$props.id);
          this.currentProduct = responseProduct.data;
  
        } catch (ex) {
          console.log(ex);
        }
      },

      //async orderProduct()
    },
  
    watch: {   // watch for changes in the variables
      id: function(newId, oldId) {
        this.refreshcurrentProduct();
      },
  
      action: function(newAction, oldAction) {
        if (newAction === 'list') {
          this.getAllDataWithFilters();
        }
      },
  
      pageNumber: function(newPageNumber, oldPageNumber) {
        this.getAllDataWithFilters();
      },
  
      pageSize: function(newPageSize, oldPageSize) {
        this.getAllDataWithFilters();
      }
    },
  
    created() {   // executed when the component is created
      //this.getAllData();
      this.refreshcurrentProduct();
    }
  };
</script>
  
<style scoped>
  h1, h2 {
    font-weight: normal;
  }

  .new-button {
    padding: 10px;
    margin-bottom: 20px;
    margin-top: -30px;
  }

  .filter-checkbox {
    display: inline-block;
    margin-right: 15px;
    margin-bottom: 10px;
  }
</style>