/* Support des <image-slot> des exports Claude Design.
   Affiche l'image si un src est fourni, sinon un cadre discret aux couleurs du site. */
(function () {
  'use strict';
  if (window.customElements && !customElements.get('image-slot')) {
    customElements.define('image-slot', class extends HTMLElement {
      connectedCallback() {
        var src = this.getAttribute('src') || this.getAttribute('data-src');
        this.style.display = 'block';
        if (src) {
          var img = document.createElement('img');
          img.src = src;
          img.alt = this.getAttribute('alt') || '';
          img.style.cssText = 'width:100%;height:100%;object-fit:cover;display:block';
          this.appendChild(img);
        } else {
          this.style.background = 'repeating-linear-gradient(45deg,#eceae6,#eceae6 12px,#f6f5f2 12px,#f6f5f2 24px)';
          this.style.minHeight = this.style.minHeight || '200px';
        }
      }
    });
  }
})();
