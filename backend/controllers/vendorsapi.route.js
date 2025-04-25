const express = require('express');
const router = express.Router();
const vendorsRepo = require('../utils/vendors.repository');

router.get('/list', vendorsListAction);
router.get('/show/:VendorID', vendorsShowAction);
router.get('/products/:UserID', vendorsProductsAction);


async function vendorsListAction(request, response) {
    var vendors = await vendorsRepo.getAllVendors();
    response.send(JSON.stringify(vendors));
}

async function vendorsShowAction(request, response) {
    var oneVendor = await vendorsRepo.getVendorById(request.params.VendorID);
    response.send(JSON.stringify(oneVendor));
}

async function vendorsProductsAction(request, response) {
    var products = await vendorsRepo.getVendorProductsByUserId(request.params.UserID);
    response.send(JSON.stringify(products));
}


module.exports = router;