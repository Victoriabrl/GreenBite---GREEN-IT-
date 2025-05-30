<template>
  <div class="container">
    <!-- Product Details Page -->
    <div v-if="action === 'show'" class="product-details">
      <div class="product-header">
        <h1>{{ currentProduct.ProductName }}</h1>
        <span class="badge">{{ currentProduct.Category }}</span>
      </div>
      
      <div class="product-info">
        <div class="product-description">
          <p>{{ currentProduct.Description }}</p>
          <p class="vendor-info">
            Sold by <a :href="'/#/vendors/show/'+ currentProduct.VendorID">{{ currentProduct.BusinessName }}</a>
          </p>
        </div>
        
        <div class="product-meta">
          <div class="meta-item">
            <span class="label">Price:</span>
            <span class="value">{{ currentProduct.Price }}€</span>
          </div>
          <div class="meta-item">
            <span class="label">Quantity:</span>
            <span class="value">{{ currentProduct.Quantity }} kg</span>
          </div>
          <div class="meta-item">
            <span class="label">Good before:</span>
            <span class="value">{{ currentProduct.DueDate }}</span>
          </div>
        </div>
      </div>

      <div class="payment-section">
        <div class="payment-card">
          <h3>Buy now!</h3>
          <p>
            Check the <a :href="'/#/vendors/show/'+ currentProduct.VendorID">vendor's details</a> (physical address, email...)<br/>
            If you are interested in this product, buy it now and go pick it up at the vendor's location!
          </p>
          
          <div class="payment-methods">
            <h4>Select payment method:</h4>
            <div class="radio-group">
              <label v-for="method in ['Credit_Card', 'Debit_Card', 'PayPal']" :key="method" class="radio-option">
                <input 
                  type="radio" 
                  name="paymentMethod" 
                  :value="method" 
                  v-model="selectedPaymentMethod"
                >
                <span class="radio-label">{{ method.replace('_', ' ') }}</span>
              </label>
            </div>
            
            <button 
              class="btn primary payment-button" 
              @click="orderProduct(currentProduct.ProductID, selectedPaymentMethod)"
              :disabled="!selectedPaymentMethod"
            >
              Pay Now
            </button>
          </div>
        </div>
      </div>
    </div>

    <div v-if="action === 'edit'">
      <h1>Edit Product</h1>
      <div class="product-details">
      <!-- edit the fields: Category, ProductName, Description, Price, Quantity, DueDate -->
      <div class="product-header">
        <h1>
          <label for="productName">Product Name:</label>
          <input type="text" class="form-control" id="productName" v-model="currentProduct.ProductName">
        </h1>

        <span class="badge">
          <label for="category">Category:</label>
          <select class="form-control" id="category" v-model="currentProduct.Category">
            <option value="Vegetable">Vegetable</option>
            <option value="Fruit">Fruit</option>
            <option value="Dairy">Dairy</option>
            <option value="Meat">Meat</option>
            <option value="Grain">Grain</option>
            <option value="Snack">Snack</option>
          </select>
        </span>
      </div>
        

      <div class="product-info">
        <div class="product-description">
          <label for="description">Description:</label>
          <textarea class="form-control" id="description" v-model="currentProduct.Description"></textarea>
        </div>
        
        <div class="product-meta">
          <div class="meta-item">
            <span class="label"><label for="price">Price: </label></span>
            <span class="value"><input type="number" class="form-control" id="price" v-model="currentProduct.Price">€</span>
          </div>
          <div class="meta-item">
            <span class="label"><label for="quantity">Quantity: </label></span>
            <span class="value"><input type="number" class="form-control" id="quantity" v-model="currentProduct.Quantity"> kg</span>
          </div>
          <div class="meta-item">
            <span class="label"><label for="dueDate">Good Before: </label></span>
            <span class="value"><input type="date" class="form-control" id="dueDate" v-model="currentProduct.DueDate"></span>
          </div>
        </div>
      </div>
      
      </div>
      <button type="submit" @click="sendEditRequest()" class="btn primary">Save Changes</button>
    </div>

    <!-- Products List Page -->
    <div v-if="action === 'list'" class="products-page">
      <div class="filter-section">
        <h1>What are you looking for?</h1>
        <div class="filter-options">
          <label v-for="category in ['Vegetable', 'Fruit', 'Dairy', 'Meat', 'Grain', 'Snack']" 
                :key="category" 
                class="filter-checkbox">
            <input 
              type="checkbox" 
              :value="category" 
              v-model="filterArray"
            >
            <span class="checkbox-label">{{ category }}</span>
          </label>
          <button class="btn primary filter-button" @click="getAllDataWithFilters()">Apply Filters</button>
        </div>
      </div>

      <div class="products-section">
        <h1>Products List</h1>
        <div class="products-grid">
          <div v-for="product of productArray" 
               v-bind:key="product.ProductID" 
               class="product-card">
            <a :href="'/#/products/show/' + product.ProductID" class="product-link">
              <div class="product-name">{{ product.ProductName }}</div>
              <div class="product-details">
                <span class="product-price">{{ product.Price }}€</span>
                <span class="product-quantity">{{ product.Quantity }} kg</span>
              </div>
              <div class="product-date">Good before: {{ product.DueDate }}</div>
            </a>
          </div>
        </div>
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
        selectedPaymentMethod: null,
  
        filterArray: [],
        productArray: [],
        currentProduct: {

        }
      };
    },
  
    methods: {   // logic that can be called from the template
  
      async getAllData(pageNumber, pageSize) {
        try {
          let responseProduct = await this.$http.get(`${this.$apiBaseUrl}/products/list`);
          this.productArray = await responseProduct.data;
  
        } catch (exception) {
          console.log(exception);
        }
      },

      async getAllDataWithFilters(pageNumber, pageSize) {
        try {
          // concatenate the filterArray into a string with commas
          let filterString = this.filterArray.join(',');
          let responseProduct = await this.$http.get(`${this.$apiBaseUrl}/products/categories/` + filterString);
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
          let responseProduct = await this.$http.get(`${this.$apiBaseUrl}/products/show/` + this.$props.id);
          this.currentProduct = responseProduct.data;
  
        } catch (ex) {
          console.log(ex);
        }
      },

      async orderProduct(productID, paymentMethod) {
        let userID = null;
        try {
          let responseUser = await this.$http.get(`${this.$apiBaseUrl}/auth/id`);
          userID = responseUser.data;
          if (userID === "Authentication required") {
            alert("You are not logged in!");
            return;
          }
        } catch (ex) {
          console.log(ex);
        }
        try {
          let responseProduct = await this.$http.get(`${this.$apiBaseUrl}/products/order/` + userID + "/" + this.$props.id + "/" + paymentMethod);
          alert("Product ordered successfully! You will receive an email for the payment.");
          this.$router.push('/products/list/all');
  
        } catch (ex) {
          console.log(ex);
        }
      },

      async sendEditRequest() {
        try {
          if (this.$props.id === "all" || this.$props.id === "0") {
            // add new product
            let responseProduct = await this.$http.post(`${this.$apiBaseUrl}/products/add`,
              {
                ProductName: this.currentProduct.ProductName,
                Category: this.currentProduct.Category,
                Description: this.currentProduct.Description,
                Price: this.currentProduct.Price,
                Quantity: this.currentProduct.Quantity,
                DueDate: this.currentProduct.DueDate
              }
            );
            alert("Product edited successfully!");
            this.$router.push('/products/list/all');
          }
          else {
            // edit existing product
          }
        } catch (ex) {
          console.log(ex);
        }
      },


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
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Common Styles */
h1 {
  color: #2c3e50;
  margin-bottom: 20px;
  font-weight: 600;
}

h3, h4 {
  color: #34495e;
  margin-bottom: 15px;
}

a {
  color: #3498db;
  text-decoration: none;
  font-weight: 500;
}

a:hover {
  text-decoration: underline;
}

/* Product Details Page */
.product-details {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.product-header {
  padding: 20px;
  background-color: #f8f9fa;
  border-bottom: 1px solid #eaeaea;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.badge {
  background-color: #27ae60;
  color: white;
  padding: 5px 12px;
  border-radius: 20px;
  font-size: 0.9rem;
}

.product-info {
  padding: 20px;
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 30px;
}

.product-description p {
  margin-bottom: 15px;
  line-height: 1.6;
  color: #555;
}

.vendor-info {
  font-style: italic;
  color: #7f8c8d;
}

.product-meta {
  background-color: #f8f9fa;
  padding: 20px;
  border-radius: 6px;
  border: 1px solid #eaeaea; /* Add border */
}

.meta-item {
  margin-bottom: 15px;
  display: flex;
  justify-content: space-between;
}

.label {
  font-weight: 600;
  color: #7f8c8d;
}

.value {
  font-weight: 600;
  color: #2c3e50;
}

.payment-section {
  padding: 20px;
  background-color: #f8f9fa;
}

.payment-card {
  background-color: white;
  border-radius: 8px;
  border: 1px solid #ddd; /* Replace box-shadow with border */
  padding: 25px;
}

.payment-methods {
  margin-top: 20px;
}

.radio-group {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 20px;
}

.radio-option {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.radio-label {
  margin-left: 8px;
}

.payment-button {
  padding: 12px 24px;
  border-radius: 4px;
  font-weight: 600;
  width: 100%;
  /*transition: background-color 0.2s;*/
}

.payment-button:disabled {
  background-color: #95a5a6;
  cursor: not-allowed;
}

/* Products List Page */
.filter-section {
  margin-bottom: 30px;
  background-color: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  border: 1px solid #ddd; /* Replace box-shadow with border */
}

.filter-options {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
}

.filter-checkbox {
  display: flex;
  align-items: center;
  background-color: white;
  padding: 8px 15px;
  border-radius: 20px;
  border: 1px solid #ddd; /* Replace box-shadow with border */
  cursor: pointer;
}

.checkbox-label {
  margin-left: 8px;
}

.filter-button {
  margin-left: auto;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
}

.product-card {
  background-color: white;
  border-radius: 8px;
  border: 1px solid #ddd; /* Replace box-shadow with border */
  overflow: hidden;
  /* Removed: transition: transform 0.2s, box-shadow 0.2s; */
}

.product-card:hover {
  /* Removed: transform: translateY(-5px); */
  /* Removed: box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15); */
  border: 1px solid #aaa; /* Darker border on hover instead of shadow */
}

.product-link {
  display: block;
  padding: 20px;
  color: inherit;
  text-decoration: none;
}

.product-link:hover {
  text-decoration: none;
}

.product-name {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 15px;
  color: #2c3e50;
}

.product-details {
  background-color: #fff;
  border-radius: 8px;
  border: 1px solid #ddd; /* Replace box-shadow with border */
  overflow: hidden;
}

.product-price {
  font-weight: 700;
  color: #27ae60;
}

.product-quantity {
  color: #7f8c8d;
}

.product-date {
  font-size: 0.9rem;
  color: #95a5a6;
  padding-top: 10px;
  border-top: 1px solid #eee;
}
</style>