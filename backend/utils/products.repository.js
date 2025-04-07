require('dotenv').config();

let path = __dirname + "\\db.include.js";
pool = require(path);


module.exports = {
    getBlankGame() {
        return {
            "ProductID": 0,
            "VendorID": 0,
            "CategoryID": 0,
            "ProductName": "xxx",
            "Description": "xxx",
            "Price": 0.00,
            "StockQuantity": 0,
            "IsEcoFriendly": 1,
            "EcoRating": 5,
            "ImageURL": "xxx",
            "CreatedAt": c,
            "DueDate": " ",
        };
    },

    async getAllProducts() {
        try {
            let sql = "CALL get_products_sorted_by_due_date()";
            const [rows, fields] = await pool.execute(sql);
            console.log("Products FETCHED: " + rows.length);
            return rows;
            
        } catch (err) {
            console.log(err);
            throw err;
        }
    },

    async getProductById(id) {
        try {
            let sql = "CALL get_product_by_id(?)";
            const [rows, fields] = await pool.execute(sql, [id]);
            console.log("Product FETCHED: " + rows[0].length + " for id: " + id);
            return rows[0];
            
        } catch (err) {
            console.log(err);
            throw err;
        }
    }

};
