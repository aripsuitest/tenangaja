-- PostgreSQL version

BEGIN;

-- Table: admin
CREATE TABLE "admin" (
  id VARCHAR(191) PRIMARY KEY,
  name VARCHAR(191) NOT NULL,
  email VARCHAR(191) UNIQUE NOT NULL,
  password VARCHAR(191) NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table: category
CREATE TABLE category (
  id VARCHAR(191) PRIMARY KEY,
  name VARCHAR(191) NOT NULL,
  image VARCHAR(191) NOT NULL,
  description VARCHAR(191)
);

-- Table: favoriteworker
CREATE TABLE favoriteworker (
  id VARCHAR(191) PRIMARY KEY,
  "userId" VARCHAR(191) NOT NULL,
  "workerId" VARCHAR(191) NOT NULL,
  UNIQUE ("userId", "workerId"),
  FOREIGN KEY ("userId") REFERENCES "user"(id) ON UPDATE CASCADE,
  FOREIGN KEY ("workerId") REFERENCES worker(id) ON UPDATE CASCADE
);

-- Table: notification
CREATE TABLE notification (
  id VARCHAR(191) PRIMARY KEY,
  "userId" VARCHAR(191),
  "workerId" VARCHAR(191),
  message VARCHAR(191) NOT NULL,
  "read" BOOLEAN NOT NULL DEFAULT FALSE,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("userId") REFERENCES "user"(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY ("workerId") REFERENCES worker(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: "order"
CREATE TYPE order_status AS ENUM ('PENDING','ACCEPTED','IN_PROGRESS','COMPLETED','CANCELLED');
CREATE TABLE "order" (
  id VARCHAR(191) PRIMARY KEY,
  "userId" VARCHAR(191) NOT NULL,
  "workerId" VARCHAR(191) NOT NULL,
  status order_status NOT NULL DEFAULT 'PENDING',
  date TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes VARCHAR(191),
  budget DOUBLE PRECISION NOT NULL,
  "userConfirmed" BOOLEAN NOT NULL DEFAULT FALSE,
  deadline INTEGER NOT NULL DEFAULT 7,
  FOREIGN KEY ("userId") REFERENCES "user"(id) ON UPDATE CASCADE,
  FOREIGN KEY ("workerId") REFERENCES worker(id) ON UPDATE CASCADE
);

-- Table: payment
CREATE TYPE payment_status AS ENUM ('PENDING','PAID','FAILED');
CREATE TABLE payment (
  id VARCHAR(191) PRIMARY KEY,
  "orderId" VARCHAR(191) UNIQUE NOT NULL,
  "userId" VARCHAR(191) NOT NULL,
  method VARCHAR(191) NOT NULL,
  status payment_status NOT NULL DEFAULT 'PENDING',
  "paidAt" TIMESTAMP(3),
  amount DOUBLE PRECISION NOT NULL,
  "paymentReference" VARCHAR(191) NOT NULL,
  "redirectUrl" VARCHAR(191) NOT NULL,
  "snapToken" VARCHAR(191) NOT NULL,
  FOREIGN KEY ("orderId") REFERENCES "order"(id) ON UPDATE CASCADE,
  FOREIGN KEY ("userId") REFERENCES "user"(id) ON UPDATE CASCADE
);

-- Table: rating
CREATE TABLE rating (
  id VARCHAR(191) PRIMARY KEY,
  "orderId" VARCHAR(191) UNIQUE NOT NULL,
  rating INTEGER NOT NULL,
  comment VARCHAR(191),
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("orderId") REFERENCES "order"(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: subcategory
CREATE TABLE subcategory (
  id VARCHAR(191) PRIMARY KEY,
  name VARCHAR(191) NOT NULL,
  "categoryId" VARCHAR(191) NOT NULL,
  FOREIGN KEY ("categoryId") REFERENCES category(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: "user"
CREATE TYPE user_role AS ENUM ('user','admin');
CREATE TABLE "user" (
  id VARCHAR(191) PRIMARY KEY,
  name VARCHAR(191) NOT NULL,
  email VARCHAR(191) UNIQUE NOT NULL,
  password VARCHAR(191) NOT NULL,
  phone VARCHAR(191),
  address VARCHAR(191),
  profile_pic VARCHAR(191),
  gender VARCHAR(191),
  role user_role NOT NULL DEFAULT 'user'
);

-- Table: worker
CREATE TYPE worker_status AS ENUM ('active','inactive');
CREATE TABLE worker (
  id VARCHAR(191) PRIMARY KEY,
  "userId" VARCHAR(191) UNIQUE NOT NULL,
  description VARCHAR(191),
  status worker_status NOT NULL DEFAULT 'inactive',
  banner VARCHAR(191),
  FOREIGN KEY ("userId") REFERENCES "user"(id) ON UPDATE CASCADE
);

-- Table: workercategory
CREATE TABLE workercategory (
  id VARCHAR(191) PRIMARY KEY,
  "workerId" VARCHAR(191) NOT NULL,
  "categoryId" VARCHAR(191) NOT NULL,
  FOREIGN KEY ("workerId") REFERENCES worker(id) ON UPDATE CASCADE,
  FOREIGN KEY ("categoryId") REFERENCES category(id) ON UPDATE CASCADE
);

-- Data inserts (contoh, lanjutkan sesuai kebutuhan)
INSERT INTO category (id, name, image, description) VALUES
('089322f6-ecfa-4987-b537-d44c6d2574af', 'Konstruksi', 'fas fa-hard-hat', 'Pembangunan dan renovasi rumah, gedung, dan infrastruktur dengan tenaga ahli profesional.'),
('6fd520b8-1969-4a16-8930-39ba14c55b45', 'Elektronik', 'fas fa-tv', 'Layanan instalasi, perbaikan, dan penjualan perangkat elektronik rumah tangga dan kantor.'),
('c9b02c4e-4d77-4dc0-be9a-7a4b9e16a2f8', 'Otomotif', 'fas fa-car', 'Servis dan perawatan kendaraan bermotor, termasuk modifikasi, sparepart, dan inspeksi berkala.'),
('e6a63cb8-e34a-4506-8103-94536cec6e81', 'Serba Bisa', 'fas fa-toolbox', 'Layanan umum seperti tukang, kebersihan, pengangkutan, hingga konsultasi solusi harian.');

-- Lanjutkan insert data lainnya sesuai kebutuhan...

COMMIT;
