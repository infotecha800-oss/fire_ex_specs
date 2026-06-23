/* grid background animation — FIXED rgba() color strings */

function initGridAnimation() {
  const section = document.querySelector('.h8a-hero-section');
  if (!section) return;

  const canvas = document.createElement('canvas');
  canvas.id = 'h8a-grid-canvas';
  canvas.setAttribute('aria-hidden', 'true');
  section.prepend(canvas);

  const ctx = canvas.getContext('2d');
  const STEP = 52;
  let W, H, cols, rows;
  let mouse = { x: -9999, y: -9999 };
  let clicks = [];

  function resize() {
    W = canvas.width  = section.offsetWidth;
    H = canvas.height = section.offsetHeight;
    cols = Math.ceil(W / STEP) + 2;
    rows = Math.ceil(H / STEP) + 2;
  }

  function clickInfluence(px, py) {
    let v = 0;
    for (const cl of clicks) {
      const dx = px - cl.x, dy = py - cl.y;
      const d = Math.sqrt(dx * dx + dy * dy);
      const width = 22;
      if (d > cl.r - width && d < cl.r + width) {
        const t = 1 - Math.abs(d - cl.r) / width;
        v = Math.max(v, t * cl.life);
      }
    }
    return v;
  }

  function hoverAlpha(px, py) {
    const HOVER_R = 130, HOVER_R2 = HOVER_R * HOVER_R;
    const dx = px - mouse.x, dy = py - mouse.y;
    const d2 = dx * dx + dy * dy;
    return d2 > HOVER_R2 ? 0 : 1 - d2 / HOVER_R2;
  }

  function draw() {
    ctx.clearRect(0, 0, W, H);

    const mx = mouse.x, my = mouse.y;
    ctx.lineWidth = 0.5;

    /* horizontal lines */
    for (let r = 0; r < rows; r++) {
      const y = r * STEP;
      for (let c = 0; c < cols - 1; c++) {
        const x1 = c * STEP, x2 = (c + 1) * STEP;
        const mid = (x1 + x2) / 2;
        const ha = Math.max(hoverAlpha(mid, y), hoverAlpha(x1, y), hoverAlpha(x2, y));
        const ca = clickInfluence(mid, y);
        const total = Math.min(1, ha + ca * 0.9);

        if (total > 0.01) {
          const a = 0.045 + total * 0.55;
          const g = ctx.createLinearGradient(x1, y, x2, y);
          g.addColorStop(0,   `rgba(52, 86, 26, ${a})`);
          g.addColorStop(0.5, `rgba(52, 86, 26, ${a + 0.1})`);
          g.addColorStop(1,   `rgba(52, 86, 26, ${a * 0.8})`);
          ctx.strokeStyle = g;
          ctx.lineWidth = 0.5 + total * 1.2;
        } else {
          ctx.strokeStyle = 'rgba(52, 86, 26, 0.045)';
          ctx.lineWidth = 0.5;
        }
        ctx.beginPath(); ctx.moveTo(x1, y); ctx.lineTo(x2, y); ctx.stroke();
      }
    }

    /* vertical lines */
    for (let c = 0; c < cols; c++) {
      const x = c * STEP;
      for (let r = 0; r < rows - 1; r++) {
        const y1 = r * STEP, y2 = (r + 1) * STEP;
        const mid = (y1 + y2) / 2;
        const ha = Math.max(hoverAlpha(x, mid), hoverAlpha(x, y1), hoverAlpha(x, y2));
        const ca = clickInfluence(x, mid);
        const total = Math.min(1, ha + ca * 0.9);

        if (total > 0.01) {
          const a = 0.045 + total * 0.55;
          const g = ctx.createLinearGradient(x, y1, x, y2);
          g.addColorStop(0,   `rgba(52, 86, 26, ${a})`);
          g.addColorStop(0.5, `rgba(52, 86, 26, ${a + 0.1})`);
          g.addColorStop(1,   `rgba(52, 86, 26, ${a * 0.8})`);
          ctx.strokeStyle = g;
          ctx.lineWidth = 0.5 + total * 1.2;
        } else {
          ctx.strokeStyle = 'rgba(52, 86, 26, 0.045)';
          ctx.lineWidth = 0.5;
        }
        ctx.beginPath(); ctx.moveTo(x, y1); ctx.lineTo(x, y2); ctx.stroke();
      }
    }

    /* intersection dots */
    for (let c = 0; c < cols; c++) {
      for (let r = 0; r < rows; r++) {
        const x = c * STEP, y = r * STEP;
        const ha = hoverAlpha(x, y);
        const ca = clickInfluence(x, y);
        const total = Math.min(1, ha + ca);

        if (total < 0.01) {
          ctx.beginPath(); ctx.arc(x, y, 1.8, 0, Math.PI * 2);
          ctx.fillStyle = 'rgba(52, 86, 26, 0.10)'; ctx.fill();
        } else {
          const dotR = 1.8 + total * 5;
          const grd = ctx.createRadialGradient(x, y, 0, x, y, dotR);
          grd.addColorStop(0, `rgba(52, 86, 26, ${0.9 * total})`);
          grd.addColorStop(1, 'rgba(52, 86, 26, 0)');
          ctx.beginPath(); ctx.arc(x, y, dotR, 0, Math.PI * 2);
          ctx.fillStyle = grd; ctx.fill();

          if (total > 0.5) {
            ctx.beginPath(); ctx.arc(x, y, 1.8 + total * 2.5, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(52, 86, 26, ${total * 0.9})`; ctx.fill();
          }
        }
      }
    }

    /* hover radial glow */
    if (mx > 0 && mx < W && my > 0 && my < H) {
      const rg = ctx.createRadialGradient(mx, my, 0, mx, my, 130);
      rg.addColorStop(0,   'rgba(52, 86, 26, 0.06)');
      rg.addColorStop(0.4, 'rgba(52, 86, 26, 0.03)');
      rg.addColorStop(1,   'rgba(52, 86, 26, 0)');
      ctx.fillStyle = rg;
      ctx.beginPath(); ctx.arc(mx, my, 130, 0, Math.PI * 2); ctx.fill();
    }

    /* click shockwaves */
    for (const cl of clicks) {
      if (cl.life <= 0) continue;
      const rg2 = ctx.createRadialGradient(cl.x, cl.y, cl.r * 0.7, cl.x, cl.y, cl.r + 24);
      rg2.addColorStop(0,   'rgba(52, 86, 26, 0)');
      rg2.addColorStop(0.5, `rgba(52, 86, 26, ${cl.life * 0.14})`);
      rg2.addColorStop(1,   'rgba(52, 86, 26, 0)');
      ctx.fillStyle = rg2;
      ctx.beginPath(); ctx.arc(cl.x, cl.y, cl.r + 24, 0, Math.PI * 2); ctx.fill();
    }

    /* advance click states */
    for (let i = clicks.length - 1; i >= 0; i--) {
      clicks[i].r    += 4.5;
      clicks[i].life -= 0.022;
      if (clicks[i].r > 180 || clicks[i].life <= 0) clicks.splice(i, 1);
    }

    requestAnimationFrame(draw);
  }

  /* events */
  section.addEventListener('mousemove', e => {
    const rect = section.getBoundingClientRect();
    mouse.x = e.clientX - rect.left;
    mouse.y = e.clientY - rect.top;
  });
  section.addEventListener('mouseleave', () => { mouse.x = -9999; mouse.y = -9999; });
  section.addEventListener('click', e => {
    const rect = section.getBoundingClientRect();
    const cx = e.clientX - rect.left, cy = e.clientY - rect.top;
    clicks.push({ x: cx, y: cy, r: 0, life: 1 });
    for (let i = 1; i <= 3; i++) {
      setTimeout(() => clicks.push({
        x: cx + Math.cos(i * 2.09) * 36,
        y: cy + Math.sin(i * 2.09) * 36,
        r: 0, life: 0.7
      }), i * 80);
    }
  });

  window.addEventListener('resize', resize);
  resize();
  draw();
}

document.addEventListener('DOMContentLoaded', initGridAnimation);