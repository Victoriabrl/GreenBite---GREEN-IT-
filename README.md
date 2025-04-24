# GreenBite

Mini-Hackathon Project: "The greenest website" <br/>
Objective: design, implement and analyze the carbon footprint of a website. The goal is to create a website that is as environmentally friendly as possible, while minimizing its environmental impact.


## The project

Brief description of the different parts of the site and the functionalities.

## Configuration

- Install [node.js](https://nodejs.org/fr/download) (if not done before)
- In the ```backend\!config``` folder
  - Run the 2 sql scripts ```GreenBite.sql``` to create the tables of the database & ```GreenBite_functions.sql``` to create the functions, procedures...
  - Copy the .env file to the root of the ```backend``` folder & update the ```DB_PASS=yourMySQLpassword``` field to your actual MySQL root user password
- Run ```npm install```


## How to run
Frontend
```bash
cd frontend
npm run dev
```

Backend
```bash
cd backend
node server.js
```