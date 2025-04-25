const express = require('express');
const router = express.Router();
const auth = require("../utils/user.auth");
const userRepo = require("../utils/user.repository");
const productsRepo = require('../utils/products.repository');

router.get('/list', productsListAction);
router.get('/show/:ProductID', productsShowAction);
router.get('/categories/:Categories', productsCategoriesAction);
router.get('/order/:userID/:productID/:paymentMethod', productsOrderAction);
router.post('/add', auth.authorizeRequest("VENDOR"), productsAddAction);
//router.post('/update/:ProductID', auth.authorizeRequest("VENDOR"), productsUpdateAction);


async function productsListAction(request, response) {
    var products = await productsRepo.getAllProducts();
    response.send(JSON.stringify(products));
}

async function productsShowAction(request, response) {
    var oneProduct = await productsRepo.getProductById(request.params.ProductID);
    response.send(JSON.stringify(oneProduct));
}

async function productsCategoriesAction(request, response) {
    var products = await productsRepo.getProductsByCategories(request.params.Categories);
    response.send(JSON.stringify(products));
}

async function productsOrderAction(request, response) {
    var result = await productsRepo.orderProduct(request.params.userID, request.params.productID, request.params.paymentMethod);
    response.send(JSON.stringify(result));
}

async function productsAddAction(request, response) {
    try {
        if (!request.body) {
            return response.status(400).json({ error: 'No data provided in request body' });
        }

        let userID = JSON.stringify(request.user.user_id);
        let vendorID = await userRepo.getVendorIdFromUserId(userID);

        // log all the request body data
        console.log("VendorID: " + vendorID + " Category: " + request.body.Category + " ProductName: " + request.body.ProductName + " Description: " + request.body.Description + " Price: " + request.body.Price + " Quantity: " + request.body.Quantity + " DueDate: " + request.body.DueDate);

        let result = await productsRepo.addProduct(
            vendorID,
            request.body.Category,
            request.body.ProductName,
            request.body.Description,
            request.body.Price,
            request.body.Quantity,
            request.body.DueDate
        );
        response.send(JSON.stringify(result));

    } catch (error) {
        console.error("Error adding product:", error);
        response.status(500).send("Internal Server Error");
    }
}


module.exports = router;