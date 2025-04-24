<template>
  <div class="hello">
    <header>
      <h1>GreenBite</h1>
      <p class="tagline">Connecting eco-vendors with conscious consumers</p>
    </header>
    
    <section class="hero">
      <div class="hero-content">
        <h2>Reduce Food Waste, Save Money</h2>
        <p>Purchase surplus fruits and vegetables directly from local eco-friendly vendors</p>
        <div class="cta-buttons">
          <a href="#/products/list/all/" class="btn primary">Shop Now</a>
          <a href="#/profile/register" class="btn secondary">Sell Produce</a>
        </div>
      </div>
    </section>
    
    <section class="features">
      <div class="feature">
        <div class="icon">🌱</div>
        <h3>Eco-Friendly</h3>
        <p>Reduce food waste and support sustainable practices</p>
      </div>
      <div class="feature">
        <div class="icon">💰</div>
        <h3>Great Value</h3>
        <p>Get quality produce at reduced prices</p>
      </div>
      <div class="feature">
        <div class="icon">🚜</div>
        <h3>Support Local</h3>
        <p>Connect directly with farmers in your community</p>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  data() {
    return {
      // We'll keep data minimal to reduce processing needs
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
/* Using system fonts to reduce external requests */
* {
  box-sizing: border-box;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}

.hello {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  color: #333;
}

header {
  padding: 20px 0;
  text-align: center;
}

h1 {
  font-size: 2.5rem;
  color: #2c8c3c;
  margin-bottom: 5px;
}

.tagline {
  font-size: 1.1rem;
  color: #666;
}

.hero {
  background-color: #f4f9f4;
  padding: 60px 20px;
  border-radius: 8px;
  margin: 20px 0;
  text-align: center;
}

h2 {
  font-size: 2rem;
  margin-bottom: 15px;
  color: #2c8c3c;
}

.cta-buttons {
  margin-top: 30px;
}

.btn {
  padding: 12px 24px;
  border-radius: 6px;
  font-size: 1rem;
  cursor: pointer;
  margin: 0 10px;
  border: none;
}

.primary {
  background-color: #2c8c3c;
  color: white;
}

.secondary {
  background-color: white;
  color: #2c8c3c;
  border: 1px solid #2c8c3c;
}

.features {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  margin: 40px 0;
}

.feature {
  flex: 1;
  min-width: 250px;
  padding: 20px;
  text-align: center;
  margin: 10px;
  background-color: #f9f9f9;
  border-radius: 8px;
}

.icon {
  font-size: 2.5rem;
  margin-bottom: 15px;
}

h3 {
  color: #2c8c3c;
  margin-bottom: 10px;
}

/* Responsive adjustments to reduce data usage on smaller screens */
@media (max-width: 768px) {
  .features {
    flex-direction: column;
  }
  
  .feature {
    margin: 10px 0;
  }
}
</style>
