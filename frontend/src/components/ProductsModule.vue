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
      <h1>Products List</h1>

      <ul class="products-list">
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
    name: 'Products',
    props: ['action', 'id'],  // properties that can be passed to the component

    data() {
      return {   // variables that can be used in the template
        pageNumber: 1,
        pageSize: 30,
        numberOfPages: 0,
  
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
      this.getAllData();
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
</style>