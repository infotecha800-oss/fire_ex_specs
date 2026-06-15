-- ============================================================
-- 8A FIRE SAFETY — MySQL Database Schema
-- Professional Fire Extinguisher Catalog
-- ============================================================

CREATE DATABASE IF NOT EXISTS fire_safety_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE fire_safety_db;

-- ============================================================
-- 1. PRODUCT CATEGORIES
-- ============================================================
CREATE TABLE IF NOT EXISTS product_categories (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  category_code VARCHAR(20)  NOT NULL UNIQUE COMMENT 'hfc235, dry_chem, foam',
  category_name VARCHAR(100) NOT NULL COMMENT 'Display name',
  description   TEXT         COMMENT 'Category description',
  agent_type    VARCHAR(200) COMMENT 'Chemical agent used',
  icon_class    VARCHAR(50)  DEFAULT 'fa-fire-extinguisher' COMMENT 'Font Awesome icon',
  sort_order    INT          DEFAULT 0,
  status        ENUM('active','inactive') DEFAULT 'active',
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 2. WEIGHT CLASSES
-- ============================================================
CREATE TABLE IF NOT EXISTS weight_classes (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  weight_lbs  INT         NOT NULL UNIQUE COMMENT '1, 3, 5, 10, 20, 50, 100',
  weight_kg   DECIMAL(6,2) COMMENT 'Approximate kg equivalent',
  sort_order  INT         DEFAULT 0,
  status      ENUM('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 3. PRODUCTS (21 SKUs = 3 categories × 7 weights)
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  sku             VARCHAR(30)  NOT NULL UNIQUE COMMENT 'e.g., HFC235-001, DRY-010, FOAM-050',
  category_id     INT          NOT NULL,
  weight_id       INT          NOT NULL,
  model_number    VARCHAR(50)  COMMENT 'Manufacturer model number',
  name            VARCHAR(200) NOT NULL COMMENT 'Display name',
  short_desc      VARCHAR(300) COMMENT 'Short description for cards',
  description     TEXT         COMMENT 'Full description',
  specifications  JSON         COMMENT 'Variable specs per product',
  fire_classes    VARCHAR(20)  COMMENT 'A,B,C etc',
  working_pressure    VARCHAR(50) COMMENT 'e.g., 1.2 MPa at 27°C',
  test_pressure       VARCHAR(50) COMMENT 'e.g., 2.1 MPa',
  cylinder_material   VARCHAR(100) COMMENT 'Steel, Alloy, etc',
  valve_type      VARCHAR(100) COMMENT 'Valve specification',
  discharge_time  VARCHAR(50)  COMMENT 'Discharge duration',
  discharge_range VARCHAR(50)  COMMENT 'Effective range in meters',
  operating_temp  VARCHAR(100) COMMENT 'Temperature range',
  height_mm       INT          COMMENT 'Height in mm',
  diameter_mm     INT          COMMENT 'Diameter in mm',
  full_weight_kg  DECIMAL(6,2) COMMENT 'Total filled weight kg',
  image_primary   VARCHAR(200) COMMENT 'Primary product image path',
  image_gallery   JSON         COMMENT 'Array of gallery image paths',
  datasheet_url   VARCHAR(200) COMMENT 'PDF datasheet link',
  price_php       DECIMAL(12,2) COMMENT 'Price in Philippine Peso',
  stock_status    ENUM('in_stock','low_stock','out_of_stock','pre_order') DEFAULT 'in_stock',
  featured        BOOLEAN      DEFAULT FALSE,
  status          ENUM('active','inactive','discontinued') DEFAULT 'active',
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (category_id) REFERENCES product_categories(id) ON DELETE CASCADE,
  FOREIGN KEY (weight_id)   REFERENCES weight_classes(id) ON DELETE CASCADE,

  INDEX idx_category (category_id),
  INDEX idx_weight (weight_id),
  INDEX idx_status (status),
  INDEX idx_featured (featured),
  INDEX idx_sku (sku)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 4. COMPANY INFO (Single row for company details)
-- ============================================================
CREATE TABLE IF NOT EXISTS company_info (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  company_name    VARCHAR(200) NOT NULL DEFAULT '8A Fire Safety',
  legal_name      VARCHAR(300) COMMENT 'Full legal entity name',
  tagline         VARCHAR(200) COMMENT 'Company tagline',
  description     TEXT         COMMENT 'Company description',
  address         VARCHAR(300) COMMENT 'Full address',
  city            VARCHAR(100),
  region          VARCHAR(100) COMMENT 'State/Region',
  zip_code        VARCHAR(20),
  country         VARCHAR(100) DEFAULT 'Philippines',
  phone_primary   VARCHAR(50),
  phone_secondary VARCHAR(50),
  phone_tertiary  VARCHAR(50),
  email           VARCHAR(100),
  website         VARCHAR(200),
  iso_certificate VARCHAR(100) COMMENT 'ISO cert number',
  license_number  VARCHAR(100) COMMENT 'Business license',
  established_year INT,
  logo_url        VARCHAR(200),
  status          ENUM('active','inactive') DEFAULT 'active',
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 5. CERTIFICATES
-- ============================================================
CREATE TABLE IF NOT EXISTS certificates (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(200) NOT NULL,
  issuer      VARCHAR(200) COMMENT 'Issuing body',
  cert_number VARCHAR(100) COMMENT 'Certificate number',
  description TEXT,
  icon_class  VARCHAR(50) DEFAULT 'certificate',
  status_label VARCHAR(50) COMMENT 'e.g., CERTIFIED, LICENSED, COMPLIANT',
  issue_date  DATE,
  expiry_date DATE,
  status      ENUM('active','expired','renewing') DEFAULT 'active',
  sort_order  INT DEFAULT 0,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 6. CONTACT MESSAGES (Form submissions)
-- ============================================================
CREATE TABLE IF NOT EXISTS contact_messages (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(200) NOT NULL,
  email       VARCHAR(200) NOT NULL,
  phone       VARCHAR(50),
  company     VARCHAR(200),
  subject     VARCHAR(200),
  message     TEXT         NOT NULL,
  product_interest VARCHAR(100) COMMENT 'Which product they are interested in',
  status      ENUM('new','read','replied','archived') DEFAULT 'new',
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_status (status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 7. PRODUCTION TIMELINE STAGES
-- ============================================================
CREATE TABLE IF NOT EXISTS timeline_stages (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  stage_num   VARCHAR(20) NOT NULL COMMENT '01, 02, etc',
  title       VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  sort_order  INT DEFAULT 0,
  status      ENUM('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SEED DATA
-- ============================================================

-- Categories
INSERT INTO product_categories (category_code, category_name, description, agent_type, icon_class, sort_order) VALUES
('hfc235',    'HFC-235',    'HFC-235 (FE-36) Clean Agent Fire Extinguisher — leaves no residue, safe for electronics and sensitive equipment.', 'HFC-236fa (FE-36) Clean Agent', 'fa-fire-extinguisher', 1),
('dry_chem',  'Dry Chemical', 'ABC Dry Chemical Fire Extinguisher — Monoammonium Phosphate (MAP) agent, versatile for Class A, B, and C fires.', 'Monoammonium Phosphate (MAP) 40%', 'fa-fire', 2),
('foam',      'Foam',       'AFFF Foam Fire Extinguisher — Aqueous Film Forming Foam for Class A and B fires, ideal for flammable liquid hazards.', 'Aqueous Film Forming Foam (AFFF)', 'fa-water', 3);

-- Weight Classes
INSERT INTO weight_classes (weight_lbs, weight_kg, sort_order) VALUES
(1,   0.45,  1),
(3,   1.36,  2),
(5,   2.27,  3),
(10,  4.54,  4),
(20,  9.07,  5),
(50,  22.68, 6),
(100, 45.36, 7);

-- Products: HFC-235 (Clean Agent - FE-36)
INSERT INTO products (sku, category_id, weight_id, model_number, name, short_desc, description, specifications, fire_classes, working_pressure, test_pressure, cylinder_material, valve_type, discharge_time, discharge_range, operating_temp, height_mm, diameter_mm, full_weight_kg, price_php, stock_status, featured) VALUES
('HFC235-001', 1, 1, 'HFC235-FA1', 'HFC-235 1 lbs Clean Agent', 'Compact clean agent extinguisher for electronics and server rooms.', 'The HFC-235 1 lbs FE-36 clean agent extinguisher is ideal for protecting sensitive electronic equipment, server racks, data centers, and laboratories. The HFC-236fa agent leaves absolutely no residue, making it perfect for areas where cleanup from traditional extinguisher agents would be costly or damaging.', '{"agent_capacity": "1 lbs (0.45 kg) FE-36", "agent_concentration": "HFC-236fa 100%", "operating_pressure": "195 psi at 70°F", "valve": "Anodized aluminum", "gauge": "Pressure indicator", " hose": "None — nozzle discharge", "bracket": "Vehicle / wall mount"}', 'B,C', '1.34 MPa at 21°C', '2.4 MPa', 'Seamless steel DOT approved', 'Anodized aluminum valve w/ safety pin', '8-10 seconds', '2.4-3.0 meters', '-40°C to +54°C', 280, 65, 1.8, 4850.00, 'in_stock', FALSE),

('HFC235-003', 1, 2, 'HFC235-FA3', 'HFC-235 3 lbs Clean Agent', 'Portable clean agent protection for offices, control rooms, and medical equipment.', 'The HFC-235 3 lbs FE-36 clean agent extinguisher offers enhanced fire protection for office environments, medical facilities, control rooms, and areas with valuable electronics. The clean agent vaporizes completely after discharge, leaving zero residue and zero cleanup.', '{"agent_capacity": "3 lbs (1.36 kg) FE-36", "agent_concentration": "HFC-236fa 100%", "operating_pressure": "195 psi at 70°F", "valve": "Anodized aluminum", "gauge": "Pressure indicator", "hose": "None — nozzle discharge", "bracket": "Wall mount included"}', 'B,C', '1.34 MPa at 21°C', '2.4 MPa', 'Seamless steel DOT approved', 'Anodized aluminum valve w/ safety pin', '9-11 seconds', '3.0-4.0 meters', '-40°C to +54°C', 390, 90, 4.2, 9850.00, 'in_stock', TRUE),

('HFC235-005', 1, 3, 'HFC235-FA5', 'HFC-235 5 lbs Clean Agent', 'Mid-size clean agent for data centers, telecom rooms, and CNC machines.', 'The HFC-235 5 lbs FE-36 clean agent extinguisher provides robust protection for critical infrastructure including data centers, telecommunications facilities, CNC machining centers, and broadcast studios. Zero ozone depletion potential (ODP=0).', '{"agent_capacity": "5 lbs (2.27 kg) FE-36", "agent_concentration": "HFC-236fa 100%", "operating_pressure": "195 psi at 70°F", "valve": "Heavy-duty anodized aluminum", "gauge": "Pressure indicator", "hose": "Flexible discharge hose", "bracket": "Heavy-duty wall mount"}', 'A,B,C', '1.34 MPa at 21°C', '2.4 MPa', 'Seamless steel DOT approved', 'Heavy-duty anodized aluminum valve', '10-13 seconds', '3.6-4.5 meters', '-40°C to +54°C', 460, 110, 7.1, 14850.00, 'in_stock', FALSE),

('HFC235-010', 1, 4, 'HFC235-FA10', 'HFC-235 10 lbs Clean Agent', 'Large capacity clean agent for server farms, laboratories, and clean rooms.', 'The HFC-235 10 lbs FE-36 clean agent extinguisher delivers substantial fire suppression capability for large server farms, pharmaceutical clean rooms, research laboratories, and museums with valuable artifacts. Electrically non-conductive and safe for occupied spaces.', '{"agent_capacity": "10 lbs (4.54 kg) FE-36", "agent_concentration": "HFC-236fa 100%", "operating_pressure": "195 psi at 70°F", "valve": "Heavy-duty anodized aluminum", "gauge": "Pressure indicator", "hose": "5 ft flexible discharge hose", "bracket": "Heavy-duty wall mount", "wheels": "Optional transport cart"}', 'A,B,C', '1.34 MPa at 21°C', '2.4 MPa', 'Seamless steel DOT approved', 'Heavy-duty anodized aluminum valve', '12-15 seconds', '4.5-5.5 meters', '-40°C to +54°C', 560, 140, 13.5, 24850.00, 'in_stock', TRUE),

('HFC235-020', 1, 5, 'HFC235-FA20', 'HFC-235 20 lbs Clean Agent', 'Industrial clean agent protection for aircraft hangars and marine engine rooms.', 'The HFC-235 20 lbs FE-36 clean agent extinguisher is designed for industrial-scale protection of aircraft hangars, marine engine rooms, power generation facilities, and large manufacturing plants with sensitive electronics. UL/ULC listed and approved for occupied spaces.', '{"agent_capacity": "20 lbs (9.07 kg) FE-36", "agent_concentration": "HFC-236fa 100%", "operating_pressure": "195 psi at 70°F", "valve": "Industrial brass valve", "gauge": "Large dial pressure gauge", "hose": "5 ft reinforced discharge hose", "bracket": "Floor stand / wheeled cart", "wheels": "Steel transport cart"}', 'A,B,C', '1.34 MPa at 21°C', '2.4 MPa', 'Seamless steel DOT approved', 'Industrial brass valve assembly', '15-18 seconds', '5.5-6.5 meters', '-40°C to +54°C', 720, 180, 25.2, 42850.00, 'in_stock', FALSE),

('HFC235-050', 1, 6, 'HFC235-FA50', 'HFC-235 50 lbs Clean Agent', 'Commercial clean agent system for large facilities and critical infrastructure.', 'The HFC-235 50 lbs FE-36 clean agent extinguisher provides commercial-grade fire suppression for large data centers, telecommunications hubs, military command centers, and pharmaceutical manufacturing facilities. Wheeled unit for rapid deployment.', '{"agent_capacity": "50 lbs (22.68 kg) FE-36", "agent_concentration": "HFC-236fa 100%", "operating_pressure": "195 psi at 70°F", "valve": "Commercial brass valve", "gauge": "Large dial pressure gauge", "hose": "10 ft reinforced discharge hose", "bracket": "Steel wheeled cart with locking brake", "wheels": "10\" pneumatic wheels"}', 'A,B,C', '1.34 MPa at 21°C', '2.4 MPa', 'Seamless steel DOT/TC approved', 'Commercial brass valve assembly', '18-22 seconds', '6.5-8.0 meters', '-40°C to +54°C', 950, 240, 58.5, 89500.00, 'in_stock', FALSE),

('HFC235-100', 1, 7, 'HFC235-FA100', 'HFC-235 100 lbs Clean Agent', 'Maximum capacity clean agent for industrial total flood applications.', 'The HFC-235 100 lbs FE-36 clean agent extinguisher is the ultimate portable solution for industrial total flood protection of large hangars, naval vessels, transformer stations, and critical national infrastructure. Heavy-duty wheeled unit with extended reach hose system.', '{"agent_capacity": "100 lbs (45.36 kg) FE-36", "agent_concentration": "HFC-236fa 100%", "operating_pressure": "195 psi at 70°F", "valve": "Industrial manifold valve system", "gauge": "Dual pressure gauge system", "hose": "25 ft reinforced discharge hose with wand", "bracket": "Heavy-duty steel wheeled platform", "wheels": "12\" solid rubber wheels"}', 'A,B,C', '1.34 MPa at 21°C', '2.4 MPa', 'Seamless steel DOT/TC/ASME approved', 'Industrial manifold brass valve system', '25-30 seconds', '8.0-10.0 meters', '-40°C to +54°C', 1200, 300, 112.0, 168500.00, 'pre_order', FALSE);

-- Products: Dry Chemical (ABC MAP)
INSERT INTO products (sku, category_id, weight_id, model_number, name, short_desc, description, specifications, fire_classes, working_pressure, test_pressure, cylinder_material, valve_type, discharge_time, discharge_range, operating_temp, height_mm, diameter_mm, full_weight_kg, price_php, stock_status, featured) VALUES
('DRY-001', 2, 1, '8A-FA1', 'Dry Chemical 1 lbs ABC', 'Compact ABC dry chemical extinguisher for vehicles, kitchens, and small offices.', 'The 1 lbs ABC dry chemical extinguisher uses Monoammonium Phosphate (MAP) to combat Class A (ordinary combustibles), Class B (flammable liquids), and Class C (energized electrical) fires. Compact size ideal for personal vehicles, kitchen cabinets, and small office spaces.', '{"agent_capacity": "1 lbs (0.45 kg) MAP", "agent_concentration": "Monoammonium Phosphate 40%", "operating_pressure": "150 psi at 70°F", "valve": "Brass valve", "gauge": "Pressure gauge", "hose": "None — top discharge", "bracket": "Vehicle mounting bracket"}', 'A,B,C', '1.2 MPa at 27°C', '2.1 MPa', 'Cold-rolled steel', 'Brass valve w/ safety pin & seal', '8 seconds', '2.4-3.0 meters', '-20°C to +60°C', 290, 70, 1.5, 1850.00, 'in_stock', FALSE),

('DRY-003', 2, 2, '8A-FA3', 'Dry Chemical 3 lbs ABC', 'Standard portable ABC extinguisher for homes, offices, and retail spaces.', 'The 3 lbs ABC dry chemical extinguisher is the most popular choice for residential, office, and retail environments. MAP agent smothers fires by interrupting the chemical chain reaction while the powder coating prevents re-ignition.', '{"agent_capacity": "3 lbs (1.36 kg) MAP", "agent_concentration": "Monoammonium Phosphate 40%", "operating_pressure": "175 psi at 70°F", "valve": "Brass valve", "gauge": "Pressure gauge", "hose": "None — top discharge", "bracket": "Wall hook included"}', 'A,B,C', '1.2 MPa at 27°C', '2.1 MPa', 'Cold-rolled steel', 'Brass valve w/ safety pin & seal', '9-10 seconds', '3.0-3.6 meters', '-20°C to +60°C', 380, 95, 4.0, 2850.00, 'in_stock', FALSE),

('DRY-005', 2, 3, '8A-FA5', 'Dry Chemical 5 lbs ABC', 'Versatile ABC extinguisher for workshops, warehouses, and commercial kitchens.', 'The 5 lbs ABC dry chemical extinguisher provides reliable multi-purpose fire protection for workshops, warehouses, restaurants, and light industrial settings. Enhanced discharge duration and range for larger fire hazards.', '{"agent_capacity": "5 lbs (2.27 kg) MAP", "agent_concentration": "Monoammonium Phosphate 40%", "operating_pressure": "195 psi at 70°F", "valve": "Heavy-duty brass valve", "gauge": "Pressure gauge", "hose": "Flexible discharge hose", "bracket": "Wall mount bracket"}', 'A,B,C', '1.2 MPa at 27°C', '2.1 MPa', 'Cold-rolled steel, powder-coated', 'Heavy-duty brass valve w/ safety pin', '12-14 seconds', '3.6-4.5 meters', '-20°C to +60°C', 470, 115, 6.8, 4250.00, 'in_stock', TRUE),

('DRY-010', 2, 4, '8A-FA10', 'Dry Chemical 10 lbs ABC', 'Heavy-duty ABC extinguisher for factories, construction sites, and fuel storage.', 'The 10 lbs ABC dry chemical extinguisher is built for demanding industrial environments. Extended discharge time and longer range make it suitable for factories, construction sites, fuel storage areas, and larger commercial spaces with elevated fire risk.', '{"agent_capacity": "10 lbs (4.54 kg) MAP", "agent_concentration": "Monoammonium Phosphate 40%", "operating_pressure": "195 psi at 70°F", "valve": "Heavy-duty brass valve", "gauge": "Large dial pressure gauge", "hose": "Flexible discharge hose", "bracket": "Heavy-duty wall bracket", "wheels": "Optional"}', 'A,B,C', '1.2 MPa at 27°C', '2.1 MPa', 'Cold-rolled steel, powder-coated', 'Heavy-duty brass valve assembly', '15-18 seconds', '4.5-5.5 meters', '-20°C to +60°C', 580, 145, 12.5, 7850.00, 'in_stock', TRUE),

('DRY-020', 2, 5, '8A-FA20', 'Dry Chemical 20 lbs ABC', 'Industrial ABC extinguisher for large manufacturing and petrochemical facilities.', 'The 20 lbs ABC dry chemical extinguisher provides extended fire-fighting capability for large manufacturing plants, petrochemical storage, loading docks, and heavy industrial applications. Wheeled configuration for rapid response across large facilities.', '{"agent_capacity": "20 lbs (9.07 kg) MAP", "agent_concentration": "Monoammonium Phosphate 40%", "operating_pressure": "195 psi at 70°F", "valve": "Industrial brass valve", "gauge": "Large dial pressure gauge", "hose": "5 ft reinforced discharge hose", "bracket": "Wheeled cart mount", "wheels": "Steel transport cart"}', 'A,B,C', '1.2 MPa at 27°C', '2.1 MPa', 'Cold-rolled steel, powder-coated', 'Industrial brass valve assembly', '18-22 seconds', '5.5-6.5 meters', '-20°C to +60°C', 740, 185, 24.0, 14250.00, 'in_stock', FALSE),

('DRY-050', 2, 6, '8A-FA50', 'Dry Chemical 50 lbs ABC', 'Commercial wheeled ABC unit for large industrial complexes and airports.', 'The 50 lbs ABC dry chemical extinguisher on a heavy-duty wheeled cart is designed for large industrial complexes, airport tarmacs, shipping terminals, and power plants. Maximum portable dry chemical capacity with extended range hose system.', '{"agent_capacity": "50 lbs (22.68 kg) MAP", "agent_concentration": "Monoammonium Phosphate 40%", "operating_pressure": "195 psi at 70°F", "valve": "Commercial brass manifold valve", "gauge": "Large dial pressure gauge", "hose": "10 ft reinforced discharge hose", "bracket": "Heavy-duty wheeled steel cart", "wheels": "10\" pneumatic wheels"}', 'A,B,C', '1.2 MPa at 27°C', '2.1 MPa', 'Cold-rolled steel, heavy gauge', 'Commercial brass manifold valve', '25-30 seconds', '6.5-8.0 meters', '-20°C to +60°C', 960, 250, 57.0, 32850.00, 'in_stock', FALSE),

('DRY-100', 2, 7, '8A-FA100', 'Dry Chemical 100 lbs ABC', 'Maximum capacity portable ABC system for total facility protection.', 'The 100 lbs ABC dry chemical extinguisher is the largest portable unit available for total facility fire protection. Designed for oil refineries, chemical plants, military installations, and mega-facilities requiring maximum fire suppression capability.', '{"agent_capacity": "100 lbs (45.36 kg) MAP", "agent_concentration": "Monoammonium Phosphate 40%", "operating_pressure": "195 psi at 70°F", "valve": "Industrial manifold valve system", "gauge": "Dual pressure gauge system", "hose": "25 ft reinforced discharge hose with wand", "bracket": "Heavy-duty wheeled platform", "wheels": "12\" solid rubber wheels"}', 'A,B,C', '1.2 MPa at 27°C', '2.1 MPa', 'Cold-rolled steel, heavy gauge', 'Industrial manifold valve system', '35-40 seconds', '8.0-10.0 meters', '-20°C to +60°C', 1220, 310, 110.0, 62500.00, 'pre_order', FALSE);

-- Products: Foam (AFFF)
INSERT INTO products (sku, category_id, weight_id, model_number, name, short_desc, description, specifications, fire_classes, working_pressure, test_pressure, cylinder_material, valve_type, discharge_time, discharge_range, operating_temp, height_mm, diameter_mm, full_weight_kg, price_php, stock_status, featured) VALUES
('FOAM-001', 3, 1, '8A-FOAM1', 'Foam 1 lbs AFFF', 'Compact foam extinguisher for marine vessels, small kitchens, and vehicles.', 'The 1 lbs AFFF foam extinguisher creates an aqueous film that blankets flammable liquid fires, suppressing vapors and preventing re-ignition. Ideal for marine vessels, small kitchens with grease hazards, and personal vehicles.', '{"agent_capacity": "1 lbs (0.45 kg) AFFF", "foam_concentration": "AFFF 3%", "operating_pressure": "150 psi at 70°F", "valve": "Brass valve", "gauge": "Pressure gauge", "nozzle": "Foam applicator nozzle", "bracket": "Marine/vehicle bracket"}', 'A,B', '1.2 MPa at 27°C', '2.1 MPa', 'Stainless steel 304', 'Brass valve w/ foam nozzle', '10-12 seconds', '2.0-2.5 meters', '-10°C to +49°C', 300, 72, 1.7, 2250.00, 'in_stock', FALSE),

('FOAM-003', 3, 2, '8A-FOAM3', 'Foam 3 lbs AFFF', 'Standard foam extinguisher for restaurants, gas stations, and automotive shops.', 'The 3 lbs AFFF foam extinguisher is the standard choice for commercial kitchens, automotive repair shops, gas stations, and any environment with flammable liquid storage. The foam creates a cooling blanket that suppresses vapors and prevents reflash.', '{"agent_capacity": "3 lbs (1.36 kg) AFFF", "foam_concentration": "AFFF 3%", "operating_pressure": "175 psi at 70°F", "valve": "Brass valve", "gauge": "Pressure gauge", "nozzle": "Foam applicator nozzle", "bracket": "Wall hook included"}', 'A,B', '1.2 MPa at 27°C', '2.1 MPa', 'Stainless steel 304', 'Brass valve w/ foam nozzle', '12-14 seconds', '2.5-3.5 meters', '-10°C to +49°C', 395, 98, 4.5, 3850.00, 'in_stock', FALSE),

('FOAM-005', 3, 3, '8A-FOAM5', 'Foam 5 lbs AFFF', 'Enhanced foam protection for commercial kitchens and fuel depots.', 'The 5 lbs AFFF foam extinguisher provides extended discharge time for larger commercial kitchen installations, small fuel depots, paint shops, and solvent storage areas. The aspirated foam nozzle creates consistent foam blanket quality.', '{"agent_capacity": "5 lbs (2.27 kg) AFFF", "foam_concentration": "AFFF 3%", "operating_pressure": "195 psi at 70°F", "valve": "Heavy-duty brass valve", "gauge": "Pressure gauge", "nozzle": "Aspirated foam nozzle", "bracket": "Wall mount bracket"}', 'A,B', '1.2 MPa at 27°C', '2.1 MPa', 'Stainless steel 304', 'Heavy-duty brass valve w/ foam nozzle', '15-18 seconds', '3.5-4.5 meters', '-10°C to +49°C', 485, 118, 7.5, 5850.00, 'in_stock', TRUE),

('FOAM-010', 3, 4, '8A-FOAM10', 'Foam 10 lbs AFFF', 'Industrial foam extinguisher for hangars, refineries, and chemical storage.', 'The 10 lbs AFFF foam extinguisher delivers industrial-grade protection for aircraft hangars, small oil refineries, chemical storage facilities, and large commercial kitchens. Extended range aspirated foam nozzle provides maximum coverage.', '{"agent_capacity": "10 lbs (4.54 kg) AFFF", "foam_concentration": "AFFF 3%", "operating_pressure": "195 psi at 70°F", "valve": "Heavy-duty brass valve", "gauge": "Large dial pressure gauge", "nozzle": "Extended aspirated foam nozzle", "bracket": "Heavy-duty wall bracket", "wheels": "Optional"}', 'A,B', '1.2 MPa at 27°C', '2.1 MPa', 'Stainless steel 304, heavy gauge', 'Heavy-duty brass valve w/ foam nozzle', '20-24 seconds', '4.5-5.5 meters', '-10°C to +49°C', 600, 150, 13.8, 10850.00, 'in_stock', FALSE),

('FOAM-020', 3, 5, '8A-FOAM20', 'Foam 20 lbs AFFF', 'Large industrial foam unit for airports, docks, and petrochemical plants.', 'The 20 lbs AFFF foam extinguisher on wheeled cart provides mobile fire suppression for airport tarmacs, shipping docks, petrochemical loading stations, and large paint manufacturing facilities. Wheeled for rapid deployment across wide areas.', '{"agent_capacity": "20 lbs (9.07 kg) AFFF", "foam_concentration": "AFFF 3%", "operating_pressure": "195 psi at 70°F", "valve": "Industrial brass valve", "gauge": "Large dial pressure gauge", "nozzle": "Extended aspirated foam wand", "bracket": "Wheeled cart mount", "wheels": "Steel transport cart"}', 'A,B', '1.2 MPa at 27°C', '2.1 MPa', 'Stainless steel 316, heavy gauge', 'Industrial brass valve w/ foam wand', '25-30 seconds', '5.5-6.5 meters', '-10°C to +49°C', 760, 190, 25.5, 19500.00, 'in_stock', FALSE),

('FOAM-050', 3, 6, '8A-FOAM50', 'Foam 50 lbs AFFF', 'Commercial foam system for large marine vessels and industrial tank farms.', 'The 50 lbs AFFF foam extinguisher provides commercial-scale foam suppression for large marine vessels, industrial tank farms, airport rescue & fire fighting (ARFF) operations, and large-scale petrochemical facilities. Heavy-duty wheeled platform.', '{"agent_capacity": "50 lbs (22.68 kg) AFFF", "foam_concentration": "AFFF 3%", "operating_pressure": "195 psi at 70°F", "valve": "Commercial brass manifold valve", "gauge": "Large dial pressure gauge", "nozzle": "Extended foam wand system", "bracket": "Heavy-duty wheeled steel cart", "wheels": "10\" pneumatic wheels"}', 'A,B', '1.2 MPa at 27°C', '2.1 MPa', 'Stainless steel 316, heavy gauge', 'Commercial brass manifold valve', '35-40 seconds', '6.5-8.0 meters', '-10°C to +49°C', 980, 255, 59.0, 42500.00, 'in_stock', FALSE),

('FOAM-100', 3, 7, '8A-FOAM100', 'Foam 100 lbs AFFF', 'Maximum capacity foam extinguisher for mega-facility and municipal fire departments.', 'The 100 lbs AFFF foam extinguisher is the ultimate portable foam suppression system designed for mega-facilities, municipal fire departments, offshore oil platforms, and military fuel depots. Maximum capacity with extended reach wand and heavy-duty mobility platform.', '{"agent_capacity": "100 lbs (45.36 kg) AFFF", "foam_concentration": "AFFF 3%", "operating_pressure": "195 psi at 70°F", "valve": "Industrial manifold valve system", "gauge": "Dual pressure gauge system", "nozzle": "25 ft foam wand with aspirator", "bracket": "Heavy-duty wheeled platform", "wheels": "12\" solid rubber wheels"}', 'A,B', '1.2 MPa at 27°C', '2.1 MPa', 'Stainless steel 316L, heavy gauge', 'Industrial manifold valve system', '45-55 seconds', '8.0-10.0 meters', '-10°C to +49°C', 1240, 315, 115.0, 82500.00, 'pre_order', FALSE);

-- Company Info
INSERT INTO company_info (company_name, legal_name, tagline, description, address, city, region, zip_code, country, phone_primary, phone_secondary, email, website, iso_certificate, license_number, established_year) VALUES
('8A Fire Safety', '8A Fire Safety Maintenance & Manufacturing Corporation', 'Protecting Lives and Property Since 2021', '8A Fire Safety is a Philippine-based manufacturer of fire extinguishers and fire safety equipment. We produce HFC-235 clean agent, ABC dry chemical, and AFFF foam fire extinguishers in capacities from 1 to 100 pounds. All products are manufactured under ISO 9001:2015 quality management systems and comply with Philippine BFP regulations.', 'Calumpang I, Lot 1, Tamaroc Street, Culait, Tandang Sora', 'Quezon City', 'National Capital Region', '1106', 'Philippines', '0967-661-5730', '0965-096-1966', 'info@8afiresafety.com', 'https://8agroup.org', 'ISO 9001:2015 License No. 0-0964', '0-0964', 2021);

-- Certificates
INSERT INTO certificates (title, issuer, cert_number, description, icon_class, status_label, issue_date, status) VALUES
('ISO 9001:2015', 'International Organization for Standardization', '0-0964', 'Certified Quality Management System covering the full production lifecycle — from raw material sourcing to finished unit inspection.', 'award', 'CERTIFIED — ACTIVE', '2021-05-01', 'active'),
('Product Safety License (PH)', 'Philippine Regulatory Authorities', '0-0964', 'Registered with Philippine regulatory authorities. Product Safety License No. 0-0964 issued under the Philippine Consumer Act.', 'shield', 'LICENSED', '2021-05-01', 'active'),
('BFP Compliance', 'Bureau of Fire Protection (BFP) Philippines', 'BFP-2021-0964', 'Compliant with Bureau of Fire Protection (BFP) of the Philippines standards and requirements for fire suppression equipment.', 'check-circle', 'COMPLIANT', '2021-05-01', 'active'),
('Technical Inspection Record', '8A Fire Safety QA Department', 'TIR-2021-001', 'Each unit undergoes hydraulic pressure testing, valve integrity check, and label verification before shipment. Monthly inspection recommended.', 'clipboard-check', 'TEST PASSED', '2021-05-01', 'active'),
('Made in the Philippines', 'Philippine Economic Zone Authority', 'PEZA-2021-0964', 'Proudly manufactured locally at Culait, Tandang Sora, Quezon City. Supporting Philippine industry and local employment since 2021.', 'globe', 'LOCAL MANUFACTURE', '2021-05-01', 'active'),
('Recharge & Service Certification', '8A Fire Safety Service Division', 'RSC-2021-001', 'After any discharge, a recharge service form must be completed and attached to the unit. Recharge available through 8A authorized service centers.', 'sync', 'SERVICE AVAILABLE', '2021-05-01', 'active');

-- Timeline
INSERT INTO timeline_stages (stage_num, title, description, sort_order) VALUES
('01', 'Material Sourcing', 'Monoammonium Phosphate (MAP) and HFC-236fa agents are sourced from certified international suppliers. Steel and stainless steel cylinder blanks are procured from ISO-certified local mills. Every batch undergoes incoming quality inspection.', 1),
('02', 'Cylinder Fabrication & Testing', 'Cylinders are formed, welded, and hydraulically tested at 2.1 MPa to confirm structural integrity before any filling. Pressure vessels undergo non-destructive testing including ultrasonic and visual inspection.', 2),
('03', 'Agent Filling & Pressurization', 'The specified amount of fire suppression agent is loaded precisely, then the unit is pressurized to the working level. Valves are sealed, safety pins installed, and pressure gauges calibrated to specification.', 3),
('04', 'Quality Inspection & Labeling', 'Each unit receives comprehensive final inspection including pressure gauge calibration, valve operation test, ISO label application, manufacturing date stamp, expiry marking, and individual serial number engraving.', 4),
('05', 'Distribution & Post-Sale Service', 'Units are carefully packaged and distributed from our Quezon City facility. Post-sale recharge, inspection, and recertification services are available through 8A authorized service centers nationwide.', 5);
