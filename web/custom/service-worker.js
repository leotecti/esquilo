// Valores substituídos por web/build.mjs a partir do conteúdo da exportação.
const VERSION = '__BUILD_VERSION__';
const ASSETS = __ASSET_MANIFEST__;
const BASE = new URL('./', self.location.href);
const PREFIX = `tico-${BASE.pathname}-`;
const CACHE = PREFIX + VERSION;
const META_URL = new URL('__tico_assets__.json', BASE).href;
const URLS = ASSETS.map(asset => new URL(asset.name, BASE).href);

async function notifyProgress(detail) {
  const clients = await self.clients.matchAll({type:'window',includeUncontrolled:true});
  for (const client of clients) client.postMessage({type:'UPDATE_PROGRESS',version:VERSION,...detail});
}

async function cacheResponseWithProgress(cache, asset, response, state) {
  if (!response.ok) throw new Error(`Falha ao baixar ${asset.name}: ${response.status}`);
  if (!response.body) {
    await cache.put(new URL(asset.name,BASE),response);
    state.doneBytes += asset.size;
    return;
  }
  const tracker = new TransformStream({transform(chunk,controller) {
    state.doneBytes += chunk.byteLength;
    const now = Date.now();
    if (now-state.lastNotice>120) {
      state.lastNotice = now;
      notifyProgress({...state,phase:'download',file:asset.name});
    }
    controller.enqueue(chunk);
  }});
  const tracked = new Response(response.body.pipeThrough(tracker),{
    status:response.status,statusText:response.statusText,headers:response.headers
  });
  await cache.put(new URL(asset.name,BASE),tracked);
}

self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE);
    const previousNames = (await caches.keys()).filter(name => name.startsWith(PREFIX) && name!==CACHE);
    const previous = previousNames.length ? await caches.open(previousNames.at(-1)) : null;
    let previousAssets = {};
    if (previous) {
      const metadata = await previous.match(META_URL);
      if (metadata) {
        try { previousAssets = Object.fromEntries((await metadata.json()).map(asset => [asset.name,asset])); }
        catch { previousAssets = {}; }
      }
    }
    const state = {
      done:0,total:ASSETS.length,doneBytes:0,
      totalBytes:ASSETS.reduce((sum,asset) => sum+asset.size,0),
      reused:0,downloaded:0,lastNotice:0
    };
    await notifyProgress({...state,phase:'start',file:''});
    let completedBytes = 0;
    for (const asset of ASSETS) {
      const url = new URL(asset.name,BASE);
      const old = previousAssets[asset.name];
      const reusable = previous && old?.hash===asset.hash && old?.size===asset.size;
      if (reusable) {
        const response = await previous.match(url);
        if (response) {
          await cache.put(url,response);
          state.reused += 1;
          state.doneBytes += asset.size;
        } else {
          await cacheResponseWithProgress(cache,asset,await fetch(new Request(url,{cache:'reload'})),state);
          state.downloaded += 1;
        }
      } else {
        await cacheResponseWithProgress(cache,asset,await fetch(new Request(url,{cache:'reload'})),state);
        state.downloaded += 1;
      }
      state.done += 1;
      completedBytes += asset.size;
      state.doneBytes = Math.max(state.doneBytes,completedBytes);
      await notifyProgress({...state,phase:'prepare',file:asset.name});
    }
    await cache.put(META_URL,new Response(JSON.stringify(ASSETS),{headers:{'Content-Type':'application/json'}}));
    await notifyProgress({...state,phase:'ready',file:''});
  })());
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
  if (event.data?.type === 'ACTIVATE_UPDATE') event.waitUntil(self.skipWaiting());
});
