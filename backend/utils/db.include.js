const mysql = require('mysql2/promise');

// Configuration with proper error handling for serverless environment
const getDbConfig = () => {
  // Validate required environment variables
  const requiredVars = ['DB_HOST', 'DB_USER', 'DB_PASS', 'DB_DATABASE'];
  const missingVars = requiredVars.filter(varName => !process.env[varName]);
  
  if (missingVars.length > 0) {
    console.error(`Missing required environment variables: ${missingVars.join(', ')}`);
    throw new Error(`Database configuration incomplete: missing ${missingVars.join(', ')}`);
  }

  const config = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_DATABASE,
    // Add connection pool settings for serverless environment
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  };

  // Add SSL configuration for production database
  if (process.env.NODE_ENV === 'production') {
    config.ssl = {
      rejectUnauthorized: true
    };
  }

  return config;
};

// Create connection pool with error handling
try {
  const pool = mysql.createPool(getDbConfig());
  
  // Add pool error listener
  pool.on('error', (err) => {
    console.error('MySQL pool error:', err);
  });
  
  module.exports = pool;
} catch (error) {
  console.error('Failed to create MySQL connection pool:', error);
  // Export a dummy pool that will throw clear errors
  module.exports = {
    execute: () => {
      throw new Error('Database connection failed: ' + error.message);
    },
    getConnection: () => {
      throw new Error('Database connection failed: ' + error.message);
    }
  };
}