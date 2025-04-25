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
            console.log("Products FETCHED: " + rows[0].length);
            // modify the date format to YYYY-MM-DD
            rows[0].forEach((row) => {
                row.DueDate = new Date(row.DueDate).toISOString().split('T')[0];
            });
            return rows[0];
            
        } catch (err) {
            console.log(err);
            throw err;
        }
    },

    async getProductById(id) {
        try {
            let sql = "CALL get_product_by_id(?)";
            const [rows, fields] = await pool.execute(sql, [id]);
            console.log("Product FETCHED: " + rows[0][0].length + " for id: " + id);
            // modify the date format to YYYY-MM-DD
            rows[0].forEach((row) => {
                row.DueDate = new Date(row.DueDate).toISOString().split('T')[0];
            });
            return rows[0][0];
            
        } catch (err) {
            console.log(err);
            throw err;
        }
    },

    async getProductsByCategories(Categories) {
        let sql = "CALL get_products_by_category(?)";
        const [rows, fields] = await pool.execute(sql, [Categories]);
        console.log("Products FETCHED: " + rows[0].length + " for categories: " + Categories);
        // modify the date format to YYYY-MM-DD
        rows[0].forEach((row) => {
            row.DueDate = new Date(row.DueDate).toISOString().split('T')[0];
        });
        return rows[0];
    },

    async orderProduct(userId, productId, paymentMethod) {
        let sql = "CALL place_order(?, ?, ?)";
        const [rows, fields] = await pool.execute(sql, [userId, productId, paymentMethod]);
        console.log("Order PLACED: " + rows[0].length + " for user: " + userId + " and product: " + productId);
        return rows[0][0];
    },

    async addProduct(p_vendor_id, p_category, p_product_name, p_description, p_price, p_quantity, p_due_date ) {
        let sql = "CALL add_product(?, ?, ?, ?, ?, ?, ?)";
        const [okPacket, fields] = await pool.execute(sql, [p_vendor_id, p_category, p_product_name, p_description, p_price, p_quantity, p_due_date]);
        console.log("Product ADDED: " + JSON.stringify(okPacket));//rows[0].length + " for vendor: " + VendorID);
        return okPacket.insertId;
    }
};
