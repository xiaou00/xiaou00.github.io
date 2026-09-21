const directory = document.querySelector('.directory-browser');
if (directory) {
  document.querySelector('[data-directory-search]').hidden = false;
  const search = document.querySelector('#note-search');
  const files = [...directory.querySelectorAll('.file-node')];
  const folders = [...directory.querySelectorAll('details[data-directory]')];
  let beforeSearch = null;
  const update = () => {
    const terms = search.value.trim().toLocaleLowerCase().split(/\s+/).filter(Boolean);
    if (terms.length && !beforeSearch) beforeSearch = new Map(folders.map(folder => [folder, folder.open]));
    let count = 0;
    for (const file of files) {
      file.hidden = !terms.every(term => file.dataset.search.includes(term));
      if (!file.hidden) count++;
    }
    for (const folder of folders) {
      const matches = Boolean(folder.querySelector('.file-node:not([hidden])'));
      folder.parentElement.hidden = !matches;
      if (terms.length && matches) folder.open = true;
      else if (!terms.length && beforeSearch) folder.open = beforeSearch.get(folder);
    }
    if (!terms.length) beforeSearch = null;
    const empty = directory.querySelector('.empty-state');
    if (empty) empty.hidden = count !== 0;
    document.querySelector('[data-file-count]').textContent = terms.length ? `${count} / ${files.length} 篇笔记` : `${files.length} 篇笔记`;
    document.querySelector('#search-status').textContent = `找到 ${count} 篇笔记`;
  };
  search.addEventListener('input', update);
  document.querySelector('#clear-search')?.addEventListener('click', () => { search.value = ''; update(); search.focus(); });
  if (folders.length) {
    directory.querySelector('.directory-actions').hidden = false;
    directory.querySelector('[data-expand-all]').addEventListener('click', () => folders.forEach(folder => { folder.open = true; }));
    directory.querySelector('[data-collapse-all]').addEventListener('click', () => folders.forEach(folder => { folder.open = false; }));
  }
  document.addEventListener('keydown', event => {
    if (event.key === '/' && !event.metaKey && !event.ctrlKey && !event.altKey && !/^(INPUT|TEXTAREA|SELECT)$/.test(document.activeElement.tagName) && !document.activeElement.isContentEditable) {
      event.preventDefault(); search.focus();
    }
    if (event.key === 'Escape' && document.activeElement === search) { search.value = ''; update(); search.blur(); }
  });
}

const article = document.querySelector('.typst-content');
if (article) {
  const printButton = document.querySelector('.print-button');
  printButton.hidden = false;
  printButton.addEventListener('click', () => window.print());
  const links = [...document.querySelectorAll('.toc a')];
  const headings = links.map(link => document.getElementById(decodeURIComponent(link.hash.slice(1)))).filter(Boolean);
  let ticking = false;
  const updateReading = () => {
    const scrollable = document.documentElement.scrollHeight - window.innerHeight;
    document.querySelector('.reading-progress span').style.width = `${scrollable > 0 ? Math.min(100, window.scrollY / scrollable * 100) : 100}%`;
    let active = headings[0]?.id;
    for (const heading of headings) if (heading.getBoundingClientRect().top < 160) active = heading.id;
    for (const link of links) {
      const current = decodeURIComponent(link.hash.slice(1)) === active;
      link.classList.toggle('active', current);
      if (current) link.setAttribute('aria-current', 'location'); else link.removeAttribute('aria-current');
    }
    ticking = false;
  };
  window.addEventListener('scroll', () => { if (!ticking) { ticking = true; requestAnimationFrame(updateReading); } }, { passive: true });
  window.addEventListener('resize', updateReading);
  document.fonts.ready.then(updateReading);
  updateReading();
}

// Only the keyword query is kept when opening an object and returning.
const objectBrowser = document.querySelector('.object-browser');
if (objectBrowser) {
  const form = objectBrowser.querySelector('form');
  const search = form.elements.namedItem('q');
  const groups = [...objectBrowser.querySelectorAll('.object-group')];
  const rows = [...objectBrowser.querySelectorAll('[data-object-row]')];
  form.hidden = false;
  const restore = () => { search.value = new URLSearchParams(location.search).get('q') || ''; };
  const update = () => {
    const query = search.value.trim();
    const terms = query.normalize('NFKC').toLocaleLowerCase().split(/\s+/).filter(Boolean);
    let count = 0;
    for (const row of rows) {
      row.hidden = !terms.every(term => row.dataset.search.includes(term));
      if (!row.hidden) count++;
    }
    for (const group of groups) {
      const count = group.querySelectorAll('[data-object-row]:not([hidden])').length;
      group.hidden = terms.length > 0 && count === 0;
      group.querySelector('h2 small').textContent = count;
    }
    objectBrowser.querySelector('[data-object-count]').textContent = terms.length ? `${count} / ${rows.length} 个对象` : `${rows.length} 个对象`;
    objectBrowser.querySelector('.object-no-results').hidden = !terms.length || count > 0;
    const params = new URLSearchParams();
    if (query) params.set('q', query);
    const suffix = params.size ? `?${params}` : '';
    history.replaceState(null, '', `${location.pathname}${suffix}${location.hash}`);
    for (const link of objectBrowser.querySelectorAll('[data-object-link]')) {
      const url = new URL(link.href); url.search = suffix; link.href = url.href;
    }
  };
  form.addEventListener('submit', event => event.preventDefault());
  form.addEventListener('input', update);
  form.addEventListener('reset', event => {
    event.preventDefault(); search.value = ''; update(); search.focus();
  });
  window.addEventListener('popstate', () => { restore(); update(); });
  restore(); update();
}
if (document.querySelector('[data-geopedia-return]')) {
  const query = new URLSearchParams(location.search).get('q');
  const params = new URLSearchParams();
  if (query) params.set('q', query);
  for (const link of document.querySelectorAll('[data-geopedia-return], .note-pagination [data-object-link]')) {
    const url = new URL(link.href); url.search = params.toString(); link.href = url.href;
  }
}
