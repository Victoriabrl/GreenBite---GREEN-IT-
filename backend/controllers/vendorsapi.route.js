const express = require('express');
const router = express.Router();
const vendorsRepo = require('../utils/vendors.repository');

router.get('/list', vendorsListAction);


async function vendorsListAction(request, response) {
    var games = await vendorsRepo.getAllVendors();
    response.send(JSON.stringify(games));
}

module.exports = router;