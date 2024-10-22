CREATE TABLE carts (
    cart_id SERIAL PRIMARY KEY,          -- Unique cart ID (auto-incremented)
    customer_id INT REFERENCES "FoodAppDB".public.customers(id), -- Optional reference to logged-in user (if applicable)
    cart_status VARCHAR(50) NOT NULL DEFAULT 'active', -- Status of the cart (e.g., active, completed, abandoned)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Time when the cart was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP     -- Time when the cart was last updated
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,   -- Example price field
    description TEXT,                -- Optional product description
    stock_quantity INT NOT NULL      -- Quantity available in stock
);

CREATE TABLE cart_items (
    cart_item_id SERIAL PRIMARY KEY, 
    cart_id INT REFERENCES carts(cart_id) ON DELETE CASCADE,   -- Foreign key to carts
    product_id INT REFERENCES products(product_id) ON DELETE CASCADE, -- Foreign key to products
    quantity INT NOT NULL DEFAULT 1,                           -- Quantity of the product in the cart
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP                -- Timestamp of when the item was added
);