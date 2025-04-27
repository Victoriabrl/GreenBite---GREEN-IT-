<template>
    <div class="container">
        <!-- Vendor Details Page -->
        <div v-if="action === 'show'" class="vendor-details">
            <div class="vendor-header">
                <h1>{{ currentVendor.BusinessName }}</h1>
                <span class="badge">Vendor</span>
            </div>
            
            <div class="vendor-info">
                <div class="vendor-description">
                    <p>{{ currentVendor.BusinessDescription }}</p>
                    <div class="vendor-rating">
                        <span class="label">Rating:</span>
                        <span class="value">{{ currentVendor.Rating }} ★</span>
                    </div>
                </div>
                
                <div class="vendor-meta">
                    <div class="meta-item">
                        <span class="label">Address:</span>
                        <span class="value">{{ currentVendor.BusinessAddress }}</span>
                    </div>
                    <div class="meta-item">
                        <span class="label">Email:</span>
                        <span class="value">{{ currentVendor.user_email }}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Vendors List Page -->
        <div v-if="action === 'list'" class="vendors-page">
            <div class="vendors-section">
                <h1>Our Vendors</h1>
                <p class="section-description">Discover local businesses committed to reducing food waste</p>
                
                <div class="vendors-grid">
                    <div v-for="vendor of vendorArray" v-bind:key="vendor.VendorID" class="vendor-card">
                        <a :href="'/#/vendors/show/' + vendor.VendorID" class="vendor-link">
                            <div class="vendor-name">{{ vendor.BusinessName }}</div>
                            <div class="vendor-short-description">
                                {{ vendor.BusinessDescription }}
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
        name: 'Vendors',
        props: ['action', 'id'],
        data() {
                return {
                        pageNumber: 1,
                        pageSize: 30,
                        numberOfPages: 0,
                        vendorArray: [],
                        currentVendor: {}
                };
        },

        methods: {
                async getAllData(pageNumber, pageSize) {
                        try {
                                let responseVendor = await this.$http.get(`${this.$apiBaseUrl}/vendors/list`);
                                this.vendorArray = await responseVendor.data;
                        } catch (exception) {
                                console.log(exception);
                        }
                },

                async refreshCurrentVendor() {
                        if (this.$props.id === "all" || this.$props.id === "0") {
                                this.currentVendor = {};
                                return;
                        }
                        try {
                                let responseVendor = await this.$http.get(`${this.$apiBaseUrl}/vendors/show/` + this.$props.id);
                                this.currentVendor = responseVendor.data;
                        } catch (ex) {
                                console.log(ex);
                        }
                }
        },

        watch: {
                id: function(newId, oldId) {
                        this.refreshCurrentVendor();
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

        created() {
                this.getAllData();
                this.refreshCurrentVendor();
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

.section-description {
    color: #7f8c8d;
    margin-bottom: 30px;
    font-size: 1.1rem;
    text-align: center;
}

/* Vendor Details Page */
.vendor-details {
  background-color: #fff;
  border-radius: 8px;
  border: 1px solid #ddd; /* Replace box-shadow with border */
  overflow: hidden;
}

.vendor-header {
    padding: 20px;
    background-color: #f8f9fa;
    border-bottom: 1px solid #eaeaea;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.badge {
    background-color: #3498db;
    color: white;
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 0.9rem;
}

.vendor-info {
    padding: 20px;
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 30px;
}

.vendor-description p {
    margin-bottom: 15px;
    line-height: 1.6;
    color: #555;
}

.vendor-rating {
    display: flex;
    align-items: center;
    margin-top: 20px;
    gap: 10px;
}

.vendor-meta {
    background-color: #f8f9fa;
    padding: 20px;
    border-radius: 6px;
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

.vendor-products-section {
    padding: 20px;
    background-color: #f8f9fa;
    border-top: 1px solid #eaeaea;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.view-all-link {
    background-color: #3498db;
    color: white;
    padding: 8px 15px;
    border-radius: 4px;
    font-size: 0.9rem;
}

.view-all-link:hover {
    background-color: #2980b9;
    text-decoration: none;
}

/* Vendors List Page */
.vendors-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}

.vendor-card {
  background-color: white;
  border-radius: 8px;
  border: 1px solid #ddd; /* Replace box-shadow with border */
  overflow: hidden;
  height: 180px;
  /* Removed: transition: transform 0.2s, box-shadow 0.2s; */
}

.vendor-card:hover {
  /* Removed: transform: translateY(-5px); */
  /* Removed: box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15); */
  border: 1px solid #aaa; /* Darker border on hover instead of shadow */
}

.vendor-link {
    display: block;
    padding: 20px;
    color: inherit;
    text-decoration: none;
    height: 100%;
}

.vendor-link:hover {
    text-decoration: none;
}

.vendor-name {
    font-size: 1.3rem;
    font-weight: 600;
    margin-bottom: 15px;
    color: #2c3e50;
}

.vendor-rating-display {
    margin-bottom: 15px;
    font-weight: 600;
}

.stars {
    color: #f39c12;
}

.vendor-short-description {
    color: #7f8c8d;
    line-height: 1.5;
    font-size: 0.95rem;
}
</style>