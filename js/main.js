/* ============================================================
   8A FIRE SAFETY — Main JavaScript
   Dry Chemical Only Version
   Paint Reveal + Scroll Animations + Product Detail Tabs + UI
   ============================================================ */

document.addEventListener('DOMContentLoaded', () => {

  /* ════════════════════════════════════════════════
     1. PAINT REVEAL EFFECT
     Canvas-based color reveal on hover
  ════════════════════════════════════════════════ */
  const container  = document.getElementById('revealContainer');
  const canvas     = document.getElementById('reveal-canvas');
  const colorImgEl = document.getElementById('img-color');

  if (container && canvas && colorImgEl) {
    const ctx = canvas.getContext('2d');
    let colorImage  = new Image();
    let imageLoaded = false;
    let isHovering  = false;
    let fadeTimer   = null;

    // Offscreen mask canvas
    let maskCanvas = document.createElement('canvas');
    let maskCtx    = maskCanvas.getContext('2d');

    // Load color image
    colorImage.crossOrigin = 'anonymous';
    colorImage.src = colorImgEl.src;
    colorImage.onload = () => {
      imageLoaded = true;
      initCanvas();
    };
    if (colorImage.complete && colorImage.naturalWidth > 0) {
      imageLoaded = true;
    }

    function initCanvas() {
      canvas.width  = container.offsetWidth;
      canvas.height = container.offsetHeight;
      syncMaskSize();
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }

    function syncMaskSize() {
      maskCanvas.width  = canvas.width;
      maskCanvas.height = canvas.height;
    }

    new ResizeObserver(() => {
      initCanvas();
      maskCtx.clearRect(0, 0, maskCanvas.width, maskCanvas.height);
    }).observe(container);

    initCanvas();

    // Mouse/touch position
    function getPos(e) {
      const rect = container.getBoundingClientRect();
      const scaleX = canvas.width  / rect.width;
      const scaleY = canvas.height / rect.height;
      const clientX = e.touches ? e.touches[0].clientX : e.clientX;
      const clientY = e.touches ? e.touches[0].clientY : e.clientY;
      return {
        x: (clientX - rect.left) * scaleX,
        y: (clientY - rect.top)  * scaleY,
      };
    }

    function paint(x, y, radius) {
      // Add brush stroke to mask
      maskCtx.globalCompositeOperation = 'source-over';
      const grad = maskCtx.createRadialGradient(x, y, 0, x, y, radius);
      grad.addColorStop(0,    'rgba(255,255,255,1)');
      grad.addColorStop(0.55, 'rgba(255,255,255,0.9)');
      grad.addColorStop(1,    'rgba(255,255,255,0)');
      maskCtx.fillStyle = grad;
      maskCtx.beginPath();
      maskCtx.arc(x, y, radius, 0, Math.PI * 2);
      maskCtx.fill();
      renderFrame();
    }

    function renderFrame() {
      if (!imageLoaded) return;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      // Draw color image
      ctx.globalCompositeOperation = 'source-over';
      ctx.drawImage(colorImage, 0, 0, canvas.width, canvas.height);

      // Mask to show only painted areas
      ctx.globalCompositeOperation = 'destination-in';
      ctx.drawImage(maskCanvas, 0, 0);

      ctx.globalCompositeOperation = 'source-over';
    }

    function fadeOutMask() {
      if (fadeTimer) clearInterval(fadeTimer);
      fadeTimer = setInterval(() => {
        maskCtx.globalCompositeOperation = 'destination-out';
        maskCtx.fillStyle = 'rgba(0,0,0,0.07)';
        maskCtx.fillRect(0, 0, maskCanvas.width, maskCanvas.height);
        maskCtx.globalCompositeOperation = 'source-over';
        renderFrame();
      }, 16);

      setTimeout(() => {
        clearInterval(fadeTimer);
        maskCtx.clearRect(0, 0, maskCanvas.width, maskCanvas.height);
        ctx.clearRect(0, 0, canvas.width, canvas.height);
      }, 600);
    }

    // Events
    container.addEventListener('mouseenter', () => {
      isHovering = true;
      if (fadeTimer) { clearInterval(fadeTimer); fadeTimer = null; }
      const hint = document.querySelector('.reveal-hint');
      if (hint) hint.style.opacity = '0';
    });

    container.addEventListener('mousemove', (e) => {
      if (!isHovering) return;
      const pos = getPos(e);
      paint(pos.x, pos.y, 70);
    });

    container.addEventListener('mouseleave', () => {
      isHovering = false;
      fadeOutMask();
      const hint = document.querySelector('.reveal-hint');
      if (hint) hint.style.opacity = '1';
    });

    container.addEventListener('touchmove', (e) => {
      e.preventDefault();
      if (fadeTimer) { clearInterval(fadeTimer); fadeTimer = null; }
      const pos = getPos(e);
      paint(pos.x, pos.y, 90);
    }, { passive: false });

    container.addEventListener('touchend', () => {
      setTimeout(fadeOutMask, 1200);
    });
  }

  /* ════════════════════════════════════════════════
     2. SCROLL REVEAL ANIMATION
  ════════════════════════════════════════════════ */
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const delay = parseInt(entry.target.dataset.delay || 0);
        setTimeout(() => entry.target.classList.add('visible'), delay);
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });

  document.querySelectorAll('.reveal-on-scroll').forEach(el => {
    revealObserver.observe(el);
  });

  // Staggered children reveal
  document.querySelectorAll('[data-stagger]').forEach(parent => {
    Array.from(parent.children).forEach((child, i) => {
      child.classList.add('reveal-on-scroll');
      child.dataset.delay = i * 100;
      revealObserver.observe(child);
    });
  });

  /* ════════════════════════════════════════════════
     3. NAVBAR SCROLL EFFECT
  ════════════════════════════════════════════════ */
  const navbar = document.getElementById('navbar');
  let lastScroll = 0;

  window.addEventListener('scroll', () => {
    const y = window.scrollY;

    // Shadow effect
    if (navbar) {
      if (y > 60) {
        navbar.classList.add('scrolled');
      } else {
        navbar.classList.remove('scrolled');
      }
    }

    lastScroll = y;
  });

  /* ════════════════════════════════════════════════
     4. SMOOTH NAV LINKS
  ════════════════════════════════════════════════ */
  document.querySelectorAll('a[href^="#"]').forEach(link => {
    link.addEventListener('click', (e) => {
      const href = link.getAttribute('href');
      const target = document.querySelector(href);
      if (target) {
        e.preventDefault();
        const offset = navbar ? navbar.offsetHeight : 0;
        const top = target.getBoundingClientRect().top + window.scrollY - offset - 20;
        window.scrollTo({ top, behavior: 'smooth' });
      }
    });
  });

  /* ════════════════════════════════════════════════
     5. MOBILE MENU
  ════════════════════════════════════════════════ */
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');

  if (menuBtn && mobileMenu) {
    menuBtn.addEventListener('click', () => {
      const isOpen = mobileMenu.style.display === 'block';
      mobileMenu.style.display = isOpen ? 'none' : 'block';

      // Animate hamburger
      const spans = menuBtn.querySelectorAll('span');
      if (!isOpen) {
        spans[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
        spans[1].style.opacity = '0';
        spans[2].style.transform = 'rotate(-45deg) translate(5px, -5px)';
      } else {
        spans[0].style.transform = '';
        spans[1].style.opacity = '';
        spans[2].style.transform = '';
      }
    });

    // Close mobile menu on link click
    document.querySelectorAll('.mob-link').forEach(link => {
      link.addEventListener('click', () => {
        mobileMenu.style.display = 'none';
        const spans = menuBtn.querySelectorAll('span');
        spans[0].style.transform = '';
        spans[1].style.opacity = '';
        spans[2].style.transform = '';
      });
    });
  }

  /* ════════════════════════════════════════════════
     6. COUNTER ANIMATION
  ════════════════════════════════════════════════ */
  const counterObs = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el     = entry.target;
        const target = parseInt(el.dataset.target);
        const suffix = el.dataset.suffix || '';
        let current  = 0;
        const step   = Math.ceil(target / 50);
        const timer  = setInterval(() => {
          current = Math.min(current + step, target);
          el.textContent = current + suffix;
          if (current >= target) clearInterval(timer);
        }, 30);
        counterObs.unobserve(el);
      }
    });
  }, { threshold: 0.5 });

  document.querySelectorAll('[data-target]').forEach(el => counterObs.observe(el));

  /* ════════════════════════════════════════════════
     7. PRODUCT DETAIL TABS
     Tab switching for product size panels
  ════════════════════════════════════════════════ */
  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabPanels = document.querySelectorAll('.product-detail-panel');

  tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      // Deactivate all tabs
      tabBtns.forEach(b => b.classList.remove('active'));
      tabPanels.forEach(p => p.classList.remove('active'));

      // Activate clicked tab
      btn.classList.add('active');
      const targetId = 'tab-' + btn.dataset.tab;
      const targetPanel = document.getElementById(targetId);
      if (targetPanel) {
        targetPanel.classList.add('active');
      }
    });
  });

  /* ════════════════════════════════════════════════
     8. WEIGHT BAR ANIMATION
     Animate width when scrolled into view
  ════════════════════════════════════════════════ */
  const weightBarObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const fills = entry.target.querySelectorAll('.weight-bar-fill');
        fills.forEach((fill, i) => {
          const targetWidth = fill.style.width;
          fill.style.width = '0%';
          setTimeout(() => {
            fill.style.width = targetWidth;
          }, i * 80);
        });
        weightBarObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.3 });

  const weightGuide = document.querySelector('.weight-guide');
  if (weightGuide) {
    weightBarObserver.observe(weightGuide);
  }

  /* ════════════════════════════════════════════════
     9. PARALLAX HINT EFFECT
  ════════════════════════════════════════════════ */
  const revealHint = document.querySelector('.reveal-hint');
  if (revealHint) {
    setInterval(() => {
      revealHint.style.transform = 'translateX(-50%) translateY(-3px)';
      setTimeout(() => {
        revealHint.style.transform = 'translateX(-50%) translateY(0)';
      }, 700);
    }, 1400);
  }

  /* ════════════════════════════════════════════════
     10. PRODUCT ROW INTERACTION
  ════════════════════════════════════════════════ */
  document.querySelectorAll('.product-row').forEach(row => {
    row.addEventListener('mouseenter', () => {
      row.style.background = 'rgba(185, 28, 28, 0.03)';
    });
    row.addEventListener('mouseleave', () => {
      row.style.background = '';
    });
  });

  /* ════════════════════════════════════════════════
     ANATOMY SCROLL ANIMATION — Hero Section
     Scroll-driven part reveal with progress dots
     ════════════════════════════════════════════════ */
  (function() {
    const stage = document.getElementById('anatomyStage');
    const dots = document.getElementById('anatomyDots');
    const nudge = document.getElementById('anatomyNudge');
    const counter = document.getElementById('partCounter');
    const img = document.getElementById('anatomyImg');

    if (!stage) return;

    const parts = [
      'safety-pin',
      'press-handle', 
      'pressure-gauge',
      'florescent-ring',
      'nozzle-hose',
      'cylinder',
      'label-sticker',
      'zip-tie'
    ];

    let currentIndex = -1;
    let hasScrolled = false;

    function updateAnatomy(scrollProgress) {
      // Calculate which part should be active (0-7)
      const totalParts = parts.length;
      const index = Math.min(Math.floor(scrollProgress * totalParts), totalParts - 1);

      if (index !== currentIndex) {
        currentIndex = index;

        // Update counter
        if (counter) {
          counter.textContent = String(index + 1).padStart(2, '0');
        }

        // Update dots
        document.querySelectorAll('.a-dot').forEach((dot, i) => {
          dot.classList.toggle('lit', i === index);
        });

        // Show/hide labels
        parts.forEach((part, i) => {
          const label = document.getElementById('label-' + part);
          if (label) {
            if (i <= index) {
              label.classList.add('is-visible');
            } else {
              label.classList.remove('is-visible');
            }
          }
        });

        // Subtle image pulse on new part
        if (img) {
          img.classList.add('highlighted');
          setTimeout(() => img.classList.remove('highlighted'), 400);
        }
      }
    }

    function onScroll() {
      if (!hasScrolled && nudge) {
        nudge.style.opacity = '0';
        hasScrolled = true;
      }

      const rect = stage.getBoundingClientRect();
      const windowHeight = window.innerHeight;

      // Show dots when in view
      if (dots) {
        if (rect.top < windowHeight && rect.bottom > 0) {
          dots.classList.add('is-active');
        } else {
          dots.classList.remove('is-active');
        }
      }

      // Calculate scroll progress through the stage
      const stageTop = rect.top;
      const stageHeight = rect.height; 
      const progress = Math.max(0, Math.min(1, -stageTop / (stageHeight - windowHeight)));

      updateAnatomy(progress);
    }

    window.addEventListener('scroll', onScroll, { passive: true });

    // Dot click navigation
    document.querySelectorAll('.a-dot').forEach((dot, i) => {
      dot.addEventListener('click', () => {
        const stageRect = stage.getBoundingClientRect();
        const stageHeight = stageRect.height;
        const windowHeight = window.innerHeight;
        const targetScroll = window.scrollY + stageRect.top + (stageHeight - windowHeight) * (i / (parts.length - 1));
        window.scrollTo({ top: targetScroll, behavior: 'smooth' });
      });
    });

    // Initial state
    onScroll();
  })();

  console.log('8A Fire Safety — Dry Chemical Edition — All systems initialized');
});

/*hero*/
/* ══════════════════════════════════════════════════════════════
   8A FIRE SAFETY — HERO REDESIGN: JavaScript
   Paste this block INSIDE the existing DOMContentLoaded callback
   in js/main.js, right before the final console.log() line.
   ══════════════════════════════════════════════════════════════ */

/* ── Staggered card entrance ── */
(function h8aCardEntrance() {
  const cards = document.querySelectorAll('.h8a-card');
  if (!cards.length) return;
  cards.forEach((card, i) => {
    setTimeout(() => card.classList.add('h8a-vis'), 300 + i * 130);
  });
})();

/* ── SVG dashed connector lines (dot → stage centre) ── */
(function h8aDrawLines() {
  const stage = document.getElementById('h8aStage');
  const svg   = document.getElementById('h8aLines');
  if (!stage || !svg) return;

  const dotClasses = [
    'h8a-dot-tl','h8a-dot-tr',
    'h8a-dot-ml','h8a-dot-mr',
    'h8a-dot-bl','h8a-dot-br',
  ];

  function draw() {
    svg.innerHTML = '';
    const sr = stage.getBoundingClientRect();
    const cx = sr.width  / 2;
    const cy = sr.height / 2;

    dotClasses.forEach(cls => {
      const el = stage.querySelector('.' + cls);
      if (!el) return;
      const dr = el.getBoundingClientRect();
      const dx = dr.left - sr.left + dr.width  / 2;
      const dy = dr.top  - sr.top  + dr.height / 2;

      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', dx);
      line.setAttribute('y1', dy);
      line.setAttribute('x2', cx);
      line.setAttribute('y2', cy);
      line.setAttribute('stroke', 'rgba(185,28,28,0.18)');
      line.setAttribute('stroke-width', '1');
      line.setAttribute('stroke-dasharray', '5 4');
      svg.appendChild(line);
    });
  }

  /* Draw after cards have had a moment to settle */
  setTimeout(draw, 500);
  window.addEventListener('resize', draw);
})();
