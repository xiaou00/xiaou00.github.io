import { compareNames, discoverNoteFiles, encodeNotePath, validateNotePath } from './note-paths.mjs';

export function sectionIdentity(filename) {
  validateNotePath(filename);
  const match = /^([^/]+)\/((\d{2,}) +([^/]+))\/(\d{2,})\.(\d+) +([^/]+)\.typ$/.exec(filename);
  const chapterNumber = match && Number(match[3]);
  const sectionNumber = match && Number(match[6]);
  if (!match || !match[4].trim() || !match[7].trim()
    || !Number.isSafeInteger(chapterNumber) || chapterNumber < 1
    || !Number.isSafeInteger(sectionNumber) || sectionNumber < 1) {
    throw new Error(`${filename}: 书籍小节应放在 "书名/01 章节名/01.1 小节名.typ", 章和节的编号从 1 开始.`);
  }
  if (Number(match[5]) !== chapterNumber) throw new Error(`${filename}: 小节编号的章号须与所在章节文件夹一致.`);
  return { book: match[1], chapterNumber, chapterTitle: `${chapterNumber} ${match[4].trim()}`,
    chapterSlug: `${match[1]}/${match[2]}`, sectionNumber, sectionTitle: match[7].trim(),
    title: `${chapterNumber}.${sectionNumber} ${match[7].trim()}`, notebook: match[1],
    slug: filename.slice(0, -4), filename };
}

export const compareBookSections = (a, b) => compareNames(a.book, b.book)
  || a.chapterNumber - b.chapterNumber || a.sectionNumber - b.sectionNumber;

export async function discoverBookFiles(root) {
  const files = await discoverNoteFiles(root);
  const chapters = new Map();
  const sections = new Set();
  for (const file of files) {
    const section = sectionIdentity(file);
    const chapterKey = `${section.book}/${section.chapterNumber}`;
    if (chapters.has(chapterKey) && chapters.get(chapterKey) !== section.chapterSlug) {
      throw new Error(`${file}: 同一本书的章号不能重复.`);
    }
    chapters.set(chapterKey, section.chapterSlug);
    const key = `${chapterKey}/${section.sectionNumber}`;
    if (sections.has(key)) throw new Error(`${file}: 同一章的小节编号不能重复.`);
    sections.add(key);
  }
  return files.sort((a, b) => compareBookSections(sectionIdentity(a), sectionIdentity(b)));
}

export function groupBooks(sections) {
  const groups = new Map();
  for (const section of [...sections].sort(compareBookSections)) {
    if (!groups.has(section.book)) groups.set(section.book, { title: section.book, chapters: [], sections: [] });
    const book = groups.get(section.book);
    let chapter = book.chapters.find(chapter => chapter.slug === section.chapterSlug);
    if (!chapter) {
      chapter = { title: section.chapterTitle, number: section.chapterNumber, slug: section.chapterSlug, sections: [] };
      book.chapters.push(chapter);
    }
    chapter.sections.push(section);
    book.sections.push(section);
  }
  return [...groups.values()];
}

export const bookUrl = (site, book) => `${site.base}books/${encodeNotePath(book)}/`;
export const chapterUrl = (site, slug) => `${site.base}books/${encodeNotePath(slug)}/`;
