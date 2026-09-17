(() => {
    const button = document.querySelector('.menu-toggle');
    const menu = document.querySelector('.main-nav');

    if (button && menu) {
        button.addEventListener('click', () => {
            const isOpen = button.getAttribute('aria-expanded') === 'true';
            button.setAttribute('aria-expanded', String(!isOpen));
            menu.classList.toggle('is-open', !isOpen);
        });

        menu.addEventListener('click', (event) => {
            if (event.target.closest('a')) {
                button.setAttribute('aria-expanded', 'false');
                menu.classList.remove('is-open');
            }
        });
    }

    const year = document.querySelector('#ano');
    if (year) year.textContent = String(new Date().getFullYear());

    const items = document.querySelectorAll('.reveal');
    if (!('IntersectionObserver' in window)) {
        items.forEach((item) => item.classList.add('is-visible'));
        return;
    }

    const observer = new IntersectionObserver((entries, activeObserver) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-visible');
                activeObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12 });

    items.forEach((item) => observer.observe(item));
})();
