const express = require('express');
const router = express.Router();
const productsRepo = require('../utils/products.repository');

router.get('/list', productsListAction);
router.get('/show/:ProductID', productsShowAction);
router.get('/categories/:Categories', productsCategoriesAction);
router.get('/order/:userID/:productID/:paymentMethod', productsOrderAction);


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


module.exports = router;