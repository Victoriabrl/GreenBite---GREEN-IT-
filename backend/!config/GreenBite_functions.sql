USE GreenBite;
-- USE sql7775541;


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







DROP PROCEDURE IF EXISTS get_all_vendors;
DELIMITER //

CREATE PROCEDURE get_all_vendors()
BEGIN
    SELECT VendorID, BusinessName, BusinessDescription FROM Vendors;
END //

DELIMITER ;
-- CALL get_all_vendors();  -- Call the function to get all vendors

DROP PROCEDURE IF EXISTS get_vendor_by_id;
DELIMITER //

CREATE PROCEDURE get_vendor_by_id(IN vendor_id INT)
BEGIN
    SELECT BusinessName, BusinessDescription, BusinessAddress, Website, Rating, user_email
    FROM Vendors
    INNER JOIN Reviews USING (VendorID)
    INNER JOIN users ON users.user_id = Vendors.user_id
    WHERE VendorID = vendor_id;
END //

DELIMITER ;
-- CALL get_vendor_by_id(1);  -- Call the function to get vendor by ID


-- PROCEDURE to get all the products sorted by due date descending
DROP PROCEDURE IF EXISTS get_products_sorted_by_due_date;
DELIMITER //

CREATE PROCEDURE get_products_sorted_by_due_date()
BEGIN
    SELECT * FROM products
    ORDER BY DueDate DESC; 
END //

DELIMITER ;

-- CALL get_products_sorted_by_due_date();  -- Call the function to get products sorted by due date


-- PROCEDURE to get product by ID
DROP PROCEDURE IF EXISTS get_product_by_id;
DELIMITER //
CREATE PROCEDURE get_product_by_id(IN product_id INT)
BEGIN
    SELECT VendorID, Category, BusinessName, ProductName, Description, Price, Quantity, DueDate
    FROM products INNER JOIN Vendors USING (VendorID)
    WHERE ProductID = product_id;
END //
DELIMITER ;
-- CALL get_product_by_id(1);  -- Call the function to get product by ID



-- PROCEDURE to filter products by category
DROP PROCEDURE IF EXISTS get_products_by_category;
DELIMITER //

CREATE PROCEDURE get_products_by_category(IN category_list VARCHAR(255))
BEGIN
    -- If category_list is NULL or empty, return all products
    IF category_list IS NULL OR category_list = '' THEN
        SELECT p.*, v.BusinessName
        FROM Products p
        JOIN Vendors v ON p.VendorID = v.VendorID
        WHERE p.IsAvailable = TRUE AND p.DueDate > NOW()
        ORDER BY p.DueDate ASC;
    ELSE
        -- Using FIND_IN_SET to check if a category is in the comma-separated list
        SELECT p.*, v.BusinessName
        FROM Products p
        JOIN Vendors v ON p.VendorID = v.VendorID
        WHERE FIND_IN_SET(p.Category, category_list) > 0
          AND p.IsAvailable = TRUE 
          AND p.DueDate > NOW()
        ORDER BY p.DueDate ASC;
    END IF;
END //

DELIMITER ;

-- Example usage:
-- CALL get_products_by_category('Vegetable,Fruit');  -- Get vegetable and fruit products
-- CALL get_products_by_category('Dairy');           -- Get only dairy products
-- CALL get_products_by_category('');               -- Get all products







-- PROCEDURE to place an order
DROP PROCEDURE IF EXISTS place_order;
DELIMITER //

CREATE PROCEDURE place_order(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_payment_method ENUM('Credit_Card', 'Debit_Card', 'PayPal')
)
BEGIN
    DECLARE v_price DECIMAL(10, 2);
    DECLARE v_available_quantity DECIMAL(10, 2);
    DECLARE v_total_amount DECIMAL(10, 2);
    DECLARE v_product_available BOOLEAN;
    
    -- Start transaction
    START TRANSACTION;
    
    -- Get product information
    SELECT Price, Quantity, IsAvailable 
    INTO v_price, v_available_quantity, v_product_available
    FROM Products 
    WHERE ProductID = p_product_id;
    
    -- Check if product exists and is available
    IF v_price IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found';
        ROLLBACK;
    ELSEIF NOT v_product_available THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product is not available';
        ROLLBACK;
    ELSE
        
        -- Insert order
        INSERT INTO Orders (user_id, ProductID, OrderDate, PaymentMethod)
        VALUES (p_user_id, p_product_id, NOW(), p_payment_method);
        
        -- Update product quantity
        UPDATE Products 
        SET
            IsAvailable = FALSE
        WHERE ProductID = p_product_id;
        
        COMMIT;
        
        SELECT 'Order placed successfully' AS message, 
               LAST_INSERT_ID() AS OrderID;
    END IF;
END //

DELIMITER ;

-- Example usage:
-- CALL place_order(1, 2, 'Credit_Card');





-- PROCEDURE to add a new product
DROP PROCEDURE IF EXISTS add_product;
DELIMITER //

CREATE PROCEDURE add_product(
    IN p_vendor_id INT,
    IN p_category ENUM('Vegetable', 'Fruit', 'Dairy', 'Meat', 'Grain', 'Snack'),
    IN p_product_name VARCHAR(100),
    IN p_description TEXT,
    IN p_price DECIMAL(10, 2),
    IN p_quantity DECIMAL(10, 2),
    IN p_due_date DATETIME
)
BEGIN
    DECLARE vendor_exists INT;
    
    -- Check if vendor exists
    -- SELECT COUNT(*) INTO vendor_exists FROM Vendors WHERE VendorID = p_vendor_id;
    
    -- IF vendor_exists = 0 THEN
    --     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vendor does not exist';
    -- ELSE
        -- Insert new product
        INSERT INTO Products (
            VendorID, 
            Category, 
            ProductName, 
            Description, 
            Price, 
            Quantity, 
            IsAvailable,
            CreatedAt,
            DueDate
        ) VALUES (
            p_vendor_id,
            p_category,
            p_product_name,
            p_description,
            p_price,
            p_quantity,
            TRUE,
            NOW(),
            IFNULL(p_due_date, DATE_ADD(NOW(), INTERVAL 3 DAY))
        );
        
        SELECT 'Product added successfully' AS message, LAST_INSERT_ID() AS ProductID;
    -- END IF;
END //

DELIMITER ;

-- Example usage:
-- CALL add_product(1, 'Vegetable', 'Cucumber', 'Fresh organic cucumbers', 1.99, 10, NULL);






-- PROCEDURE to get all products ordered by a specific user
DROP PROCEDURE IF EXISTS get_user_orders;
DELIMITER //

CREATE PROCEDURE get_user_orders(IN p_user_id INT)
BEGIN
    SELECT 
        o.OrderID,
        p.ProductID,
        p.ProductName,
        p.Description,
        p.DueDate,
        p.Price,
        v.BusinessName AS Vendor,
        o.OrderDate,
        o.PaymentMethod
    FROM 
        Orders o
    JOIN 
        Products p ON o.ProductID = p.ProductID
    JOIN 
        Vendors v ON p.VendorID = v.VendorID
    WHERE 
        o.user_id = p_user_id
    ORDER BY 
        o.OrderDate DESC;
END //

DELIMITER ;

-- PROCEDURE to get all products currently being sold by a vendor
-- PROCEDURE to get all products currently being sold by a vendor based on user_id
DROP PROCEDURE IF EXISTS get_vendor_products_by_user_id;
DELIMITER //

CREATE PROCEDURE get_vendor_products_by_user_id(IN p_user_id INT)
BEGIN
    SELECT 
        p.ProductID,
        p.Category,
        p.ProductName,
        p.Description,
        p.Price,
        p.Quantity,
        p.IsAvailable,
        p.CreatedAt,
        p.DueDate,
        v.BusinessName
    FROM 
        Products p
    JOIN 
        Vendors v ON p.VendorID = v.VendorID
    WHERE 
        v.user_id = p_user_id
    ORDER BY 
        p.DueDate DESC;
END //

DELIMITER ;

-- Example usage:
-- CALL get_vendor_products_by_user_id(1);