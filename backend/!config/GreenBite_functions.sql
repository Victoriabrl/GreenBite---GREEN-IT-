USE GreenBite;

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
    SELECT VendorID, BusinessName, ProductName, Description, Price, Quantity
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