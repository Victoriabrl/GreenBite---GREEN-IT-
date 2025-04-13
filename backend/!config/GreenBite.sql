DROP DATABASE IF EXISTS GreenBite;
CREATE DATABASE IF NOT EXISTS GreenBite;
USE GreenBite;



-- Drop existing tables if they exist
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Vendors;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;

-- Table for Users
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(100) NOT NULL UNIQUE,
    user_password VARCHAR(100),
    user_created DATETIME,
    user_role ENUM('ADMIN', 'USER') NOT NULL
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
    RegistrationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Table for Categories
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT
);

-- Table for Products
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    VendorID INT NOT NULL,
    CategoryID INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    IsEcoFriendly BOOLEAN DEFAULT TRUE,
    EcoRating TINYINT CHECK (EcoRating BETWEEN 1 AND 5),
    ImageURL VARCHAR(255),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- default due date is 3 days from now
    DueDate DATETIME DEFAULT (CURRENT_TIMESTAMP + INTERVAL 3 DAY),
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID) ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Table for Orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    ShippingAddress VARCHAR(255) NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Table for Order Items (joining Orders and Products)
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Table for Reviews
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    user_id INT NOT NULL,
    Rating TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    UNIQUE KEY (ProductID, user_id)
);

















-- Trigger to update product ratings after a review is added
DROP TRIGGER IF EXISTS after_review_insert;
DELIMITER //
CREATE TRIGGER after_review_insert
AFTER INSERT ON Reviews
FOR EACH ROW
BEGIN
    UPDATE Products 
    SET EcoRating = (
        SELECT AVG(Rating) 
        FROM Reviews 
        WHERE ProductID = NEW.ProductID
    )
    WHERE ProductID = NEW.ProductID;
END //
DELIMITER ;

-- Trigger to update product ratings after a review is updated
DROP TRIGGER IF EXISTS after_review_update;
DELIMITER //
CREATE TRIGGER after_review_update
AFTER UPDATE ON Reviews
FOR EACH ROW
BEGIN
    UPDATE Products 
    SET EcoRating = (
        SELECT AVG(Rating) 
        FROM Reviews 
        WHERE ProductID = NEW.ProductID
    )
    WHERE ProductID = NEW.ProductID;
END //
DELIMITER ;

-- Trigger to update product ratings after a review is deleted
DROP TRIGGER IF EXISTS after_review_delete;
DELIMITER //
CREATE TRIGGER after_review_delete
AFTER DELETE ON Reviews
FOR EACH ROW
BEGIN
    UPDATE Products 
    SET EcoRating = (
        SELECT COALESCE(AVG(Rating), 0) 
        FROM Reviews 
        WHERE ProductID = OLD.ProductID
    )
    WHERE ProductID = OLD.ProductID;
END //
DELIMITER ;

-- Trigger to update stock quantity after order
DROP TRIGGER IF EXISTS after_order_item_insert;
DELIMITER //
CREATE TRIGGER after_order_item_insert
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Products
    SET StockQuantity = StockQuantity - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END //
DELIMITER ;

-- Trigger to restore stock quantity if an order is cancelled
DROP TRIGGER IF EXISTS after_order_status_update;
DELIMITER //
CREATE TRIGGER after_order_status_update
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Cancelled' AND OLD.Status != 'Cancelled' THEN
        UPDATE Products p
        JOIN OrderItems oi ON p.ProductID = oi.ProductID
        SET p.StockQuantity = p.StockQuantity + oi.Quantity
        WHERE oi.OrderID = NEW.OrderID;
    END IF;
END //
DELIMITER ;


-- Trigger to automatically delete products when due date is passed
DROP TRIGGER IF EXISTS delete_expired_products_trigger;
DELIMITER //
CREATE TRIGGER check_product_due_date
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.DueDate < NOW() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cannot update: Product due date has expired';
    END IF;
END //
DELIMITER ;

-- Event to regularly clean up expired products
DROP EVENT IF EXISTS delete_expired_products;
DELIMITER //
CREATE EVENT delete_expired_products
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM Products WHERE DueDate < NOW();
END //
DELIMITER ;










-- Insert data into Users table
INSERT INTO users (user_name, user_email, user_password, user_created, user_role) VALUES
    ('John Doe', 'john.doe@example.com', SHA2(CONCAT(now(), 'password123'), 224), now(), 'USER'),
    ('Jane Smith', 'jane.smith@example.com', SHA2(CONCAT(now(), 'secretpass'), 224), now(), 'USER'),
    ('Emily Clark', 'emily.clark@example.com', SHA2(CONCAT(now(), 'mypassword'), 224), now(), 'USER'),
    ('Sarah Lee', 'sarah.lee@example.com', SHA2(CONCAT(now(), 'letmein'), 224), now(), 'USER'),
    ('Michael Brown', 'michael.brown@example.com', SHA2(CONCAT(now(), 'adminpass'), 224), now(), 'ADMIN'),
    ('Robert Wilson', 'robert.wilson@example.com', SHA2(CONCAT(now(), 'pass123'), 224), now(), 'USER'),
    ('Lisa Anderson', 'lisa.anderson@example.com', SHA2(CONCAT(now(), 'secure456'), 224), now(), 'USER'),
    ('David Chen', 'david.chen@example.com', SHA2(CONCAT(now(), 'chen789'), 224), now(), 'USER'),
    ('Maria Garcia', 'maria.garcia@example.com', SHA2(CONCAT(now(), 'maria123'), 224), now(), 'USER'),
    ('James Johnson', 'james.johnson@example.com', SHA2(CONCAT(now(), 'jj2024'), 224), now(), 'USER'),
    ('Emma Davis', 'emma.davis@example.com', SHA2(CONCAT(now(), 'emma456'), 224), now(), 'USER'),
    ('Thomas White', 'thomas.white@example.com', SHA2(CONCAT(now(), 'white789'), 224), now(), 'USER'),
    ('Sophie Martin', 'sophie.martin@example.com', SHA2(CONCAT(now(), 'sophie123'), 224), now(), 'USER'),
    ('Kevin Taylor', 'kevin.taylor@example.com', SHA2(CONCAT(now(), 'taylor456'), 224), now(), 'USER'),
    ('Anna Miller', 'anna.miller@example.com', SHA2(CONCAT(now(), 'miller789'), 224), now(), 'USER')
;

-- Insert data into Vendors table
INSERT INTO Vendors (user_id, BusinessName, BusinessDescription, BusinessAddress, Website, Logo) VALUES
    (1, 'EcoMart', 'Eco-friendly products for daily use', '123 Elm St', 'www.ecomart.com', 'ecomart_logo.png'),
    (2, 'GreenGoods', 'Sustainable and organic goods', '456 Oak St', 'www.greengoods.com', 'greengoods_logo.png'),
    (3, 'NatureNest', 'Natural and eco-friendly products', '789 Pine St', 'www.naturenest.com', 'naturenest_logo.png'),
    (4, 'EcoEssentials', 'Essential eco-friendly items', '321 Maple St', 'www.ecoessentials.com', 'ecoessentials_logo.png'),
    (5, 'PlanetCare', 'Caring for the planet with eco-products', '654 Cedar St', 'www.planetcare.com', 'planetcare_logo.png'),
    (6, 'GreenLife', 'Eco-friendly lifestyle products', '987 Birch St', 'www.greenlife.com', 'greenlife_logo.png'),
    (7, 'EcoHaven', 'Your haven for eco-friendly goods', '111 Spruce St', 'www.ecohaven.com', 'ecohaven_logo.png'),
    (8, 'SustainStore', 'Sustainable products for everyone', '222 Willow St', 'www.sustainstore.com', 'sustainstore_logo.png'),
    (9, 'EarthlyGoods', 'Goods that care for the Earth', '333 Redwood St', 'www.earthlygoods.com', 'earthlygoods_logo.png'),
    (10, 'EcoChoice', 'Your choice for eco-friendly products', '444 Ash St', 'www.ecochoice.com', 'ecochoice_logo.png')
;

-- Insert data into Categories table
INSERT INTO Categories (CategoryName, Description) VALUES
    ('Home Essentials', 'Eco-friendly home essentials'),
    ('Personal Care', 'Sustainable personal care products'),
    ('Groceries', 'Organic and eco-friendly groceries'),
    ('Clothing', 'Sustainable and eco-friendly clothing'),
    ('Electronics', 'Eco-friendly electronic products'),
    ('Outdoor', 'Eco-friendly outdoor products'),
    ('Toys', 'Sustainable toys for kids'),
    ('Stationery', 'Eco-friendly stationery items'),
    ('Cleaning Supplies', 'Eco-friendly cleaning products'),
    ('Kitchenware', 'Sustainable kitchenware')
;

-- Insert data into Products table
INSERT INTO Products (VendorID, CategoryID, ProductName, Description, Price, StockQuantity, EcoRating, ImageURL) VALUES
    (1, 1, 'Reusable Bamboo Towels', 'Eco-friendly reusable towels', 12.99, 100, 5, 'bamboo_towels.png'),
    (2, 2, 'Organic Shampoo', 'Sustainable organic shampoo', 8.99, 200, 4, 'organic_shampoo.png'),
    (3, 3, 'Organic Rice', 'Eco-friendly organic rice', 3.99, 300, 5, 'organic_rice.png'),
    (4, 4, 'Recycled Cotton T-Shirt', 'Sustainable cotton t-shirt', 15.99, 150, 4, 'cotton_tshirt.png'),
    (5, 5, 'Solar Charger', 'Eco-friendly solar charger', 25.99, 50, 5, 'solar_charger.png'),
    (6, 6, 'Eco Tent', 'Sustainable camping tent', 99.99, 20, 4, 'eco_tent.png'),
    (7, 7, 'Wooden Toy Set', 'Eco-friendly wooden toys', 19.99, 80, 5, 'wooden_toys.png'),
    (8, 8, 'Recycled Paper Notebook', 'Sustainable paper notebook', 4.99, 500, 5, 'paper_notebook.png'),
    (9, 9, 'Natural Dish Soap', 'Eco-friendly dish soap', 6.99, 250, 4, 'dish_soap.png'),
    (10, 10, 'Bamboo Utensil Set', 'Sustainable kitchen utensils', 14.99, 120, 5, 'bamboo_utensils.png')
;

-- Insert data into Orders table
INSERT INTO Orders (user_id, TotalAmount, Status, ShippingAddress, PaymentMethod) VALUES
    (1, 50.97, 'Pending', '123 Elm St', 'Credit Card'),
    (2, 30.99, 'Processing', '456 Oak St', 'PayPal'),
    (3, 99.99, 'Shipped', '789 Pine St', 'Debit Card'),
    (4, 15.99, 'Delivered', '321 Maple St', 'Credit Card'),
    (5, 25.99, 'Cancelled', '654 Cedar St', 'PayPal'),
    (6, 19.99, 'Pending', '987 Birch St', 'Credit Card'),
    (7, 12.99, 'Processing', '111 Spruce St', 'Debit Card'),
    (8, 8.99, 'Shipped', '222 Willow St', 'Credit Card'),
    (9, 6.99, 'Delivered', '333 Redwood St', 'PayPal'),
    (10, 14.99, 'Pending', '444 Ash St', 'Debit Card')
;

-- Insert data into OrderItems table
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
    (1, 1, 2, 12.99),
    (1, 2, 1, 8.99),
    (2, 3, 5, 3.99),
    (3, 4, 1, 15.99),
    (4, 5, 1, 25.99),
    (5, 6, 1, 99.99),
    (6, 7, 2, 19.99),
    (7, 8, 3, 4.99),
    (8, 9, 1, 6.99),
    (9, 10, 1, 14.99)
;

-- Insert data into Reviews table
INSERT INTO Reviews (ProductID, user_id, Rating, Comment) VALUES
    (1, 1, 5, 'Great product! Very eco-friendly.'),
    (2, 2, 4, 'Good quality, but a bit expensive.'),
    (3, 3, 5, 'Love this organic rice!'),
    (4, 4, 4, 'Comfortable and sustainable.'),
    (5, 5, 5, 'Works perfectly and eco-friendly.'),
    (6, 6, 4, 'Good tent, but could be cheaper.'),
    (7, 7, 5, 'My kids love these toys!'),
    (8, 8, 5, 'Perfect for my notes.'),
    (9, 9, 4, 'Cleans well and smells great.'),
    (10, 10, 5, 'High-quality utensils.')
;




