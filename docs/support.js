/* Runtime minimal pour exécuter les exports Claude Design (.dc.html) en autonome.
   Émule ce que fait le support.js du canvas Design : DCLogic, script text/x-dc, style-hover. */
(function () {
  'use strict';

  // Les balises <x-dc> et <helmet> sont inconnues du navigateur → affichage bloc
  var css = document.createElement('style');
  css.textContent = 'x-dc,helmet{display:block}';
  document.head.appendChild(css);

  // Classe de base attendue par le script exporté
  window.DCLogic = function DCLogic() {};
  DCLogic.prototype.renderVals = function () { return {}; };
  DCLogic.prototype.componentDidMount = function () {};
  DCLogic.prototype.componentWillUnmount = function () {};

  function initStyleHover() {
    var els = document.querySelectorAll('[style-hover]');
    Array.prototype.forEach.call(els, function (el) {
      var base = el.getAttribute('style') || '';
      var hover = el.getAttribute('style-hover') || '';
      el.addEventListener('mouseenter', function () { el.setAttribute('style', base + ';' + hover); });
      el.addEventListener('mouseleave', function () { el.setAttribute('style', base); });
    });
  }

  function runDCScripts() {
    var scripts = document.querySelectorAll('script[type="text/x-dc"]');
    Array.prototype.forEach.call(scripts, function (s) {
      try {
        // Le script définit `class Component extends DCLogic` ; on l'instancie et on monte
        var factory = new Function(s.textContent + '\n;return typeof Component !== "undefined" ? Component : null;');
        var Component = factory();
        if (Component) {
          var instance = new Component();
          if (typeof instance.componentDidMount === 'function') instance.componentDidMount();
        }
      } catch (e) {
        console.error('Erreur script Design:', e);
      }
    });
  }

  function boot() { initStyleHover(); runDCScripts(); }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', boot); else boot();
})();
