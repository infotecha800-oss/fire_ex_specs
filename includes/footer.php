<?php
$company = getCompanyInfo();
$year = date('Y');
?>
<!-- ══════════════════════════════════════════
     FOOTER
══════════════════════════════════════════ -->
<footer>
  <div class="footer-inner">
    <div class="footer-brand">
      <a href="index.php" class="brand">
        <i class="fa-solid fa-fire-extinguisher brand-icon"></i>
        <span class="brand-text"><?= $company['company_name'] ?? '8A Fire Safety' ?></span>
      </a>
      <p class="footer-tagline"><?= $company['tagline'] ?? 'Protecting Lives and Property' ?></p>
    </div>

    <div class="footer-links">
      <a href="index.php#about">About</a>
      <a href="index.php#products">Products</a>
      <a href="index.php#specifications">Specifications</a>
      <a href="index.php#how-to-use">How to Use</a>
      <a href="index.php#certificates">Certificates</a>
      <a href="index.php#contact">Contact</a>
    </div>

    <div class="footer-contact">
      <?php if (!empty($company['phone_primary'])): ?>
        <a href="tel:<?= preg_replace('/[^0-9+]/', '', $company['phone_primary']) ?>" class="footer-link">
          <i class="fa-solid fa-phone"></i> <?= $company['phone_primary'] ?>
        </a>
      <?php endif; ?>
      <?php if (!empty($company['email'])): ?>
        <a href="mailto:<?= $company['email'] ?>" class="footer-link">
          <i class="fa-solid fa-envelope"></i> <?= $company['email'] ?>
        </a>
      <?php endif; ?>
      <?php if (!empty($company['website'])): ?>
        <a href="<?= $company['website'] ?>" target="_blank" class="footer-link">
          <i class="fa-solid fa-globe"></i> <?= parse_url($company['website'], PHP_URL_HOST) ?? $company['website'] ?>
        </a>
      <?php endif; ?>
    </div>
  </div>

  <div class="footer-bottom">
    <div class="footer-badges">
      <span class="footer-badge"><i class="fa-solid fa-certificate"></i> ISO 9001:2015</span>
      <span class="footer-badge"><i class="fa-solid fa-shield-halved"></i> BFP Compliant</span>
      <span class="footer-badge"><i class="fa-solid fa-flag"></i> Made in Philippines</span>
    </div>
    <p class="copyright">&copy; <?= $year ?> <?= $company['legal_name'] ?? '8A Fire Safety' ?>. All rights reserved.</p>
  </div>
</footer>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc4s9bIOgUxi8T/AgQF0uTAlC2B7qCBx0u9P8xK2B0" crossorigin="anonymous"></script>

<!-- Main JavaScript -->
<script src="js/main.js"></script>
</body>
</html>
