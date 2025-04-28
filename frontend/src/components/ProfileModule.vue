<template>
  <div>

    <!--{{ this.role }}-->

    <div v-if="action === 'myprofile'">
      <!-- If the user is not logged in -->
      <div v-if="this.role === 'GUEST'">
        <h1 class="component-h1">You don't have a profile yet?</h1>
        <a href="#/profile/register">Click here</a> to create your profile.
        <br><br><br><br><br><br><br><br><br><br><br><br>
      </div>

      <!-- If the user is logged in -->
      <div v-else="this.role !== 'GUEST'">

        <div>
          <h1 class="component-h1">Your User Space</h1>
          <p>Display the products you are currently buying</p>
          <button @click="getProductsData()" class="btn primary">See Products</button>

          <div v-if="this.prodtuctsBoughtArray.length > 0">
            <h1 class="component-h1">Your Bought Products</h1>
            <div class="products-section">
              <div class="products-grid">
                <div v-for="product of prodtuctsBoughtArray" 
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
            <br><br>
          </div>

          <hr>
        </div>

        <div v-if="this.role === 'VENDOR'">
          <h1 class="component-h1">Your Vendor Space</h1>
          <p>Display the products you are currently selling // Add a new product</p>
          <button @click="getProductsData()" class="btn primary">See Products</button>
          <a href="#/products/edit/0" class="btn secondary">Add Product</a>

          <div v-if="this.prodtuctsSellingArray.length > 0">
            <h1 class="component-h1">Products you are selling</h1>
            <div class="products-section">
              <div class="products-grid">
                <div v-for="product of prodtuctsSellingArray" 
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
            <br><br>
          </div>

          <hr>
        </div>

        <h1 class="component-h1">Your Profile, {{currentUser.user_name}}</h1>
        <!--{{ currentUser }}-->
        <div class="show-user">
            <table class="table table-striped table-bordered">
                <tbody>
                    <tr>
                        <th>User ID</th>
                        <td>{{ currentUser.user_id }}</td>
                    </tr>
                    <tr>
                        <th>Name</th>
                        <td>{{ currentUser.user_name }}</td>
                    </tr>
                    <tr>
                        <th>Email</th>
                        <td>{{ currentUser.user_email }}</td>
                    </tr>
                    <tr>
                        <th>Role</th>
                        <td>{{ currentUser.user_role }}</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <br><br>
      </div>
    </div>


    <div v-if="action === 'register'">
      <h1 class="component-h1">Register</h1>
      <div class="form">
        <div class="form-group">
          <label for="username">Username:</label>
          <input type="text" class="form-control" id="username" name="username" v-model="currentUser.user_name">
          <br>
          <label for="email">Email:</label>
          <input type="email" class="form-control" id="email" name="email" v-model="currentUser.user_email">
          <p><small><em>Careful, if you apply to be a vendor, this email will be public.</em></small></p>
          <br/>
          <label for="password">Password:</label>
          <input type="password" class="form-control" id="password" name="password" v-model="currentUser.user_password">
          <br>
          <button type="submit" @click="sendAddRequest()" class="btn primary">Submit</button>
          <p> you already have an account? <a href="#/profile/login">Login</a></p>
        </div>
      </div>
    </div>


    <div v-if="action === 'login'">
      <h1 class="component-h1">Login</h1>
      <div class="form">
        <div class="form-group">
          <label for="username">Username:</label>
          <input type="text" class="form-control" id="username" name="username" required>
          <br>
          <label for="password">Password:</label>
          <input type="password" class="form-control" id="password" name="password" required>
          <br>
          <button type="submit" @click="submitAuth()" class="btn primary">Submit</button>
          <p> you don't have an account? <a href="#/profile/register">Register</a></p>
        </div>
      </div>
    </div>

    <div id="edit-error"></div>
  </div>
</template>


<script>
  export default {
    name: 'Authentication',
    props: ['action'],

    data() {
        return {
            role: '',
            prodtuctsSellingArray: [],
            prodtuctsBoughtArray: [],
            currentUser: {
                user_id: 0,
                user_name: '',
                user_email: '',
                user_role: ''
            }
        };
    },

    methods: {
      submitAuth() {
        const username = document.getElementById("username").value;
        const password = document.getElementById("password").value;
        this.sendRequest('post', 'login', { username: username, userpass: password });
      },

      async getUserRole() {
        try {
          let response = await this.$http.get(`${this.$apiBaseUrl}/auth/role`);
          this.role = response.data;
          // Call refreshCurrentUser after role is updated
          if (this.role !== 'GUEST') {
            await this.refreshCurrentUser();
          }
        } catch (ex) {
          console.log(ex);
        }
      },

      async refreshCurrentUser() {
        try {
          if (this.role && this.role !== 'GUEST') {
            let response = await this.$http.get(`${this.$apiBaseUrl}/auth/`+this.role.toLowerCase());
            this.currentUser = response.data;
          }
        } catch (error) {
          console.log(error);
        }
      },

      async sendRequest(method, endpoint, params) {
        let errorDiv = document.createElement("div");
        try {
          let response = null;
          if (method === "post") 
            response = await this.$http.post(`${this.$apiBaseUrl}/auth/`+endpoint, params);
          else
            response = await this.$http.get(`${this.$apiBaseUrl}/auth/`+endpoint);
          
          this.role = response.data.userRole;
          if (response.data.loginResult) {
            errorDiv.innerHTML = "Login successful";
            this.$router.push('/profile/myprofile');
          }
          else
            errorDiv.innerHTML = "Wrong username or password";
          //errorDiv.innerHTML = JSON.stringify(response.data).replace(/\"/g, "");
          errorDiv.style.color = "red";
          document.getElementById("edit-error").appendChild(errorDiv);
          // redirect to profile page

        } catch (error) {
          console.log(ex)

          errorDiv.innerHTML = "Wrong username or password";
          errorDiv.style.color = "red";
          document.getElementById("edit-error").appendChild(errorDiv);
        }
      },

      async sendRequest(method, endpoint, params) {
        let errorDiv = document.createElement("div");
        try {
          let response = null;
          if (method === "post") 
            response = await this.$http.post(`${this.$apiBaseUrl}/auth/`+endpoint, params);
          else
            response = await this.$http.get(`${this.$apiBaseUrl}/auth/`+endpoint);
          
          this.role = response.data.userRole;
          if (response.data.loginResult) {
            await this.refreshCurrentUser(); // Make sure user data is refreshed after login
            errorDiv.innerHTML = "Login successful";
            this.$router.push('/profile/myprofile');
          }
          else
            errorDiv.innerHTML = "Wrong username or password";
          errorDiv.style.color = "red";
          document.getElementById("edit-error").appendChild(errorDiv);

        } catch (error) { // Fixed variable name from 'ex' to 'error'
          console.log(error);
          errorDiv.innerHTML = "Wrong username or password";
          errorDiv.style.color = "red";
          document.getElementById("edit-error").appendChild(errorDiv);
        }
      },

      async sendAddRequest() {
        try {
            let response = await this.$http.post(`${this.$apiBaseUrl}/users/add` , {
                user_name: this.currentUser.user_name,
                user_email: this.currentUser.user_email,
                user_password: this.currentUser.user_password
            });

            let errorDiv = document.createElement("div");
            errorDiv.innerHTML = "Profile successfully created. You can now login";
            errorDiv.style.color = "red";
            document.getElementById("edit-error").appendChild(errorDiv);
        } catch (error) {
            console.log(error);
            let errorDiv = document.createElement("div");
            errorDiv.innerHTML = "Someone with that username/email already exists";
            errorDiv.style.color = "red";
            document.getElementById("edit-error").appendChild(errorDiv);
        }
      },

      async getProductsData() {
        try {
          if (this.role === 'VENDOR') {
            let response = await this.$http.get(`${this.$apiBaseUrl}/vendors/products/`+this.currentUser.user_id);
            this.prodtuctsSellingArray = response.data;
          }
          let response = await this.$http.get(`${this.$apiBaseUrl}/products/products/`+this.currentUser.user_id);
          this.prodtuctsBoughtArray = response.data;

        } catch (error) {
            console.log(error);
        }
      }
    },

    watch: {

      // if logout, call getUserRole 
      id: function(newId, oldId) {
        if (newRole !== 'GUEST') {
          this.refreshCurrentUser();
        }
      },
      action: function(newAction, oldAction) {
        if (newAction === "myprofile") {
          this.getUserRole(); // Call getUserRole instead of refreshCurrentUser directly
        }
        else
          document.getElementById("edit-error").innerHTML = "";
      }

    },

    created() {
      this.getUserRole(); // This will also call refreshCurrentUser when complete
    }
  }
</script>


<style scoped>
  .show-user {
      margin: auto;
      width: 80%;
      max-width: 800px;
  }

  .show-user table {
      width: 100%;
  }

  .btn {
    margin-bottom: 10px;
  }

  .form {
    display: flex;
    flex-direction: column;
    width: 100%;
    max-width: 500px;
    border: #42b983 3px solid;
    padding: 20px;
    margin: auto auto 20px;
  }



.products-section {
  width: 90%;  /* Adjust this value based on your preference */
  max-width: 1200px;  /* Prevents the grid from becoming too wide on large screens */
  margin: 0 auto;  /* This centers the container horizontally */
  padding: 20px 0;  /* Add some vertical padding */
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
}


.product-card {
  background-color: white;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid #ddd;
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
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
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