const express = require('express');
const router = express.Router();
const productsRepo = require('../utils/products.repository');

router.get('/list', productsListAction);
router.get('/show/:ProductID', productsShowAction);
router.get('/categories/:Categories', productsCategoriesAction);


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


module.exports = router;