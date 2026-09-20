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

// Search stays entirely static. The query string preserves filters on return.
const objectQueryKeys = ['q', 'category', 'property', 'value', 'invariant', 'min', 'max'];
const objectBrowser = document.querySelector('.object-browser');
if (objectBrowser) {
  const form = objectBrowser.querySelector('form');
  const controls = Object.fromEntries(objectQueryKeys.map(key => [key, form.elements.namedItem(key)]));
  const groups = [...objectBrowser.querySelectorAll('.object-group')];
  const rows = [...objectBrowser.querySelectorAll('[data-object-row]')].map(row => ({
    row, category: row.closest('[data-category]').dataset.category,
    properties: JSON.parse(row.dataset.properties), numbers: JSON.parse(row.dataset.numbers),
  }));
  const details = form.querySelector('details');
  form.hidden = false;
  const restore = () => {
    const params = new URLSearchParams(location.search);
    for (const key of objectQueryKeys) controls[key].value = params.get(key) || '';
    details.open = ['property', 'invariant', 'min', 'max'].some(key => controls[key].value);
  };
  const update = (writeUrl = true) => {
    const values = Object.fromEntries(objectQueryKeys.map(key => [key, controls[key].value.trim()]));
    const terms = values.q.toLocaleLowerCase().split(/\s+/).filter(Boolean);
    const min = values.min === '' ? -Infinity : Number(values.min);
    const max = values.max === '' ? Infinity : Number(values.max);
    controls.value.disabled = !values.property;
    controls.min.disabled = controls.max.disabled = !values.invariant;
    const active = terms.length || values.category || values.property || values.invariant;
    let count = 0;
    for (const item of rows) {
      const flag = item.properties[values.property];
      const number = item.numbers[values.invariant];
      const propertyMatches = !values.property || !values.value || (values.value === 'unknown' ? flag == null : flag === (values.value === 'true'));
      const numberMatches = !values.invariant || typeof number === 'number' && number >= min && number <= max;
      const match = (!values.category || item.category === values.category) && propertyMatches && numberMatches && terms.every(term => item.row.dataset.search.includes(term));
      item.row.hidden = !match;
      if (match) count++;
    }
    for (const group of groups) {
      const count = group.querySelectorAll('[data-object-row]:not([hidden])').length;
      group.hidden = Boolean(active) && count === 0;
      group.querySelector('h2 small').textContent = count;
    }
    objectBrowser.querySelector('[data-object-count]').textContent = active ? `${count} / ${rows.length} 个对象` : `${rows.length} 个对象`;
    objectBrowser.querySelector('.object-no-results').hidden = !active || count > 0;
    const params = new URLSearchParams();
    for (const [key, value] of Object.entries(values)) {
      if (value && !(key === 'value' && !values.property) && !(['min', 'max'].includes(key) && !values.invariant)) params.set(key, value);
    }
    const query = params.size ? `?${params}` : '';
    if (writeUrl) history.replaceState(null, '', `${location.pathname}${query}${location.hash}`);
    for (const link of objectBrowser.querySelectorAll('[data-object-link]')) {
      const url = new URL(link.href); url.search = query; link.href = url.href;
    }
  };
  form.addEventListener('submit', event => event.preventDefault());
  form.addEventListener('input', () => update());
  form.addEventListener('change', () => update());
  form.addEventListener('reset', event => {
    event.preventDefault();
    for (const control of Object.values(controls)) control.value = '';
    update(); controls.q.focus();
  });
  window.addEventListener('popstate', () => { restore(); update(false); });
  restore(); update(false);
}
if (document.querySelector('[data-sheafpedia-return]')) {
  const current = new URLSearchParams(location.search);
  const params = new URLSearchParams();
  for (const key of objectQueryKeys) if (current.has(key)) params.set(key, current.get(key));
  for (const link of document.querySelectorAll('[data-sheafpedia-return], .note-pagination [data-object-link]')) {
    const url = new URL(link.href); url.search = params.toString(); link.href = url.href;
  }
}
