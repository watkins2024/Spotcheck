// Shared helpers — use on every page
// Prefer values from the global config but keep sensible fallbacks.
const _CONFIG = (typeof window !== 'undefined' && window.BOOTS_ON_GROUND_CONFIG) ? window.BOOTS_ON_GROUND_CONFIG : {};
const WA = _CONFIG.phoneForWhatsApp || '61405160602';
const EMAIL = _CONFIG.email || 'rjw.basalt@gmail.com';
function isActive(id){ const a = document.querySelector(`a[href$="${id}"]`); if(a) a.classList.add('active'); }
function waLink(text){return `https://wa.me/${WA}?text=${encodeURIComponent(text)}`}
function mailtoLink(subject, body){return `mailto:${EMAIL}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`}
function sendEnquiry(payload){
  // open WhatsApp
  window.open(waLink(payload),'_blank');
}
