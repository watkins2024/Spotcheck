// Shared helpers — use on every page
const WA = '61405160602';
const EMAIL = 'rjw.basalt@gmail.com';
function isActive(id){ const a = document.querySelector(`a[href$="${id}"]`); if(a) a.classList.add('active'); }
function waLink(text){return `https://wa.me/${WA}?text=${encodeURIComponent(text)}`}
function mailtoLink(subject, body){return `mailto:${EMAIL}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`}
function sendEnquiry(payload){
  // open WhatsApp
  window.open(waLink(payload),'_blank');
}
