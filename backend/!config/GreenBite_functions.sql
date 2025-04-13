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
    SELECT VendorID, BusinessName, ProductName, Description, Price, StockQuantity, EcoRating, ImageURL
    FROM products INNER JOIN Vendors USING (VendorID)
    WHERE ProductID = product_id;
END //
DELIMITER ;
-- CALL get_product_by_id(1);  -- Call the function to get product by ID