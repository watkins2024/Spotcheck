// Shared helpers — use on every page
// Prefer values from the global config but keep sensible fallbacks.
const _CONFIG = (typeof window !== 'undefined' && window.BOOTS_ON_GROUND_CONFIG) ? window.BOOTS_ON_GROUND_CONFIG : {};

function normalizeWhatsApp(number){
  const fallback = '61405160602';
  if(!number) return fallback;
  const digits = String(number).replace(/[^0-9]/g,'');
  if(!digits) return fallback;
  if(digits.startsWith('04')) return '61' + digits.slice(1);
  if(digits.startsWith('614')) return digits;
  if(digits.startsWith('61')) return digits;
  if(digits.length === 9 && digits.startsWith('4')) return '61' + digits;
  return digits;
}

const WA = normalizeWhatsApp(_CONFIG.phoneForWhatsApp);
const EMAIL = _CONFIG.email || 'contact@bootsonground.com.au';
function isActive(id){ const a = document.querySelector(`a[href$="${id}"]`); if(a) a.classList.add('active'); }
function waLink(text){return `https://wa.me/${WA}?text=${encodeURIComponent(text)}`}
function mailtoLink(subject, body){return `mailto:${EMAIL}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`}
function sendEnquiry(payload){
  // open WhatsApp
  window.open(waLink(payload),'_blank');
}

if (typeof window !== 'undefined') {
  window.addEventListener('DOMContentLoaded', () => {
    const toggle = document.querySelector('.nav-toggle');
    const links = document.querySelector('.navlinks');
    if (!toggle || !links) return;

    const closeNav = () => {
      links.classList.remove('open');
      toggle.setAttribute('aria-expanded', 'false');
    };

    toggle.addEventListener('click', () => {
      const isOpen = links.classList.toggle('open');
      toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    });

    links.classList.remove('open');
    toggle.setAttribute('aria-expanded', 'false');

    links.querySelectorAll('a').forEach(anchor => {
      anchor.addEventListener('click', closeNav);
    });
  });
}
