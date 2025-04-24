<template>
    <header>
      <nav>
        <ul>
          <li>
            <a href="#/">
              <h2> <img src="../assets/logos/logo.webp" alt=" " width="100"> <b>GreenBite</b> </h2>
            </a>
          </li>
          <li>
            <a href="#/products/list/all/"> Marketplace</a>
          </li>
          <li>
            <a href="#/vendors/list/all/"> Vendors</a>
          </li>
        </ul>
  
        <ul @mouseover="active = true" @mouseleave="active = false" >
          <li>
            <div>
              Profile
              <!--<img src="../assets/logos/profile-logo.png" alt="" width="50">-->
  
              <ul v-if="active === true" class="profile-list">
                <li>
                  <a href="#/profile/myprofile"> My Profile</a>
                </li>
                <li>
                  <a href="#/profile/register"> Register</a>
                </li>
                <li>
                  <a href="#/profile/login"> Login</a>
                </li>
                <li>
                  <input type="button" @click="sendLogoutRequest('get', 'logout')" value="LOGOUT" class="btn primary"/>
                </li>
              </ul>
            </div>
          </li>
        </ul>
  
      </nav>
    </header>
</template>
  
  <script>
  export default {
    name: 'AppHeader',
  
    data () {
      return {   // variables that can be used in the template
        active: false
        }
    },
  
    methods: {
        async sendLogoutRequest(method, endpoint, params) {
        try {
          this.$router.push('/profile/login');
          let response = null;
          response = await this.$http.get("http://localhost:9000/api/auth/"+endpoint);
          this.msg = JSON.stringify(response.data);
          this.getUserRole();
        } catch (error) {
          console.log(ex)
        }
      }
    }
  };
  </script>
  
  <style scoped>
    header {
      background-color: #4b5861;
      padding-top: 10px;
      color: white;
      text-align: left;
    }
  
    nav {
      margin-left: 50px;
      margin-right: 50px;
      display: flex;
      justify-content: space-between;
    }
  
    nav ul {
      list-style: none;
      display: flex;
      flex-wrap: wrap;
      gap: 40px;
      align-items: center;
    }
  
    a {
      color: white;
      text-decoration: none;
    }
  
    div img {
      margin-right: 10px;
      margin-left: 10px;
    }
  
    .profile-list {
      position: absolute;
      right: 0;
      background-color: black;
      padding: 20px;
      margin-top: 10px;
      border-radius: 5px;
      display: flex;
      flex-direction: column;
      gap: 20px;
      z-index: 100;
    }
  
  </style>
  