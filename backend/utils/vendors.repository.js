require('dotenv').config();

let path = __dirname + "\\db.include.js";
pool = require(path);


module.exports = {
    getBlankGame() {
        return {
            "VendorID": 0,
            "UserID": 0,
            "BusinessName": "xxx",
            "BusinessDescription": "xxx",
            "BusinessAddress": "xxx",
            "Website": "xxx",
            "Logo": "xxx",
            "IsVerified": 0
        };
    },

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
    }

};
