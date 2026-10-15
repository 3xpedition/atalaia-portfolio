(function () {
    'use strict';

    var header = document.querySelector('[data-header]');
    var menuButton = document.querySelector('[data-menu]');
    var navigation = document.querySelector('[data-nav]');

    function updateHeader() {
        if (header) {
            header.classList.toggle('scrolled', window.scrollY > 24);
        }
    }

    function closeMenu() {
        if (!menuButton || !navigation) {
            return;
        }

        menuButton.setAttribute('aria-expanded', 'false');
        navigation.classList.remove('open');
        document.body.classList.remove('menu-open');
    }

    if (menuButton && navigation) {
        menuButton.addEventListener('click', function () {
            var open = menuButton.getAttribute('aria-expanded') === 'true';
            menuButton.setAttribute('aria-expanded', String(!open));
            navigation.classList.toggle('open', !open);
            document.body.classList.toggle('menu-open', !open);
        });

        navigation.addEventListener('click', function (event) {
            if (event.target.closest('a')) {
                closeMenu();
            }
        });

        window.addEventListener('resize', function () {
            if (window.innerWidth > 820) {
                closeMenu();
            }
        });
    }

    document.querySelectorAll('[data-demo]').forEach(function (demo) {
        var tabs = Array.from(demo.querySelectorAll('[data-demo-tab]'));
        var panels = Array.from(demo.querySelectorAll('[data-demo-panel]'));

        tabs.forEach(function (tab, index) {
            tab.id = 'demo-tab-' + index;
            tab.setAttribute('aria-controls', 'demo-panel-' + index);

            if (panels[index]) {
                panels[index].id = 'demo-panel-' + index;
                panels[index].setAttribute('aria-labelledby', tab.id);
            }

            tab.addEventListener('click', function () {
                var selected = tab.getAttribute('data-demo-tab');

                tabs.forEach(function (item) {
                    item.setAttribute('aria-selected', String(item === tab));
                });

                panels.forEach(function (panel) {
                    var active = panel.getAttribute('data-demo-panel') === selected;
                    panel.hidden = !active;
                    panel.classList.toggle('active', active);
                });
            });

            tab.addEventListener('keydown', function (event) {
                if (event.key !== 'ArrowRight' && event.key !== 'ArrowLeft') {
                    return;
                }

                event.preventDefault();
                var direction = event.key === 'ArrowRight' ? 1 : -1;
                var next = (index + direction + tabs.length) % tabs.length;
                tabs[next].focus();
                tabs[next].click();
            });
        });
    });

    var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    var revealItems = document.querySelectorAll('.reveal');

    if (reducedMotion || !('IntersectionObserver' in window)) {
        revealItems.forEach(function (item) { item.classList.add('visible'); });
    } else {
        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.12 });

        revealItems.forEach(function (item) { observer.observe(item); });
    }

    document.querySelectorAll('[data-year]').forEach(function (item) {
        item.textContent = String(new Date().getFullYear());
    });

    updateHeader();
    window.addEventListener('scroll', updateHeader, { passive: true });
}());
