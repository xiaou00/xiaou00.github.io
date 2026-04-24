(async () => {
    const lang = document.documentElement.lang.startsWith('zh') ? 'zh' : 'en';

    let posts;
    try {
        posts = await fetch('posts/index.json').then(r => r.json());
    } catch {
        return;
    }

    const byYear = posts.filter(p => !p.langs || p.langs.includes(lang)).reduce((acc, p) => {
        const y = p.date.slice(0, 4);
        (acc[y] ??= []).push(p);
        return acc;
    }, {});

    const container = document.getElementById('post-list');

    for (const year of Object.keys(byYear).sort().reverse()) {
        const group = document.createElement('div');
        group.className = 'year-group';

        const label = document.createElement('div');
        label.className = 'year-label';
        label.textContent = year;

        const ul = document.createElement('ul');
        ul.className = 'post-list';

        for (const p of byYear[year]) {
            const title = (p.title?.[lang] ?? p.title?.en ?? p.title) || p.slug;
            const href = lang === 'zh'
                ? `post.zh.html?slug=${encodeURIComponent(p.slug)}`
                : `post.html?slug=${encodeURIComponent(p.slug)}`;

            const li = document.createElement('li');
            li.className = 'post-item';

            const date = document.createElement('span');
            date.className = 'post-date';
            date.textContent = p.date.slice(5);

            const a = document.createElement('a');
            a.className = 'post-title';
            a.href = href;
            a.textContent = title;

            li.append(date, a);

            if (p.tag) {
                const tag = document.createElement('span');
                tag.className = 'post-tag';
                tag.textContent = p.tag;
                li.append(tag);
            }

            ul.appendChild(li);
        }

        group.append(label, ul);
        container.appendChild(group);
    }
})();
