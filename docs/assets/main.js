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

    const carousel = document.querySelector('[data-carousel]');
    if (carousel) setupCarousel(carousel);

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

    function setupCarousel(root) {
        const slides = [...root.querySelectorAll('.carousel-slide')];
        const tabs = [...root.querySelectorAll('.carousel-tab')];
        if (slides.length < 2 || slides.length !== tabs.length) return;

        const autoplay = !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        const gifBlobs = new Map();
        const pauses = new Set();
        let current = 0;
        let run = 0;

        // Slides com GIF ficam no ar pelo número de voltas pedido; os demais, pelo tempo fixo.
        const durationOf = (slide) => slide.dataset.gifLoop
            ? Number(slide.dataset.gifLoop) * Number(slide.dataset.gifPlays || 1)
            : Number(slide.dataset.duration || 6000);

        // Uma URL de blob nova faz o navegador decodificar o GIF de novo, a partir do primeiro quadro.
        const restartGif = async (slide) => {
            const img = slide.querySelector('img');
            let blob = gifBlobs.get(slide);
            if (!blob) {
                const response = await fetch(slide.querySelector('a').href);
                if (!response.ok) throw new Error(`GIF indisponível: ${response.status}`);
                blob = await response.blob();
                gifBlobs.set(slide, blob);
            }

            const previous = img.dataset.blobUrl;
            const url = URL.createObjectURL(blob);
            img.dataset.blobUrl = url;
            img.loading = 'eager';
            await new Promise((resolve, reject) => {
                img.onload = resolve;
                img.onerror = reject;
                img.src = url;
            });
            if (previous) URL.revokeObjectURL(previous);
        };

        const setPaused = (reason, paused) => {
            if (paused) pauses.add(reason);
            else pauses.delete(reason);
            root.classList.toggle('is-paused', pauses.size > 0);
        };

        const show = (index, { focus = false } = {}) => {
            const token = ++run;
            current = (index + slides.length) % slides.length;

            slides.forEach((slide, i) => {
                const active = i === current;
                slide.classList.toggle('is-active', active);
                slide.inert = !active;
            });

            tabs.forEach((tab, i) => {
                const active = i === current;
                tab.classList.toggle('is-active', active);
                tab.classList.remove('is-running');
                tab.setAttribute('aria-selected', String(active));
                tab.tabIndex = active ? 0 : -1;
            });

            if (focus) tabs[current].focus();
            if (!autoplay) return;

            const slide = slides[current];
            const tab = tabs[current];
            tab.style.setProperty('--carousel-duration', `${durationOf(slide)}ms`);

            const ready = slide.dataset.gifLoop ? restartGif(slide).catch(() => {}) : Promise.resolve();
            ready.then(() => {
                if (token !== run) return;
                void tab.offsetWidth;
                tab.classList.add('is-running');
            });
        };

        tabs.forEach((tab, i) => {
            tab.addEventListener('click', () => show(i));
            tab.querySelector('.carousel-progress').addEventListener('animationend', () => {
                if (i === current) show(current + 1);
            });
        });

        root.querySelector('.carousel-tabs').addEventListener('keydown', (event) => {
            const moves = { ArrowRight: current + 1, ArrowLeft: current - 1, Home: 0, End: slides.length - 1 };
            if (!(event.key in moves)) return;
            event.preventDefault();
            show(moves[event.key], { focus: true });
        });

        root.addEventListener('mouseenter', () => setPaused('hover', true));
        root.addEventListener('mouseleave', () => setPaused('hover', false));
        document.addEventListener('visibilitychange', () => setPaused('hidden', document.hidden));

        if ('IntersectionObserver' in window) {
            new IntersectionObserver(([entry]) => setPaused('offscreen', !entry.isIntersecting), { threshold: 0.25 }).observe(root);
        }

        root.classList.add('is-ready');
        show(0);
    }
})();
