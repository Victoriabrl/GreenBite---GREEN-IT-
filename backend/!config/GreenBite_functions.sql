USE GreenBite;

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
    INNER JOIN Users ON Users.user_id = Vendors.user_id
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
    SELECT VendorID, BusinessName, ProductName, Description, Price, Quantity, DueDate
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
        INSERT INTO Orders (user_id, ProductID, PaymentMethod)
        VALUES (p_user_id, p_product_id, p_payment_method);
        
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