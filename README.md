# 8A Fire Safety — Professional Fire Extinguisher Catalog

A formal, professional PHP/MySQL web application for 8A Fire Safety Maintenance & Manufacturing Corporation. Features a complete product catalog with 21 SKUs across 3 agent types and 7 weight classes.

## Features

- **3 Product Types**: HFC-235 (Clean Agent), Dry Chemical (ABC MAP), AFFF Foam
- **7 Weight Classes**: 1, 3, 5, 10, 20, 50, 100 lbs
- **21 Total SKUs** stored in MySQL database
- **Neumorphism UI Design** — professional, formal interface
- **Hover Effects Preserved** on all interactive elements
- **Canvas Paint Reveal** — interactive hero image effect
- **Scroll Animations** — reveal on scroll with stagger
- **Animated Counters** — statistics count up animation
- **Product Comparison Tables** — full specs per category
- **Weight Visual Guide** — animated bar chart comparison
- **Responsive Design** — works on all devices

## System Requirements

- PHP 8.0 or higher
- MySQL 5.7 or higher / MariaDB 10.3+
- Apache/Nginx web server
- mod_rewrite enabled (recommended)

## Installation

### 1. Upload Files

Upload all files to your web server directory (e.g., `/var/www/html/fire-safety/`).

### 2. Create Database

```bash
mysql -u root -p < database.sql
```

Or import `database.sql` via phpMyAdmin.

### 3. Configure Database Connection

Edit `config.php` and update database credentials:

```php
define('DB_HOST', 'localhost');
define('DB_USER', 'your_username');
define('DB_PASS', 'your_password');
define('DB_NAME', 'fire_safety_db');
define('SITE_URL', 'https://yourdomain.com');
```

### 4. Update Images (Optional)

Replace `img/draw.jpg` (sketch) and `img/org.jpg` (color) with your own product images.

### 5. Access Website

Navigate to `https://yourdomain.com/fire-safety/index.php`

## Database Structure

| Table | Description |
|-------|-------------|
| `product_categories` | 3 extinguisher types (HFC-235, Dry Chemical, Foam) |
| `weight_classes` | 7 weight classes (1-100 lbs) |
| `products` | 21 SKUs with full specifications |
| `company_info` | Company details and contact |
| `certificates` | ISO, BFP, and compliance certificates |
| `timeline_stages` | 5-stage production process |
| `contact_messages` | Form submissions |

## Product SKU Reference

| SKU | Type | Weight | Model |
|-----|------|--------|-------|
| HFC235-001 to HFC235-100 | HFC-235 Clean Agent | 1-100 lbs | HFC235-FAxx |
| DRY-001 to DRY-100 | Dry Chemical ABC | 1-100 lbs | 8A-FAxx |
| FOAM-001 to FOAM-100 | AFFF Foam | 1-100 lbs | 8A-FOAMxx |

## File Structure

```
fire-safety/
├── config.php              # Database config & helper functions
├── index.php               # Main page (all sections)
├── database.sql            # MySQL schema + seed data
├── includes/
│   ├── header.php          # HTML head + body start
│   ├── navbar.php          # Fixed navigation
│   └── footer.php          # Footer + scripts
├── css/
│   └── styles.css          # Professional neumorphism styles
├── js/
│   └── main.js             # All interactive features
├── img/
│   ├── draw.jpg            # Sketch image (paint reveal base)
│   └── org.jpg             # Color image (paint reveal target)
└── README.md               # This file
```

## License

&copy; 8A Fire Safety Maintenance & Manufacturing Corporation. All rights reserved.
