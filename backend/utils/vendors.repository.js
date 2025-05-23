require('dotenv').config();

const path = require('path');
let dbPath = path.join(__dirname, "db.include.js");
pool = require(dbPath);


module.exports = {
    async getAllVendors() {
        try {
            let sql = "CALL get_all_vendors()";
            const [rows, fields] = await pool.execute(sql);
            console.log("Vendors FETCHED: " + rows[0].length);
            return rows[0];
            
        } catch (err) {
            console.log(err);
            throw err;
        }
    },

    async getVendorById(id) {
        try {
            let sql = "CALL get_vendor_by_id(?)";
            const [rows, fields] = await pool.execute(sql, [id]);
            console.log("Vendors FETCHED: " + rows[0][0].length + " for id: " + id);
            return rows[0][0];
            
        } catch (err) {
            console.log(err);
            throw err;
        }
    },

    async getVendorProductsByUserId(id) {
        try {
            let sql = "CALL get_vendor_products_by_user_id(?)";
            const [rows, fields] = await pool.execute(sql, [id]);
            console.log("Products FETCHED: " + rows[0].length + " for vendor id: " + id);
            return rows[0];
            
        } catch (err) {
            console.log(err);
            throw err;
        }
    }


};
