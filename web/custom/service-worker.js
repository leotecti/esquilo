// Valores substituídos por web/build.mjs a partir do conteúdo da exportação.
const VERSION = '__BUILD_VERSION__';
const FILES = __PRECACHE_FILES__;
const BASE = new URL('./', self.location.href);
const PREFIX = `tico-${BASE.pathname}-`;
const CACHE = PREFIX + VERSION;
const URLS = FILES.map(name => new URL(name, BASE).href);

self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(URLS.map(url => new Request(url, {cache:'reload'})))));
});
self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    for (const name of await caches.keys()) {
      if (name.startsWith(PREFIX) && name !== CACHE) await caches.delete(name);
    }
    await self.clients.claim();
  })());
});
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  if (event.request.method !== 'GET' || url.origin !== BASE.origin || !url.pathname.startsWith(BASE.pathname)) return;
  const navigation = event.request.mode === 'navigate';
  const key = navigation ? new URL('index.html', BASE).href : url.origin + url.pathname;
  if (!navigation && !URLS.includes(key)) return;
  event.respondWith((async () => {
    const cached = await (await caches.open(CACHE)).match(key);
    if (cached) return cached;
    try { return await fetch(event.request); }
    catch (error) {
      if (navigation) return (await caches.match(new URL('index.offline.html', BASE).href)) || Response.error();
      throw error;
    }
  })());
});
self.addEventListener('message', event => {
  // Atualizações só substituem uma partida aberta após ação explícita no botão.
  if (event.data?.type === 'ACTIVATE_UPDATE') event.waitUntil(self.skipWaiting());
});
