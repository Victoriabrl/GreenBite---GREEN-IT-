# GreenBite


**Website link**: <a href="https://green-bite-green-it.vercel.app">GreenBit</a><br/>
**Mini-Hackathon Project**: "The greenest website" <br/>
**Objective**: design, implement and analyze the carbon footprint of a website. The goal is to create a website that is as environmentally friendly as possible, while minimizing its environmental impact.


## The project

GreenBite is an environmentally conscious website designed to demonstrate sustainable web development practices:

### Components

- **Frontend**: A lightweight, optimized Vue application that minimizes resource usage while providing a responsive user experience
- **Backend**: Node.js server with optimized API endpoints for efficient data processing
- **Database**: MySQL database with properly structured tables and optimized queries

### Key Features

- **Eco-friendly Design**: Minimalist UI with optimized images and reduced JavaScript usage
- **Performance Optimization**: Server-side rendering and efficient data loading strategies
- **Green Hosting Analysis**: Documentation of hosting choices to minimize environmental impact
- **Best Practices Showcase**: Implementation of sustainable web development techniques

### Technical Implementation

- Vue frontend with performance-optimized components
- Express.js backend with efficient routing
- MySQL database for structured data storage
- Environmental metrics tracking and analysis tools


## How to run (locally)

### Configuration

- Install [node.js](https://nodejs.org/fr/download) (if not done before)
- In the ```backend\!config``` folder
  - Run the 2 sql scripts ```GreenBite.sql``` to create the tables of the database & ```GreenBite_functions.sql``` to create the functions, procedures...
  - Copy the .env file to the root of the ```backend``` folder & update the ```DB_PASS=yourMySQLpassword``` field to your actual MySQL root user password
- Run ```npm install```

### Run
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
