-- Enable UUID extension for customer and cart IDs if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE customers (
  customer_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cognito_sub VARCHAR(100) UNIQUE, -- Unique identifier from Cognito
  email VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Index on `cognito_sub` for faster lookups
CREATE INDEX idx_cognito_sub ON customers (cognito_sub);

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
	product_id serial4 NOT NULL,
	"name" varchar(100) NOT NULL,
	description text NULL,
	price numeric(10, 2) NOT NULL,
	created_at timestamp DEFAULT now() NULL,
	is_on_sale bool DEFAULT false NULL,
	sale_price numeric(10, 2) NULL,
	CONSTRAINT products_pkey PRIMARY KEY (product_id)
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

DROP TABLE public.inventory 

CREATE TABLE public.inventory (
  inventory_id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(product_id),
  location VARCHAR(100) DEFAULT 'default', -- Supports multi-location inventory
  quantity INT DEFAULT 0,
  last_updated TIMESTAMP DEFAULT NOW()
);

-- Optional: Inventory Log Table for Tracking Changes
CREATE TABLE public.inventory_log (
  log_id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(product_id),
  change_amount INT NOT NULL,
  change_type VARCHAR(50), -- e.g., 'SALE', 'RETURN', 'STOCK_ADJUSTMENT'
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE public.categories (
  category_id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  parent_category_id int REFERENCES categories(category_id) -- for nested categories
);

CREATE TABLE public.product_categories (
  product_id int REFERENCES products(product_id),
  category_id int REFERENCES categories(category_id),
  PRIMARY KEY (product_id, category_id)
);

CREATE TABLE public.product_variations (
  variation_id serial PRIMARY KEY,
  product_id int REFERENCES products(product_id),
  sku varchar(50) UNIQUE, -- optional
  color varchar(50),
  size varchar(50),
  price numeric(10,2), -- override if needed
  stock_quantity int DEFAULT 0,
  image_url text
);


CREATE TABLE public.tags (
  tag_id serial PRIMARY KEY,
  name varchar(50) NOT NULL UNIQUE
);

CREATE TABLE public.product_tags (
  product_id int REFERENCES products(product_id),
  tag_id int REFERENCES tags(tag_id),
  PRIMARY KEY (product_id, tag_id)
);

-- Tenant Table
CREATE TABLE tenants (
  tenant_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) UNIQUE NOT NULL,
  domain VARCHAR(100), -- Optional custom domain
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

tenant_id UUID NOT NULL REFERENCES tenants(tenant_id)

CREATE INDEX idx_products_tenant ON products (tenant_id);


