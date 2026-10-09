import test from 'node:test';
import assert from 'node:assert/strict';
import { parseHTML } from 'linkedom';
import { homePage, notesPage, geopediaPage } from '../src/render.mjs';

const site = {
  title: 'Test website', author: 'Example author', description: 'A personal website.',
  url: 'https://example.com', base: '/personal/',
  profile: {
    name: 'A < B', role: 'Research & writing',
    about: ['First paragraph.', 'Second paragraph.'], interests: ['Algebra', 'Geometry'],
    links: [{ label: 'Contact', url: 'mailto:author@example.com' }],
  },
};

test('the personal homepage uses configurable text and separate, base-aware collection routes', () => {
  const page = parseHTML(homePage(site)).document;
  assert.equal(page.documentElement.lang, 'en');
  assert.equal(page.querySelector('h1').textContent, 'A < B');
  assert.equal(page.querySelector('h1 b'), null);
  assert.deepEqual([...page.querySelectorAll('.profile-prose p')].map(p => p.textContent), site.profile.about);
  assert.deepEqual([...page.querySelectorAll('.profile-interests li')].map(li => li.textContent), site.profile.interests);
  assert.equal(page.querySelector('.profile-links a').getAttribute('href'), 'mailto:author@example.com');
  assert.deepEqual([...page.querySelectorAll('.site-header nav a')].map(a => [a.textContent, a.getAttribute('href')]), [
    ['Home', '/personal/'], ['Notes', '/personal/notes/'], ['Encyclopedia', '/personal/geopedia/'],
  ]);
  assert.equal(page.querySelector('.site-header [aria-current]').textContent, 'Home');
  assert.equal(page.querySelector('link[rel=canonical]').getAttribute('href'), 'https://example.com/personal/');
  assert.equal(page.querySelector('img, .directory-browser'), null);
  for (const a of page.querySelectorAll('a[href^="#"]')) assert.ok(page.getElementById(a.getAttribute('href').slice(1)));
  const fallback = parseHTML(homePage({ ...site, profile: {} })).document;
  assert.equal(fallback.querySelector('h1').textContent, site.author);
  assert.equal(fallback.querySelector('.profile-prose, .profile-interests, .profile-links'), null);
});

test('empty notes and encyclopedia pages are English and use their own navigation and canonical URL', () => {
  for (const [render, label, path, unit] of [[notesPage, 'Notes', 'notes', 'notes'], [geopediaPage, 'Encyclopedia', 'geopedia', 'entries']]) {
    const page = parseHTML(render(site, [])).document;
    assert.equal(page.documentElement.lang, 'en');
    assert.equal(page.querySelector('h1').textContent, label);
    assert.equal(page.querySelector('.site-header [aria-current]').textContent, label);
    assert.equal(page.querySelector('.directory-empty').textContent, `No ${unit} yet.`);
    assert.equal(page.querySelector('link[rel=canonical]').getAttribute('href'), `https://example.com/personal/${path}/`);
    assert.equal(page.querySelector('img'), null);
  }
});
