/* =========================================================
   TEGZCONSTRUCTION — Shared JS
   ========================================================= */

// --- Nav scroll behavior ---
const nav = document.querySelector('.nav');
if (nav) {
  const onScroll = () => {
    nav.classList.toggle('scrolled', window.scrollY > 60);
  };
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
}

// --- Mobile menu toggle ---
const hamburger = document.querySelector('.nav__hamburger');
const mobileMenu = document.querySelector('.nav__mobile');
if (hamburger && mobileMenu) {
  hamburger.addEventListener('click', () => {
    const open = mobileMenu.classList.toggle('open');
    hamburger.setAttribute('aria-expanded', open);
    const spans = hamburger.querySelectorAll('span');
    if (open) {
      spans[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
      spans[1].style.opacity = '0';
      spans[2].style.transform = 'rotate(-45deg) translate(5px, -5px)';
    } else {
      spans.forEach(s => { s.style.transform = ''; s.style.opacity = ''; });
    }
  });
  document.addEventListener('click', e => {
    if (!nav.contains(e.target) && mobileMenu.classList.contains('open')) {
      mobileMenu.classList.remove('open');
      hamburger.setAttribute('aria-expanded', false);
      hamburger.querySelectorAll('span').forEach(s => { s.style.transform = ''; s.style.opacity = ''; });
    }
  });
}

// --- Active nav link ---
const currentPath = window.location.pathname.split('/').pop() || 'index.html';
document.querySelectorAll('.nav__links a, .nav__mobile a').forEach(link => {
  const href = link.getAttribute('href');
  if (href === currentPath || (currentPath === '' && href === 'index.html')) {
    link.classList.add('active');
  }
});

// --- Theme toggle ---
const themeToggle = document.querySelector('.nav__theme-toggle');
const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
const storedTheme = localStorage.getItem('tegz-theme');

const applyTheme = (theme) => {
  document.documentElement.setAttribute('data-theme', theme);
  if (themeToggle) {
    themeToggle.textContent = theme === 'dark' ? '☀' : '☾';
    themeToggle.setAttribute('aria-label', `Switch to ${theme === 'dark' ? 'light' : 'dark'} mode`);
  }
};

if (storedTheme) {
  applyTheme(storedTheme);
} else {
  applyTheme(prefersDark.matches ? 'dark' : 'light');
}

if (themeToggle) {
  themeToggle.addEventListener('click', () => {
    const current = document.documentElement.getAttribute('data-theme');
    const next = current === 'dark' ? 'light' : 'dark';
    applyTheme(next);
    localStorage.setItem('tegz-theme', next);
  });
}

// --- Scroll reveal ---
const revealEls = document.querySelectorAll('.reveal');
if (revealEls.length) {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.05, rootMargin: '0px 0px 60px 0px' });
  revealEls.forEach(el => observer.observe(el));
  // Fallback: reveal everything after 1.5s in case observer doesn't fire
  setTimeout(() => {
    revealEls.forEach(el => el.classList.add('visible'));
  }, 1500);
}

// --- Counter animation ---
const counters = document.querySelectorAll('[data-count]');
if (counters.length) {
  const countObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      const el = entry.target;
      const target = parseInt(el.dataset.count, 10);
      const suffix = el.dataset.suffix || '';
      const duration = 1800;
      const start = performance.now();
      const tick = (now) => {
        const elapsed = now - start;
        const progress = Math.min(elapsed / duration, 1);
        const eased = 1 - Math.pow(1 - progress, 3);
        el.textContent = Math.round(eased * target) + suffix;
        if (progress < 1) requestAnimationFrame(tick);
      };
      requestAnimationFrame(tick);
      countObserver.unobserve(el);
    });
  }, { threshold: 0.5 });
  counters.forEach(el => countObserver.observe(el));
}

// --- Project filter ---
const filterTabs = document.querySelectorAll('.filter-tab');
const projectItems = document.querySelectorAll('[data-category]');
if (filterTabs.length) {
  filterTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      filterTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      const cat = tab.dataset.filter;
      projectItems.forEach(item => {
        const show = cat === 'all' || item.dataset.category === cat;
        item.style.display = show ? '' : 'none';
        if (show) item.classList.add('visible');
      });
    });
  });
}

// --- Contact form ---
const contactForm = document.querySelector('.contact-form');
if (contactForm) {
  contactForm.addEventListener('submit', e => {
    e.preventDefault();
    const btn = contactForm.querySelector('button[type="submit"]');
    btn.textContent = 'Message Sent!';
    btn.style.background = '#2a7a3b';
    btn.style.color = '#fff';
    btn.disabled = true;
    setTimeout(() => {
      btn.textContent = 'Send Message';
      btn.style.background = '';
      btn.style.color = '';
      btn.disabled = false;
      contactForm.reset();
    }, 3500);
  });
}
