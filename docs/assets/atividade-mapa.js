(() => {
    const section = document.querySelector('[data-activity]');
    const data = window.ATALAIA_ATIVIDADE;
    if (!section || !data || !data.semanas || !Object.keys(data.semanas).length) return;

    const DAY = 86400000;
    const MONTHS = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
    const MOBILE_COLUMNS = 27;
    const number = new Intl.NumberFormat('pt-BR', { maximumFractionDigits: 1, minimumFractionDigits: 1 });
    const percent = new Intl.NumberFormat('pt-BR', { style: 'percent', maximumFractionDigits: 0 });
    const integer = new Intl.NumberFormat('pt-BR');

    const parse = (iso) => { const [y, m, d] = iso.split('-').map(Number); return Date.UTC(y, m - 1, d); };
    const label = (time) => { const d = new Date(time); return `${String(d.getUTCDate()).padStart(2, '0')} de ${MONTHS[d.getUTCMonth()]} de ${d.getUTCFullYear()}`; };
    // Coluna da semana dentro da faixa do ano: a 1ª coluna começa na segunda-feira da semana de 1º de janeiro.
    const firstMonday = (year) => { const jan1 = Date.UTC(year, 0, 1); return jan1 - ((new Date(jan1).getUTCDay() + 6) % 7) * DAY; };
    const column = (time) => Math.floor((time - firstMonday(new Date(time).getUTCFullYear())) / (7 * DAY));
    const level = (total) => (total === 0 ? 0 : total <= 2 ? 1 : total <= 5 ? 2 : total <= 14 ? 3 : 4);

    const weeks = Object.entries(data.semanas).map(([key, [team, others]]) => ({ key, time: parse(key), team, others, total: team + others }));
    const cop = parse(data.inicioCop);
    const generated = parse(data.geradoEm);
    const first = Math.min(...weeks.map((w) => w.time));
    const firstYear = new Date(parse(data.inicio)).getUTCFullYear();
    const lastYear = new Date(generated).getUTCFullYear();

    const sum = (list, field) => list.reduce((acc, w) => acc + w[field], 0);
    const total = sum(weeks, 'total');
    const before = weeks.filter((w) => w.time < cop);
    const after = weeks.filter((w) => w.time >= cop);
    const rateBefore = sum(before, 'total') / ((cop - first) / (7 * DAY));
    const rateAfter = sum(after, 'total') / ((generated + DAY - cop) / (7 * DAY));

    const fill = (name, text) => section.querySelectorAll(`[data-stat="${name}"]`).forEach((el) => { el.textContent = text; });
    fill('depois', percent.format(sum(after, 'total') / total));
    fill('ritmo', `${number.format(rateAfter / rateBefore)}×`);
    fill('ritmo-depois', number.format(rateAfter));
    fill('ritmo-antes', number.format(rateBefore));
    fill('equipe', percent.format(sum(weeks, 'team') / total));
    fill('atualizado', label(generated));

    const byKey = new Map(weeks.map((w) => [w.key, w]));
    const years = [];
    for (let year = firstYear; year <= lastYear; year += 1) {
        years.push({ year, team: sum(weeks.filter((w) => w.key.startsWith(`${year}-`)), 'team'), others: sum(weeks.filter((w) => w.key.startsWith(`${year}-`)), 'others') });
    }
    const maxYear = Math.max(...years.map((y) => y.team + y.others));
    const copKey = new Date(cop).toISOString().slice(0, 10);

    const map = section.querySelector('[data-activity-map]');
    const place = (el, col) => {
        el.style.setProperty('--col', col + 1);
        el.style.setProperty('--col-m', (col % MOBILE_COLUMNS) + 1);
        el.style.setProperty('--row-m', Math.floor(col / MOBILE_COLUMNS) + 1);
    };

    const months = document.createElement('div');
    months.className = 'hm-row hm-months';
    months.setAttribute('aria-hidden', 'true');
    const monthTrack = document.createElement('div');
    monthTrack.className = 'hm-cells';
    [0, 3, 6, 9].forEach((m) => {
        const el = document.createElement('span');
        el.textContent = MONTHS[m];
        // Na coluna da primeira segunda-feira do mês, para "jul" abrir a 2ª linha no celular.
        const day1 = Date.UTC(lastYear, m, 1);
        place(el, column(day1 + ((8 - new Date(day1).getUTCDay()) % 7) * DAY));
        monthTrack.append(el);
    });
    months.append(document.createElement('span'), monthTrack);
    map.append(months);

    years.forEach(({ year, team, others }) => {
        const row = document.createElement('div');
        row.className = 'hm-row';
        if (year === lastYear) row.classList.add('is-current');

        const name = document.createElement('span');
        name.className = 'hm-year';
        name.textContent = year;

        const cells = document.createElement('div');
        cells.className = 'hm-cells';
        // Uma célula por semana, cortada na virada do ano (mesma regra do gerador).
        for (let time = Date.UTC(year, 0, 1); new Date(time).getUTCFullYear() === year;) {
            const key = new Date(time).toISOString().slice(0, 10);
            const week = byKey.get(key) || { team: 0, others: 0, total: 0 };
            const cell = document.createElement('i');
            cell.className = 'hm-cell';
            if (time > generated) cell.classList.add('is-future');
            else cell.dataset.level = level(week.total);
            if (key === copKey) cell.classList.add('is-cop');
            cell.dataset.key = key;
            place(cell, column(time));
            cells.append(cell);
            time = firstMonday(year) + (column(time) + 1) * 7 * DAY;
        }

        const count = document.createElement('span');
        count.className = 'hm-total';
        count.textContent = integer.format(team + others);

        const bar = document.createElement('span');
        bar.className = 'hm-bar';
        bar.innerHTML = `<i class="is-team" style="width:${(team / maxYear) * 100}%"></i><i style="width:${(others / maxYear) * 100}%"></i>`;

        row.append(name, cells, count, bar);
        map.append(row);
    });

    const summary = section.querySelector('[data-activity-summary]');
    if (summary) {
        summary.textContent = `Commits por ano: ${years.map((y) => `${y.year}, ${y.team + y.others} (${y.team} da equipe atual)`).join('; ')}.`;
    }

    const tip = document.createElement('div');
    tip.className = 'hm-tip';
    tip.hidden = true;
    map.append(tip);
    let active = null;

    const show = (cell) => {
        if (active === cell) return;
        hide();
        const week = byKey.get(cell.dataset.key) || { team: 0, others: 0, total: 0 };
        tip.innerHTML = `<strong>${integer.format(week.total)} ${week.total === 1 ? 'commit' : 'commits'}</strong>`
            + `<span>Semana de ${label(parse(cell.dataset.key))}</span>`
            + `<span><i class="is-team"></i>Equipe atual ${week.team} · <i></i>Demais ${week.others}</span>`;
        tip.hidden = false;
        cell.classList.add('is-active');
        active = cell;

        const box = map.getBoundingClientRect();
        const rect = cell.getBoundingClientRect();
        const left = rect.left + rect.width / 2 - box.left - tip.offsetWidth / 2;
        tip.style.left = `${Math.max(0, Math.min(left, box.width - tip.offsetWidth))}px`;
        tip.style.top = `${rect.top - box.top - tip.offsetHeight - 10}px`;
    };
    const hide = () => {
        tip.hidden = true;
        if (active) active.classList.remove('is-active');
        active = null;
    };

    map.addEventListener('pointerover', (event) => {
        const cell = event.target.closest('.hm-cell:not(.is-future)');
        if (cell) show(cell); else if (event.pointerType === 'mouse') hide();
    });
    map.addEventListener('pointerleave', (event) => { if (event.pointerType === 'mouse') hide(); });
    document.addEventListener('pointerdown', (event) => { if (!map.contains(event.target)) hide(); });
    window.addEventListener('resize', hide);

    section.hidden = false;
})();
