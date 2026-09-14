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
