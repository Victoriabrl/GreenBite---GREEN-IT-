// populate object process.env from the file .env
const dotenv = require('dotenv');
dotenv.config();

// create express.js webapp
const express = require('express');
const app = express();
app.set("view engine", "ejs");
app.set("views", "views");
const PORT = process.env.PORT || process.env.WEB_PORT || 9000;
if (process.env.NODE_ENV !== 'production') {
    app.listen(PORT, '0.0.0.0', () => {
        console.log(`Server running on port ${PORT}`);
    });
}

// Export the Express app for Vercel
module.exports = app;


// *** MIDDLEWARES ***
// app.use(callbackFunction1, callbackFunction2, callbackFunction3)

// process form input (create request.body from POST data or json in the http request)
const bodyParser = require("body-parser");
app.use(bodyParser.json(), bodyParser.urlencoded({ extended: true }));

// allow serverside session storage
const session = require("express-session");
app.use(session({
    secret: process.env.SESSION_SECRET || "oaziudh8241024812AAAAAAAPAPAP09",
    saveUninitialized: false,
    cookie: { 
      maxAge: 1000 * 60 * 60 * 24,
      secure: process.env.NODE_ENV === 'production' // Use secure cookies in production
    },
    resave: false
}));

// Add error handling middleware
app.use((err, req, res, next) => {
  console.error('Global error handler:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'production' ? 'Something went wrong' : err.message
  });
});


// enable Cross Origin Resource Sharing (needed for cross-origin API)
const cors = require('cors');
app.use(cors({
    origin: [
        "http://localhost:8080", 
        "https://green-bite-green-it.vercel.app"
    ],
    credentials: true,
    methods: [ 'GET', 'POST' ]
})); 


// configure passport
const auth = require("./utils/user.auth");
auth.initializeAuthentications(app);
app.use("/auth", require("./controllers/auth.route"));


// *** ROUTES/CONTROLLERS ***

// setup default route
app.get('/', (request, response) => { // 'GET' or 'POST'...
    let clientIp = request.ip;
    response.send(`Hello, dear ${clientIp}. I am a nodejs website...`);
    response.end(); // optional
});

// setup additional routes
// app.use(routeBase, callback);

app.use("/static", express.static(__dirname + '/static'));

app.use("/api/vendors", require("./controllers/vendorsapi.route"));
app.use("/api/products", require("./controllers/productsapi.route"));
app.use("/api/users", require("./controllers/user.route"));
app.use("/api/auth", require("./controllers/auth.route"));