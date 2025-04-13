<template>
    <div>
        <div v-if="action === 'show'">
            <h1>Vendor: {{ currentVendor.BusinessName }}</h1>
            <p>{{ currentVendor.Description }}</p>
            <p>Rating: {{ currentVendor.AverageRating }}</p>
            
            {{ currentVendor }}
        </div>

        <!-- v-if is a conditional rendering -->
        <div v-if="action === 'list'">
            <h1>Vendors List</h1>

            <ul class="vendors-list">
                <li v-for="vendor of vendorArray" v-bind:key="vendor.VendorID" class="zoom-hover">
                    <a :href="'/#/vendors/show/' + vendor.VendorID">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th colspan="3">
                                        {{ vendor.BusinessName }}
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
                {{ vendorArray }}
            </ul>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Vendors',
    props: ['action', 'id'],  // properties that can be passed to the component
    // action: show, list
    // id: vendor_id
    data() {
        return {
            pageNumber: 1,
            pageSize: 30,
            numberOfPages: 0,

            vendorArray: [],

            currentVendor: {
                // Default empty vendor object
            }
        };
    },

    methods: {
        async getAllData(pageNumber, pageSize) {
            try {
                let responseVendor = await this.$http.get('http://localhost:9000/api/vendors/list');
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
                let responseVendor = await this.$http.get("http://localhost:9000/api/vendors/show/" + this.$props.id);
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

    /************ VENDORS LIST ************/
    .vendors-list {
        margin: auto;
        margin-top: 20px;
        display: flex;
        flex-wrap: wrap;
        flex-direction: row;
        align-items: center;
        justify-content: center;
        text-align: center;
        max-width: 1300px;
        list-style-type: none;
    }

    .vendors-list li {
        margin: 0 20px 20px;
        text-align: center;
        position: relative;
        max-width: 200px;
    }
    
    .vendors-list li img {
        max-width: 100px;
        max-height: 100px;
    }

    .vendors-list tbody {
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

    table {
        width: 80%;
        margin: 20px auto;
    }
</style>