<?php
$company = getCompanyInfo();
$categories = getCategories();
?>
<!-- ══════════════════════════════════════════
     NAVIGATION BAR
══════════════════════════════════════════ -->
<nav id="navbar">
  <div class="nav-inner">
    <a href="index.php" class="brand">
      <i class="fa-solid fa-fire-extinguisher brand-icon"></i>
      <span class="brand-text"><?= $company['company_name'] ?? '8A Fire Safety' ?></span>
    </a>

    <div class="nav-links">
      <a href="index.php#about">About</a>
      <a href="index.php#products">Products</a>
      <a href="index.php#specifications">Specs</a>
      <a href="index.php#how-to-use">How to Use</a>
      <a href="index.php#certificates">Certificates</a>
      <a href="index.php#timeline">Process</a>
      <a href="index.php#contact" class="nav-cta">Contact Us</a>
    </div>

    <button id="menu-btn" class="menu-toggle" aria-label="Toggle Menu">
      <span></span><span></span><span></span>
    </button>
  </div>
</nav>

<!-- Mobile Menu -->
<div id="mobile-menu" class="mobile-nav">
  <a href="index.php#about" class="mob-link">About</a>
  <a href="index.php#products" class="mob-link">Products</a>
  <a href="index.php#specifications" class="mob-link">Specifications</a>
  <a href="index.php#how-to-use" class="mob-link">How to Use</a>
  <a href="index.php#certificates" class="mob-link">Certificates</a>
  <a href="index.php#timeline" class="mob-link">Process</a>
  <a href="index.php#contact" class="mob-link mob-cta">Contact Us</a>
</div>
