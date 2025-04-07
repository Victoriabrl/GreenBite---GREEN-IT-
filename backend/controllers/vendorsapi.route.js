const express = require('express');
const router = express.Router();
const vendorsRepo = require('../utils/vendors.repository');

router.get('/list', vendorsListAction);
router.get('/show/:VendorID', vendorsShowAction);


async function vendorsListAction(request, response) {
    var vendors = await vendorsRepo.getAllVendors();
    response.send(JSON.stringify(vendors));
}

async function vendorsShowAction(request, response) {
    var oneVendor = await vendorsRepo.getVendorById(request.params.VendorID);
    response.send(JSON.stringify(oneVendor));
}


module.exports = router;