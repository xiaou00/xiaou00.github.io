function processCodeBlocks(container) {
    for (const pre of container.querySelectorAll('pre')) {
        const code = pre.querySelector('code');
        if (!code) continue;

        const lang = [...code.classList]
            .find(c => c.startsWith('language-'))
            ?.slice('language-'.length) ?? '';

        if (typeof hljs !== 'undefined') hljs.highlightElement(code);

        // Wrap in .code-block
        const wrapper = document.createElement('div');
        wrapper.className = 'code-block';
        pre.replaceWith(wrapper);
        wrapper.appendChild(pre);

        // Toolbar: lang label + copy button
        const toolbar = document.createElement('div');
        toolbar.className = 'code-toolbar';

        const label = document.createElement('span');
        label.className = 'code-lang';
        label.textContent = lang;

        const btn = document.createElement('button');
        btn.className = 'copy-btn';
        btn.textContent = '[copy]';
        btn.addEventListener('click', () => {
            const text = code.textContent;
            const reset = () => setTimeout(() => { btn.textContent = '[copy]'; }, 1800);
            if (navigator.clipboard) {
                navigator.clipboard.writeText(text)
                    .then(() => { btn.textContent = '[copied]'; reset(); })
                    .catch(() => { btn.textContent = '[error]'; reset(); });
            } else {
                const ta = document.createElement('textarea');
                ta.value = text;
                ta.style.cssText = 'position:fixed;opacity:0;pointer-events:none';
                document.body.appendChild(ta);
                ta.select();
                try { document.execCommand('copy'); btn.textContent = '[copied]'; }
                catch { btn.textContent = '[error]'; }
                document.body.removeChild(ta);
                reset();
            }
        });

        toolbar.append(label, btn);
        wrapper.insertBefore(toolbar, pre);
    }
}

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

    processCodeBlocks(main);

    if (typeof renderMathInElement === 'function') {
        renderMathInElement(main, {
            delimiters: [
                { left: '$$', right: '$$', display: true },
                { left: '$',  right: '$',  display: false }
            ],
            throwOnError: false,
            macros: {
                // ── Sets ──
                "\\RR": "\\mathbb{R}",
                "\\CC": "\\mathbb{C}",
                "\\ZZ": "\\mathbb{Z}",
                "\\QQ": "\\mathbb{Q}",
                "\\NN": "\\mathbb{N}",
                "\\FF": "\\mathbb{F}",
                // ── Common operators ──
                "\\id":   "\\mathrm{id}",
                "\\im":   "\\operatorname{im}",
                "\\ker":  "\\operatorname{ker}",
                "\\coker":"\\operatorname{coker}",
                "\\rank": "\\operatorname{rank}",
                "\\spec": "\\operatorname{Spec}",
                "\\hom":  "\\operatorname{Hom}",
                "\\End":  "\\operatorname{End}",
                "\\Aut":  "\\operatorname{Aut}",
                // ── Algebra ──
                "\\iso":  "\\cong",
                "\\normal": "\\trianglelefteq",
                "\\gen":  "\\langle #1 \\rangle",
                "\\ideal":"\\trianglelefteq",
                // ── Delimiters ──
                "\\abs":  "\\left|#1\\right|",
                "\\norm": "\\left\\|#1\\right\\|",
                "\\ang":  "\\langle #1 \\rangle",
                "\\floor":"\\left\\lfloor #1 \\right\\rfloor",
                "\\ceil": "\\left\\lceil  #1 \\right\\rceil",
                // ── Arrows ──
                "\\inject":    "\\hookrightarrow",
                "\\surject":   "\\twoheadrightarrow",
                "\\xto":       "\\xrightarrow{#1}",
            }
        });
    }

    // replace <lastnextpages> elements with series prev/next navigation
    const prefix = slug.includes('/') ? slug.slice(0, slug.lastIndexOf('/') + 1) : null;
    const series = prefix ? posts.filter(p => p.slug.startsWith(prefix)) : [];
    const idx = series.findIndex(p => p.slug === slug);
    const page = lang === 'zh' ? 'post.zh.html' : 'post.html';
    for (const el of main.querySelectorAll('lastnextpages')) {
        const prev = idx > 0 ? series[idx - 1] : null;
        const next = idx < series.length - 1 ? series[idx + 1] : null;
        const prevHtml = prev
            ? `<a href="${page}?slug=${prev.slug}">[← ${prev.title?.[lang] ?? prev.title?.en}]</a>`
            : '<span></span>';
        const nextHtml = next
            ? `<a href="${page}?slug=${next.slug}">[${next.title?.[lang] ?? next.title?.en} →]</a>`
            : '<span></span>';
        const nav = document.createElement('nav');
        nav.className = 'post-nav';
        nav.innerHTML = prevHtml + nextHtml;
        el.replaceWith(nav);
    }
})();
