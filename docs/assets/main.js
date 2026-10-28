(function () {
    'use strict';

    var header = document.querySelector('[data-header]');
    var menuButton = document.querySelector('[data-menu]');
    var menuLabel = document.querySelector('[data-menu-label]');
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
        if (menuLabel) {
            menuLabel.textContent = 'Abrir navegação';
        }
        navigation.classList.remove('open');
        document.body.classList.remove('menu-open');
    }

    if (menuButton && navigation) {
        menuButton.addEventListener('click', function () {
            var open = menuButton.getAttribute('aria-expanded') === 'true';
            menuButton.setAttribute('aria-expanded', String(!open));
            if (menuLabel) {
                menuLabel.textContent = open ? 'Abrir navegação' : 'Fechar navegação';
            }
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

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape' && menuButton.getAttribute('aria-expanded') === 'true') {
                closeMenu();
                menuButton.focus();
            }
        });
    }

    document.querySelectorAll('[data-demo]').forEach(function (demo) {
        var tabs = Array.from(demo.querySelectorAll('[data-demo-tab]'));
        var panels = Array.from(demo.querySelectorAll('[data-demo-panel]'));

        tabs.forEach(function (tab, index) {
            tab.id = 'demo-tab-' + index;
            tab.setAttribute('aria-controls', 'demo-panel-' + index);
            tab.setAttribute('tabindex', tab.getAttribute('aria-selected') === 'true' ? '0' : '-1');

            if (panels[index]) {
                panels[index].id = 'demo-panel-' + index;
                panels[index].setAttribute('aria-labelledby', tab.id);
                panels[index].setAttribute('tabindex', '0');
            }

            tab.addEventListener('click', function () {
                var selected = tab.getAttribute('data-demo-tab');

                tabs.forEach(function (item) {
                    item.setAttribute('aria-selected', String(item === tab));
                    item.setAttribute('tabindex', item === tab ? '0' : '-1');
                });

                panels.forEach(function (panel) {
                    var active = panel.getAttribute('data-demo-panel') === selected;
                    panel.hidden = !active;
                    panel.classList.toggle('active', active);
                });
            });

            tab.addEventListener('keydown', function (event) {
                if (!['ArrowRight', 'ArrowLeft', 'Home', 'End'].includes(event.key)) {
                    return;
                }

                event.preventDefault();
                var next = event.key === 'Home' ? 0 : tabs.length - 1;
                if (event.key === 'ArrowRight' || event.key === 'ArrowLeft') {
                    var direction = event.key === 'ArrowRight' ? 1 : -1;
                    next = (index + direction + tabs.length) % tabs.length;
                }
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

    var journeySteps = Array.from(document.querySelectorAll('[data-journey-steps] li'));
    var journeyCaption = document.querySelector('[data-journey-caption]');
    var journeyMedia = document.querySelector('[data-journey-media]');
    var journeyImages = Array.from(document.querySelectorAll('[data-journey-image]'));
    var journeyMessages = [
        'Registrar na origem sem perder o contexto',
        'Validar e consolidar uma visão nacional',
        'Decidir com caminho de volta à evidência'
    ];

    if (!reducedMotion && journeySteps.length && journeyCaption && journeyMedia) {
        var journeyIndex = 0;
        var journeyTimer = 0;

        var showJourneyStep = function (index) {
            journeyIndex = index;
            journeySteps.forEach(function (step, stepIndex) {
                step.classList.toggle('active', stepIndex === journeyIndex);
            });
            journeyImages.forEach(function (image, imageIndex) {
                image.classList.toggle('active', imageIndex === journeyIndex);
            });
            journeyCaption.textContent = journeyMessages[journeyIndex];
        };

        var startJourney = function () {
            if (journeyTimer) {
                return;
            }
            journeyTimer = window.setInterval(function () {
                showJourneyStep((journeyIndex + 1) % journeySteps.length);
            }, 3200);
        };

        var stopJourney = function () {
            window.clearInterval(journeyTimer);
            journeyTimer = 0;
        };

        journeySteps.forEach(function (step, index) {
            step.addEventListener('mouseenter', function () {
                stopJourney();
                showJourneyStep(index);
            });
            step.addEventListener('mouseleave', startJourney);
        });

        if ('IntersectionObserver' in window) {
            new IntersectionObserver(function (entries) {
                if (entries[0].isIntersecting) {
                    startJourney();
                } else {
                    stopJourney();
                }
            }, { threshold: 0.3 }).observe(journeyMedia);
        } else {
            startJourney();
        }
    }

    document.querySelectorAll('[data-year]').forEach(function (item) {
        item.textContent = String(new Date().getFullYear());
    });

    updateHeader();
    window.addEventListener('scroll', updateHeader, { passive: true });
}());
