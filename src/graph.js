(() => {
  const data = document.getElementById('graph-data');
  if (!data) return;
  const graph = JSON.parse(data.textContent);
  if (!graph.nodes.length) return;

  const svg = document.querySelector('.graph-canvas');
  const search = document.getElementById('graph-search');
  const directory = document.querySelector('.graph-directory');
  const rows = [...directory.querySelectorAll('li')];
  const status = document.querySelector('[data-graph-status]');
  const reducedMotion = matchMedia('(prefers-reduced-motion: reduce)');
  const normalize = value => value.normalize('NFKC').toLowerCase();
  const create = (tag, attrs, parent) => {
    const element = document.createElementNS('http://www.w3.org/2000/svg', tag);
    for (const [name, value] of Object.entries(attrs)) element.setAttribute(name, value);
    parent.append(element);
    return element;
  };
  const layer = create('g', { class: 'graph-layer' }, svg);
  const edgeLayer = create('g', { 'aria-hidden': 'true' }, layer);
  const nodeLayer = create('g', {}, layer);
  const nodes = graph.nodes.map((node, index) => {
    const angle = index * Math.PI * (3 - Math.sqrt(5));
    const radius = 65 * Math.sqrt(index);
    return { ...node, index, x: Math.cos(angle) * radius, y: Math.sin(angle) * radius,
      vx: 0, vy: 0, fixed: false, neighbors: new Set(), search: normalize(`${node.title} ${node.path}`) };
  });
  const links = graph.links.map(({ source, target }) => {
    const a = nodes[source], b = nodes[target];
    a.neighbors.add(target);
    b.neighbors.add(source);
    return { a, b, element: create('line', { class: 'graph-edge' }, edgeLayer) };
  });
  for (const node of nodes) {
    const kind = node.collection === 'pedia' ? 'Encyclopedia' : 'Note';
    node.element = create('a', { href: node.url, class: `graph-node graph-node-${node.collection}`,
      'data-node': node.index, 'aria-label': `${node.title} — ${kind}`, tabindex: '0' }, nodeLayer);
    create('title', {}, node.element).textContent = `${node.title}\n${kind} · ${node.path}\n${node.neighbors.size} connections`;
    // A generous invisible hit area makes small nodes usable on touch screens.
    create('circle', { class: 'graph-hit', r: 18 }, node.element);
    const radius = 4 + Math.min(5, Math.sqrt(node.neighbors.size));
    create('circle', { class: 'graph-dot', r: radius }, node.element);
    create('text', { class: 'graph-label', x: radius + 7, y: 4 }, node.element).textContent = node.title;
  }

  let width = 0, height = 0;
  const camera = { x: 0, y: 0, k: 1 };
  let heat = 0.65, frame = 0, lastTime = 0;
  let hovered = null, matches = new Set(), searching = false;
  let drag = null, suppressClick = false;
  const pointers = new Map();
  const clamp = (value, min, max) => Math.max(min, Math.min(max, value));

  // Springs connect references. A spatial grid limits repulsion to nearby
  // nodes, avoiding an all-pairs calculation as the collection grows.
  function step(strength) {
    const cell = 200;
    const grid = new Map();
    for (const node of nodes) {
      const key = `${Math.floor(node.x / cell)},${Math.floor(node.y / cell)}`;
      if (!grid.has(key)) grid.set(key, []);
      grid.get(key).push(node);
      node.vx -= node.x * 0.001 * strength;
      node.vy -= node.y * 0.001 * strength;
    }
    for (const node of nodes) {
      const cx = Math.floor(node.x / cell), cy = Math.floor(node.y / cell);
      for (let x = cx - 1; x <= cx + 1; x++) for (let y = cy - 1; y <= cy + 1; y++) {
        for (const other of grid.get(`${x},${y}`) || []) {
          if (other.index <= node.index) continue;
          const dx = node.x - other.x || 0.1, dy = node.y - other.y || 0.1;
          const distance = Math.hypot(dx, dy);
          if (distance > cell) continue;
          const force = Math.min(5, 1800 / (distance * distance)) * strength / distance;
          node.vx += dx * force; node.vy += dy * force;
          other.vx -= dx * force; other.vy -= dy * force;
        }
      }
    }
    for (const { a, b } of links) {
      const dx = b.x - a.x, dy = b.y - a.y;
      const distance = Math.hypot(dx, dy) || 1;
      const force = (distance - 135) * 0.018 * strength / distance;
      a.vx += dx * force; a.vy += dy * force;
      b.vx -= dx * force; b.vy -= dy * force;
    }
    for (const node of nodes) {
      if (node.fixed) { node.vx = node.vy = 0; continue; }
      node.vx *= 0.65; node.vy *= 0.65;
      node.x += clamp(node.vx, -12, 12); node.y += clamp(node.vy, -12, 12);
    }
  }

  function draw() {
    layer.setAttribute('transform', `translate(${camera.x} ${camera.y}) scale(${camera.k})`);
    svg.classList.toggle('graph-hide-labels', nodes.length > 80 && camera.k < 0.8);
    for (const node of nodes) node.element.setAttribute('transform', `translate(${node.x.toFixed(2)} ${node.y.toFixed(2)})`);
    for (const { a, b, element } of links) {
      element.setAttribute('x1', a.x); element.setAttribute('y1', a.y);
      element.setAttribute('x2', b.x); element.setAttribute('y2', b.y);
    }
  }

  function animate(time) {
    frame = 0;
    if (document.hidden || reducedMotion.matches) return;
    if (time - lastTime >= 28) {
      lastTime = time;
      step(heat);
      heat *= 0.95;
      draw();
    }
    if (heat > 0.008) frame = requestAnimationFrame(animate);
  }
  function wake(strength = 0.3) {
    heat = Math.max(heat, strength);
    if (!frame && !document.hidden && !reducedMotion.matches) frame = requestAnimationFrame(animate);
  }
  function fit() {
    let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
    for (const node of nodes) {
      minX = Math.min(minX, node.x - 25);
      maxX = Math.max(maxX, node.x + Math.min(220, node.title.length * 7 + 25));
      minY = Math.min(minY, node.y - 25); maxY = Math.max(maxY, node.y + 25);
    }
    camera.k = clamp(Math.min((width - 40) / (maxX - minX), (height - 40) / (maxY - minY)), 0.04, 1.5);
    camera.x = width / 2 - (minX + maxX) / 2 * camera.k;
    camera.y = height / 2 - (minY + maxY) / 2 * camera.k;
    draw();
  }
  function zoom(point, factor) {
    const next = clamp(camera.k * factor, 0.04, 5);
    camera.x = point.x - (point.x - camera.x) * next / camera.k;
    camera.y = point.y - (point.y - camera.y) * next / camera.k;
    camera.k = next;
  }
  function highlight() {
    const active = hovered === null ? matches : new Set([hovered]);
    const neighbors = new Set(active);
    for (const index of active) for (const neighbor of nodes[index].neighbors) neighbors.add(neighbor);
    svg.classList.toggle('is-focused', hovered !== null || searching);
    for (const node of nodes) {
      node.element.classList.toggle('is-active', active.has(node.index));
      node.element.classList.toggle('is-neighbor', neighbors.has(node.index));
    }
    for (const link of links) link.element.classList.toggle('is-neighbor', active.has(link.a.index) || active.has(link.b.index));
  }
  const nodeAt = target => {
    const anchor = target.closest('[data-node]');
    return anchor ? Number(anchor.dataset.node) : null;
  };
  const pointAt = event => {
    const rect = svg.getBoundingClientRect();
    return { x: event.clientX - rect.left, y: event.clientY - rect.top };
  };
  const world = point => ({ x: (point.x - camera.x) / camera.k, y: (point.y - camera.y) / camera.k });

  svg.addEventListener('pointerdown', event => {
    if (event.button !== 0) return;
    const point = pointAt(event);
    pointers.set(event.pointerId, point);
    suppressClick = false;
    (event.target.closest('[data-node]') || svg).setPointerCapture(event.pointerId);
    if (pointers.size > 1) {
      if (drag && drag.index !== null) nodes[drag.index].fixed = false;
      drag = null; suppressClick = true;
      return;
    }
    const index = nodeAt(event.target), position = world(point);
    drag = { id: event.pointerId, index, start: point, last: point, moved: false,
      dx: index === null ? 0 : nodes[index].x - position.x,
      dy: index === null ? 0 : nodes[index].y - position.y };
    if (index !== null) nodes[index].fixed = true;
  });
  svg.addEventListener('pointermove', event => {
    if (!pointers.has(event.pointerId)) return;
    const before = [...pointers.values()];
    const point = pointAt(event);
    pointers.set(event.pointerId, point);
    if (pointers.size > 1) {
      const after = [...pointers.values()];
      const center = points => ({ x: (points[0].x + points[1].x) / 2, y: (points[0].y + points[1].y) / 2 });
      const distance = points => Math.hypot(points[0].x - points[1].x, points[0].y - points[1].y);
      const a = center(before), b = center(after);
      zoom(a, distance(after) / Math.max(1, distance(before)));
      camera.x += b.x - a.x; camera.y += b.y - a.y;
      draw();
      return;
    }
    if (!drag) drag = { id: event.pointerId, index: null, start: point, last: point, moved: true };
    drag.moved ||= Math.hypot(point.x - drag.start.x, point.y - drag.start.y) > 4;
    if (drag.moved) {
      suppressClick = true;
      if (drag.index === null) {
        camera.x += point.x - drag.last.x; camera.y += point.y - drag.last.y;
      } else {
        const node = nodes[drag.index], position = world(point);
        node.x = position.x + drag.dx; node.y = position.y + drag.dy;
        wake();
      }
      draw();
    }
    drag.last = point;
  });
  function release(event) {
    pointers.delete(event.pointerId);
    if (drag?.id === event.pointerId) {
      if (drag.index !== null) nodes[drag.index].fixed = false;
      if (drag.moved) wake();
      drag = null;
    }
    if (event.type === 'pointercancel') suppressClick = true;
  }
  svg.addEventListener('pointerup', release);
  svg.addEventListener('pointercancel', release);
  svg.addEventListener('click', event => {
    if (suppressClick && event.detail) { event.preventDefault(); return; }
  }, true);
  svg.addEventListener('pointerover', event => {
    if (pointers.size) return;
    const index = nodeAt(event.target);
    if (hovered !== index) { hovered = index; highlight(); }
  });
  svg.addEventListener('pointerleave', () => { hovered = null; highlight(); });
  svg.addEventListener('focusin', event => {
    const index = nodeAt(event.target);
    if (index !== null) {
      hovered = index;
      const node = nodes[index];
      if (!pointers.size) {
        camera.x = width / 2 - node.x * camera.k; camera.y = height / 2 - node.y * camera.k;
      }
      highlight(); draw();
    }
  });
  svg.addEventListener('focusout', () => { hovered = null; highlight(); });
  svg.addEventListener('wheel', event => {
    event.preventDefault();
    zoom(pointAt(event), Math.exp(-clamp(event.deltaY * (event.deltaMode ? 16 : 1), -150, 150) * 0.003));
    draw();
  }, { passive: false });
  svg.addEventListener('keydown', event => {
    if (event.target !== svg) return;
    const moves = { ArrowLeft: [40, 0], ArrowRight: [-40, 0], ArrowUp: [0, 40], ArrowDown: [0, -40] };
    if (moves[event.key]) { camera.x += moves[event.key][0]; camera.y += moves[event.key][1]; }
    else if (['+', '=', '-'].includes(event.key)) zoom({ x: width / 2, y: height / 2 }, event.key === '-' ? 0.8 : 1.25);
    else if (event.key === '0') fit();
    else return;
    event.preventDefault(); draw();
  });
  document.querySelector('[data-graph-fit]').addEventListener('click', fit);
  for (const button of document.querySelectorAll('[data-graph-zoom]')) button.addEventListener('click', () => {
    zoom({ x: width / 2, y: height / 2 }, button.dataset.graphZoom === 'in' ? 1.25 : 0.8); draw();
  });
  search.addEventListener('input', () => {
    const terms = normalize(search.value.trim()).split(/\s+/).filter(Boolean);
    searching = terms.length > 0;
    hovered = null;
    matches = new Set();
    for (const node of nodes) {
      const match = terms.every(term => node.search.includes(term));
      rows[node.index].hidden = !match;
      if (searching && match) matches.add(node.index);
    }
    document.querySelector('[data-graph-no-results]').hidden = !searching || matches.size > 0;
    directory.open = searching;
    status.textContent = searching ? `${matches.size} matching pages` : `${nodes.length} pages`;
    if (matches.size === 1) {
      const node = nodes[[...matches][0]];
      camera.k = Math.max(1, camera.k);
      camera.x = width / 2 - node.x * camera.k; camera.y = height / 2 - node.y * camera.k;
    } else if (!searching) fit();
    highlight(); draw();
  });

  for (let i = 0; i < (nodes.length > 500 ? 20 : 90); i++) step(0.8);
  document.querySelector('.graph-stage').hidden = false;
  document.querySelector('.graph-toolbar').hidden = false;
  document.getElementById('graph-help').hidden = false;
  directory.open = false;
  const resize = () => {
    const rect = svg.getBoundingClientRect();
    if (rect.width === width && rect.height === height) return;
    const initialized = width > 0;
    camera.x += (rect.width - width) / 2; camera.y += (rect.height - height) / 2;
    width = rect.width; height = rect.height;
    svg.setAttribute('viewBox', `0 0 ${width} ${height}`);
    if (initialized) draw(); else fit();
  };
  new ResizeObserver(resize).observe(svg);
  resize();
  wake();
  svg.dataset.ready = 'true';
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) { cancelAnimationFrame(frame); frame = 0; } else wake(0);
  });
})();
