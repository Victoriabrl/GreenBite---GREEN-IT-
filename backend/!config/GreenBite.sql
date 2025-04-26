DROP DATABASE IF EXISTS GreenBite;
CREATE DATABASE IF NOT EXISTS GreenBite;
USE GreenBite;
-- USE sql7775541;



-- Drop existing tables if they exist
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Vendors;
DROP TABLE IF EXISTS Users;

-- Table for Users
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(100) NOT NULL UNIQUE,
    user_password VARCHAR(100),
    user_created DATETIME,
    user_role ENUM('ADMIN', 'USER', 'VENDOR') NOT NULL
);

-- Table for Vendors
CREATE TABLE Vendors (
    VendorID INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    BusinessName VARCHAR(100) NOT NULL,
    BusinessDescription TEXT,
    BusinessAddress VARCHAR(255) NOT NULL,
    Website VARCHAR(100),
    IsVerified BOOLEAN DEFAULT FALSE,
    RegistrationDate DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table for Products
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    VendorID INT NOT NULL,
    Category ENUM('Vegetable', 'Fruit', 'Dairy', 'Meat', 'Grain', 'Snack') NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    Quantity DECIMAL(10, 2) NOT NULL DEFAULT 0,
    IsAvailable BOOLEAN DEFAULT TRUE,
    CreatedAt DATETIME,
    -- due date will be set in INSERT statements
    DueDate DATETIME,
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID) ON DELETE CASCADE
);

-- Table for Orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    ProductID INT NOT NULL,
    OrderDate DATETIME,
    PaymentMethod ENUM('Credit_Card', 'Debit_Card', 'PayPal') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- Table for Reviews
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    VendorID INT NOT NULL,
    user_id INT NOT NULL,
    Rating TINYINT NOT NULL,
    CONSTRAINT chk_rating CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate DATETIME,
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE KEY (VendorID, user_id)
);










-- Insert data into Users table
INSERT INTO users (user_name, user_email, user_password, user_created, user_role) VALUES
    ('John Doe', 'john.doe@example.com', SHA2(CONCAT(now(), 'password123'), 224), now(), 'VENDOR'),
    ('Jane Smith', 'jane.smith@example.com', SHA2(CONCAT(now(), 'secretpass'), 224), now(), 'VENDOR'),
    ('Emily Clark', 'emily.clark@example.com', SHA2(CONCAT(now(), 'mypassword'), 224), now(), 'VENDOR'),
    ('Sarah Lee', 'sarah.lee@example.com', SHA2(CONCAT(now(), 'letmein'), 224), now(), 'VENDOR'),
    ('Michael Brown', 'michael.brown@example.com', SHA2(CONCAT(now(), 'adminpass'), 224), now(), 'ADMIN'),
    ('Robert Wilson', 'robert.wilson@example.com', SHA2(CONCAT(now(), 'pass123'), 224), now(), 'VENDOR'),
    ('Lisa Anderson', 'lisa.anderson@example.com', SHA2(CONCAT(now(), 'secure456'), 224), now(), 'VENDOR'),
    ('David Chen', 'david.chen@example.com', SHA2(CONCAT(now(), 'chen789'), 224), now(), 'VENDOR'),
    ('Maria Garcia', 'maria.garcia@example.com', SHA2(CONCAT(now(), 'maria123'), 224), now(), 'VENDOR'),
    ('James Johnson', 'james.johnson@example.com', SHA2(CONCAT(now(), 'jj2024'), 224), now(), 'VENDOR'),
    ('Emma Davis', 'emma.davis@example.com', SHA2(CONCAT(now(), 'emma456'), 224), now(), 'VENDOR'),
    ('Thomas White', 'thomas.white@example.com', SHA2(CONCAT(now(), 'white789'), 224), now(), 'USER'),
    ('Sophie Martin', 'sophie.martin@example.com', SHA2(CONCAT(now(), 'sophie123'), 224), now(), 'USER'),
    ('Kevin Taylor', 'kevin.taylor@example.com', SHA2(CONCAT(now(), 'taylor456'), 224), now(), 'USER'),
    ('Anna Miller', 'anna.miller@example.com', SHA2(CONCAT(now(), 'miller789'), 224), now(), 'USER')
;

-- Insert data into Vendors table
INSERT INTO Vendors (user_id, BusinessName, BusinessDescription, BusinessAddress, Website, RegistrationDate) VALUES
    (1, 'EcoMart', 'Eco-friendly products for daily use', '123 Elm St', 'www.ecomart.com', NOW()),
    (2, 'GreenGoods', 'Sustainable and organic goods', '456 Oak St', 'www.greengoods.com', NOW()),
    (3, 'NatureNest', 'Natural and eco-friendly products', '789 Pine St', 'www.naturenest.com', NOW()),
    (4, 'EcoEssentials', 'Essential eco-friendly items', '321 Maple St', 'www.ecoessentials.com', NOW()),
    (6, 'GreenLife', 'Eco-friendly lifestyle products', '987 Birch St', 'www.greenlife.com', NOW()),
    (7, 'EcoHaven', 'Your haven for eco-friendly goods', '111 Spruce St', 'www.ecohaven.com', NOW()),
    (8, 'SustainStore', 'Sustainable products for everyone', '222 Willow St', 'www.sustainstore.com', NOW()),
    (9, 'EarthlyGoods', 'Goods that care for the Earth', '333 Redwood St', 'www.earthlygoods.com', NOW()),
    (10, 'EcoChoice', 'Your choice for eco-friendly products', '444 Ash St', 'www.ecochoice.com', NOW()),
    (11, 'PlanetCare', 'Caring for the planet with eco-products', '654 Cedar St', 'www.planetcare.com', NOW())

;

-- Insert data into Products table
INSERT INTO Products (VendorID, Category, ProductName, Description, Price, Quantity, CreatedAt, DueDate) VALUES
    (1, 'Vegetable', 'Carrots', 'Fresh carrots', 2.99, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (1, 'Fruit', 'Apples', 'Crisp and juicy apples', 3.99, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (1, 'Dairy', 'Milk', 'Fresh milk', 4.99, 2, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (2, 'Meat', 'Grass-fed Beef', 'Premium grass-fed beef', 12.99, 5, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (2, 'Grain', 'Rice', 'High-quality rice', 6.99, 3, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (2, 'Snack', 'Granola Bars', 'Healthy granola bars', 1.99, 0.5, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (3, 'Vegetable', 'Spinach', 'Fresh spinach', 2.49, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (3, 'Fruit', 'Bananas', 'Sweet bananas', 1.99, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (3, 'Dairy', 'Cheese', 'Delicious cheese', 5.99, 0.3, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (4, 'Meat', 'Free-range Chicken', 'Tender free-range chicken', 9.99, 0.7, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (4, 'Grain', 'Quinoa', 'Nutritious quinoa', 7.99, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (4, 'Snack', 'Trail Mix', 'Tasty trail mix', 3.99, 2, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (5, 'Vegetable', 'Potatoes', 'Fresh potatoes', 1.99, 2, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (5, 'Fruit', 'Oranges', 'Juicy oranges', 4.49, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (5, 'Dairy', 'Yogurt', 'Creamy yogurt', 3.49, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (6, 'Meat', 'Wild-caught Salmon', 'Fresh wild-caught salmon', 14.99, 2, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (6, 'Grain', 'Oats', 'Healthy oats', 4.99, 3, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (6, 'Snack', 'Popcorn', 'Light popcorn', 2.49, 4, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (7, 'Vegetable', 'Broccoli', 'Fresh broccoli', 2.99, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (7, 'Fruit', 'Strawberries', 'Sweet strawberries', 5.99, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (7, 'Dairy', 'Butter', 'Rich butter', 4.49, 8, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (8, 'Meat', 'Pork', 'Tender pork', 11.99, 7, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (8, 'Grain', 'Barley', 'Nutritious barley', 3.99, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (8, 'Snack', 'Cookies', 'Delicious cookies', 2.99, 3, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (9, 'Vegetable', 'Peppers', 'Fresh peppers', 3.49, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (9, 'Fruit', 'Grapes', 'Sweet grapes', 4.99, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (9, 'Dairy', 'Cream', 'Smooth cream', 3.99, 9, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (10, 'Meat', 'Turkey', 'Juicy turkey', 13.99, 5, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (10, 'Grain', 'Wheat', 'High-quality wheat', 5.99, 2, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY)),
    (10, 'Snack', 'Chips', 'Crispy chips', 2.49, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY))
;

-- Insert data into Reviews table
INSERT INTO Reviews (VendorID, user_id, Rating, Comment, ReviewDate) VALUES
    (1, 1, 5, 'Great product! Very eco-friendly.', NOW()),
    (2, 2, 4, 'Good quality, but a bit expensive.', NOW()),
    (3, 3, 5, 'Love this rice!', NOW()),
    (4, 4, 4, 'Comfortable and sustainable.', NOW()),
    (5, 5, 5, 'Works perfectly and eco-friendly.', NOW()),
    (6, 6, 4, 'Good tent, but could be cheaper.', NOW()),
    (7, 7, 5, 'My kids love these toys!', NOW()),
    (8, 8, 5, 'Perfect for my notes.', NOW()),
    (9, 9, 4, 'Cleans well and smells great.', NOW()),
    (10, 10, 5, 'High-quality utensils.', NOW())
;




ALTER TABLE users MODIFY user_password VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE users MODIFY user_name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;