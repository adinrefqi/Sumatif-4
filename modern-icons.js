/*
 * modern-icons.js — swap Font Awesome glyphs for Lucide line icons.
 * Keeps FA loaded as a fallback for anything unmapped. Converts existing
 * icons on load and any dynamically-injected ones via a MutationObserver.
 * ponytail: name map is hand-curated for the icons this app actually uses.
 */
(function () {
    'use strict';

    // FA class (without the "fa-") -> Lucide icon name.
    var MAP = {
        'arrow-right': 'arrow-right',
        'balance-scale': 'scale',
        'bars': 'menu',
        'bell': 'bell',
        'book': 'book-open',
        'bullhorn': 'megaphone',
        'calculator': 'calculator',
        'check': 'check',
        'check-circle': 'circle-check',
        'chevron-down': 'chevron-down',
        'comment-dots': 'message-circle',
        'database': 'database',
        'door-open': 'door-open',
        'envelope': 'mail',
        'eraser': 'eraser',
        'exclamation-circle': 'circle-alert',
        'exclamation-triangle': 'triangle-alert',
        'file-alt': 'file-text',
        'file-excel': 'file-spreadsheet',
        'file-signature': 'file-pen',
        'folder-open': 'folder-open',
        'font': 'type',
        'globe-asia': 'globe',
        'graduation-cap': 'graduation-cap',
        'history': 'history',
        'inbox': 'inbox',
        'info-circle': 'info',
        'key': 'key-round',
        'language': 'languages',
        'laptop-code': 'laptop',
        'link': 'link',
        'lock': 'lock',
        'lock-open': 'lock-open',
        'microscope': 'microscope',
        'palette': 'palette',
        'paper-plane': 'send',
        'pen-nib': 'pen-tool',
        'praying-hands': 'church',
        'print': 'printer',
        'running': 'activity',
        'save': 'save',
        'school': 'school',
        'search-minus': 'zoom-out',
        'search-plus': 'zoom-in',
        'sign-out-alt': 'log-out',
        'signal': 'signal-high',
        'signature': 'signature',
        'spinner': 'loader-circle',
        'sync': 'refresh-cw',
        'times': 'x',
        'undo': 'undo-2',
        'unlock': 'unlock',
        'user': 'user',
        'user-check': 'user-check',
        'user-circle': 'circle-user',
        'user-clock': 'clock',
        'user-friends': 'users',
        'user-graduate': 'graduation-cap',
        'user-shield': 'shield-check',
        'user-slash': 'user-x',
        'users-viewfinder': 'scan-face',
        'volume-mute': 'volume-x',
        'volume-up': 'volume-2',
        'whatsapp': 'message-circle',
        'wifi': 'wifi'
    };

    // Redundant number badges (buttons already say "Kelas 7/8/9") -> drop.
    var REMOVE = { '7': 1, '8': 1, '9': 1 };

    // FA modifier classes that are not icon names.
    var MODS = { 'fa': 1, 'fas': 1, 'far': 1, 'fab': 1, 'fal': 1, 'fad': 1,
        'fa-solid': 1, 'fa-regular': 1, 'fa-brands': 1, 'fa-light': 1,
        'fa-fw': 1, 'fa-spin': 1, 'fa-pulse': 1, 'fa-beat': 1, 'fa-bounce': 1,
        'fa-lg': 1, 'fa-sm': 1, 'fa-xs': 1, 'fa-1x': 1, 'fa-2x': 1, 'fa-3x': 1 };

    function faIconName(el) {
        var cl = el.classList;
        for (var i = 0; i < cl.length; i++) {
            var c = cl[i];
            if (c.indexOf('fa-') === 0 && !MODS[c] && c.indexOf('fa-w-') !== 0) {
                return c.slice(3);
            }
        }
        return null;
    }

    function tag(el) {
        var name = faIconName(el);
        if (name === null) return;
        el.setAttribute('data-lc-done', '1');
        if (REMOVE[name]) { el.remove(); return; }
        var lucideName = MAP[name];
        if (!lucideName) return; // leave FA fallback in place

        var spin = el.classList.contains('fa-spin') || el.classList.contains('fa-pulse');
        // Strip FA classes so no webfont glyph ghosts behind the SVG.
        var toRemove = [];
        el.classList.forEach(function (c) {
            if (c === 'fa' || c === 'fas' || c === 'far' || c === 'fab' || c.indexOf('fa-') === 0) toRemove.push(c);
        });
        toRemove.forEach(function (c) { el.classList.remove(c); });

        el.setAttribute('data-lucide', lucideName);
        el.classList.add('lc');
        if (spin) el.classList.add('lc-spin');
    }

    function render() {
        if (window.lucide && typeof window.lucide.createIcons === 'function') {
            window.lucide.createIcons({ attrs: { width: '1em', height: '1em', 'stroke-width': 2 } });
        }
    }

    function convert(root) {
        var els = (root || document).querySelectorAll('i[class*="fa-"]:not([data-lc-done])');
        for (var i = 0; i < els.length; i++) tag(els[i]);
        render();
    }

    // Debounced observer for dynamically-injected icons (toasts, tables, modals).
    var pending = false;
    function schedule() {
        if (pending) return;
        pending = true;
        requestAnimationFrame(function () { pending = false; convert(document); });
    }

    function injectBaseCss() {
        if (document.getElementById('lc-base-css')) return;
        var st = document.createElement('style');
        st.id = 'lc-base-css';
        st.textContent =
            '.lc{display:inline-block;vertical-align:-0.14em;stroke:currentColor;fill:none}' +
            '.lc-spin{animation:lc-spin .9s linear infinite;transform-origin:center}' +
            '@keyframes lc-spin{to{transform:rotate(360deg)}}';
        document.head.appendChild(st);
    }

    function boot() {
        injectBaseCss();
        convert(document);
        new MutationObserver(schedule).observe(document.body, { childList: true, subtree: true });
    }

    // Load Lucide (UMD), then boot.
    function loadLucide(cb) {
        if (window.lucide) return cb();
        var s = document.createElement('script');
        s.src = 'https://cdn.jsdelivr.net/npm/lucide@0.460.0/dist/umd/lucide.min.js';
        s.onload = cb;
        s.onerror = cb; // fail open: FA stays as fallback
        document.head.appendChild(s);
    }

    function start() { loadLucide(boot); }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', start);
    } else {
        start();
    }
})();
