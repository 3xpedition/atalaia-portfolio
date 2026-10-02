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

    const showreel = document.querySelector('[data-showreel]');
    if (showreel) setupShowreel(showreel);

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

    // Vídeo de apresentação: toca sozinho (sem áudio) quando entra na tela e
    // pausa quando sai. Quem pausa à mão continua pausado até mandar tocar.
    function setupShowreel(root) {
        const video = root.querySelector('video');
        const frameEl = root.querySelector('.showreel-frame');
        const ambient = root.querySelector('.showreel-ambient');
        const time = root.querySelector('[data-showreel-time]');
        const progress = root.querySelector('[data-showreel-progress]');
        const chapters = [...root.querySelectorAll('[data-showreel-seek]')];
        const barToggle = root.querySelector('.showreel-bar [data-showreel-toggle]');
        const fullscreen = root.querySelector('[data-showreel-fullscreen]');
        const context = ambient ? ambient.getContext('2d') : null;
        const autoplay = !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        let userPaused = false;
        let wantsPlay = false;
        let visible = false;
        let frame = 0;
        let lastPaint = 0;

        const clock = (seconds) => {
            const total = Math.max(0, Math.floor(seconds || 0));
            return `${String(Math.floor(total / 60)).padStart(2, '0')}:${String(total % 60).padStart(2, '0')}`;
        };

        // Brilho atrás do quadro: a cena atual reduzida a 48×23 px e borrada pelo CSS.
        const paint = (source) => {
            if (!context) return;
            try {
                context.drawImage(source, 0, 0, ambient.width, ambient.height);
            } catch (error) {
                // Quadro ainda não decodificado: fica o brilho anterior.
            }
        };

        const update = () => {
            const duration = video.duration || 0;
            const now = video.currentTime;
            time.textContent = `${clock(now)} / ${clock(duration)}`;
            progress.style.setProperty('--p', duration ? now / duration : 0);

            chapters.forEach((button, i) => {
                const start = Number(button.dataset.showreelSeek);
                const end = i + 1 < chapters.length ? Number(chapters[i + 1].dataset.showreelSeek) : duration;
                const active = now >= start && now < end;
                button.classList.toggle('is-active', active);
                button.style.setProperty('--p', active && end > start ? (now - start) / (end - start) : 0);
            });
        };

        const loop = (stamp) => {
            update();
            if (stamp - lastPaint > 120) {
                paint(video);
                lastPaint = stamp;
            }
            frame = video.paused ? 0 : requestAnimationFrame(loop);
        };

        const play = () => {
            const attempt = video.play();
            if (attempt) attempt.catch(() => {});
        };

        const toggle = () => {
            if (video.paused) {
                userPaused = false;
                play();
            } else {
                userPaused = true;
                video.pause();
            }
        };

        video.addEventListener('play', () => {
            root.classList.add('is-playing');
            barToggle.setAttribute('aria-label', 'Pausar apresentação');
            cancelAnimationFrame(frame);
            frame = requestAnimationFrame(loop);
        });
        video.addEventListener('pause', () => {
            root.classList.remove('is-playing');
            barToggle.setAttribute('aria-label', 'Reproduzir apresentação');
            update();
        });
        video.addEventListener('loadedmetadata', update);
        video.addEventListener('seeked', () => {
            update();
            paint(video);
        });
        video.addEventListener('click', toggle);
        root.querySelectorAll('[data-showreel-toggle]').forEach((button) => button.addEventListener('click', toggle));

        progress.addEventListener('click', (event) => {
            if (!video.duration) return;
            const box = progress.getBoundingClientRect();
            video.currentTime = Math.min(Math.max((event.clientX - box.left) / box.width, 0), 1) * video.duration;
        });

        chapters.forEach((button) => button.addEventListener('click', () => {
            video.currentTime = Number(button.dataset.showreelSeek);
            userPaused = false;
            play();
        }));

        fullscreen.addEventListener('click', () => {
            if (document.fullscreenElement) document.exitFullscreen();
            else if (frameEl.requestFullscreen) frameEl.requestFullscreen();
            else if (video.webkitEnterFullscreen) video.webkitEnterFullscreen();
        });

        // O botão do hero é um pedido explícito: toca mesmo com movimento reduzido.
        document.querySelectorAll('a[href="#apresentacao"]').forEach((link) => link.addEventListener('click', () => {
            wantsPlay = true;
            userPaused = false;
            if (visible) play();
        }));

        const shouldPlay = () => visible && !document.hidden && !userPaused && (autoplay || wantsPlay);

        if ('IntersectionObserver' in window) {
            new IntersectionObserver(([entry]) => {
                visible = entry.isIntersecting;
                if (shouldPlay()) play();
                else if (!visible && !video.paused && !document.fullscreenElement) video.pause();
            }, { threshold: 0.45 }).observe(video);
        }

        document.addEventListener('visibilitychange', () => {
            if (document.hidden) video.pause();
            else if (shouldPlay()) play();
        });

        if (video.poster) {
            const poster = new Image();
            poster.onload = () => paint(poster);
            poster.src = video.poster;
        }
    }

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
