(async () => {
    const lang = document.documentElement.lang.startsWith('zh') ? 'zh' : 'en';
    const slug = new URLSearchParams(location.search).get('slug');
    if (!slug) return;

    const ext = lang === 'zh' ? '.zh.html' : '.html';

    let posts, contentRes;
    try {
        [posts, contentRes] = await Promise.all([
            fetch('posts/index.json').then(r => r.json()),
            fetch(`posts/${slug}${ext}`)
        ]);
    } catch {
        document.querySelector('.content').innerHTML = '<p style="color:#777">Failed to load post.</p>';
        return;
    }

    const main = document.querySelector('.content');

    if (!contentRes.ok) {
        main.innerHTML = '<p style="color:#777">Post not found.</p>';
        return;
    }

    const html = await contentRes.text();
    const meta = posts.find(p => p.slug === slug);
    const title = meta ? (meta.title?.[lang] ?? meta.title?.en ?? meta.title) : slug;

    if (meta) {
        document.title = `${title} — xiaou0's Blog`;
    }

    const metaHtml = meta ? `
        <div class="post-meta">
            <span>${meta.date}</span>
            ${meta.tag ? `<span class="post-tag">${meta.tag}</span>` : ''}
        </div>` : '';

    main.innerHTML = `<h1>${title}</h1>${metaHtml}${html}`;

    if (typeof renderMathInElement === 'function') {
        renderMathInElement(main, {
            delimiters: [
                { left: '$$', right: '$$', display: true },
                { left: '$',  right: '$',  display: false }
            ],
            throwOnError: false
        });
    }
})();
