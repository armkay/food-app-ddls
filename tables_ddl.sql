-- Enable UUID extension for customer and cart IDs if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
DROP TABLE public.customers;
-- Customers Table
CREATE TABLE public.customers (
  customer_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE public.carts;
-- Carts Table
CREATE TABLE public.carts (
  cart_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID REFERENCES customers(customer_id),
  created_at TIMESTAMP DEFAULT NOW(),
  status VARCHAR(50) DEFAULT 'active'
);

DROP TABLE public.products;
-- Products Table (Using SERIAL for product_id)
CREATE TABLE public.products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
DROP TABLE public.cart_items;
-- Cart Items Table (Using SERIAL for item_id)
CREATE TABLE public.cart_items (
  item_id SERIAL PRIMARY KEY,
  cart_id UUID REFERENCES carts(cart_id),
  product_id INT REFERENCES products(product_id),
  quantity INT DEFAULT 1,
  added_at TIMESTAMP DEFAULT NOW()
);

