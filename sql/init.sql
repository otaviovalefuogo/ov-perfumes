CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL, 
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER' CHECK (role IN ('CUSTOMER', 'ADMIN')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS perfumes (
    id  SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    inspired_by VARCHAR(100) NOT NULL,
    gender VARCHAR(20) NOT NULL CHECK (gender IN ('MASCULINO', 'FEMININO', 'COMPARTILHAVEL')),
    accords JSONB NOT NULL DEFAULT '[]'::jsonb,
    volume_ml INTEGER NOT NULL CHECK (volume_ml IN (50,100)),
    price_cents INTEGER NOT NULL CHECK(price_cents>0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK(stock>=0),
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PAID', 'DELIVERED', 'CANCELED')),
    payment_method VARCHAR(30) NOT NULL DEFAULT 'PIX' CHECK (payment_method IN ('PIX', 'NA_ENTREGA')),
    delivery_method VARCHAR(20) NOT NULL DEFAULT 'RETIRADA' CHECK (delivery_method IN ('RETIRADA', 'ENTREGA_LOCAL', 'CORREIOS')),
    delivery_address TEXT,
    total_cents INTEGER NOT NULL CHECK(total_cents>0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    perfume_id INTEGER NOT NULL REFERENCES perfumes(id),
    quantity INTEGER NOT NULL CHECK(quantity>0),
    unit_price_cents INTEGER NOT NULL
);