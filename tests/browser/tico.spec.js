import {test,expect} from '@playwright/test';

async function boot(page) {
  await page.goto('./?test=1');
  await page.getByRole('button',{name:'Jogar',exact:true}).click();
  await expect.poll(()=>page.evaluate(()=>Boolean(window.__ticoTest)),{timeout:45000}).toBe(true);
  await expect(page.locator('#boot')).toBeHidden();
}
async function snapshot(page) { return page.evaluate(()=>window.__ticoTest); }

test('teclado, salto, planar, pausa e abertura em tela cheia',async({page})=>{
  const errors=[]; page.on('pageerror',e=>errors.push(e.message));
  page.on('console',m=>{if(m.type()==='error') errors.push(m.text());});
  await boot(page);
  await expect(page.locator('#fullscreen')).toHaveCount(0);
  if(await page.evaluate(()=>document.fullscreenEnabled))
    await expect.poll(()=>page.evaluate(()=>Boolean(document.fullscreenElement))).toBe(true);
  const initial=await snapshot(page);
  expect(initial.health).toBe(3);
  expect(initial.total_nuts).toBe(13);
  expect(initial.hud_width).toBe(initial.width);
  expect(initial.bar_width).toBeGreaterThan(initial.width-100);
  expect(initial.touch).toBe(false);
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).x).toBeGreaterThan(initial.x+70);
  await page.keyboard.up('ArrowRight');
  await page.keyboard.down('Space');
  await expect.poll(async()=>(await snapshot(page)).state).toBe('glide');
  await page.keyboard.up('Space');
  await page.keyboard.press('Escape');
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await page.keyboard.press('Escape');
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(false);
  await page.screenshot({path:'builds/web/preview-desktop.png'});
  expect(errors).toEqual([]);
});

test('manifesto, cache completo e reabertura offline',async({page,context})=>{
  await boot(page);
  await expect.poll(()=>page.evaluate(()=>Boolean(navigator.serviceWorker.controller)),{timeout:45000}).toBe(true);
  await expect(page.locator('#update')).toBeHidden();
  const cdp=await context.newCDPSession(page);
  const installability=await cdp.send('Page.getInstallabilityErrors');
  // Os contextos isolados do Playwright são anônimos e não permitem instalar.
  expect(installability.installabilityErrors.filter(e=>e.errorId!=='in-incognito')).toEqual([]);
  const manifest=await page.evaluate(async()=>fetch('index.manifest.json').then(r=>r.json()));
  expect(manifest.start_url).toBe('./'); expect(manifest.scope).toBe('./');
  expect(manifest.display).toBe('fullscreen'); expect(manifest.orientation).toBe('landscape');
  const cached=await page.evaluate(async()=>{
    const names=await caches.keys();
    return (await (await caches.open(names.find(n=>n.startsWith('tico-/tico/-')))).keys()).map(r=>r.url);
  });
  for (const file of ['index.html','index.wasm','index.pck','index.js','index.manifest.json','icon-192.png','icon-512.png'])
    expect(cached.some(url=>url.endsWith('/'+file))).toBe(true);
  await page.close(); await context.setOffline(true);
  const offline=await context.newPage(); await boot(offline);
  const x=(await snapshot(offline)).x;
  await offline.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(offline)).x).toBeGreaterThan(x+50);
  await offline.keyboard.up('ArrowRight');
});

test('celular emulado: multitoque, planar, pausa, rotação e alvos',async({browser})=>{
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true,deviceScaleFactor:1});
  const page=await context.newPage();
  await page.goto('http://127.0.0.1:8080/tico/?test=1');
  await page.getByRole('button',{name:'Jogar',exact:true}).tap();
  await expect.poll(()=>page.evaluate(()=>Boolean(window.__ticoTest)),{timeout:45000}).toBe(true);
  const s=await snapshot(page); expect(s.touch).toBe(true);
  expect(s.hud_width).toBe(s.width);
  expect(s.bar_width).toBeGreaterThan(s.width-100);
  const point=(name,id)=>({id,x:(s.buttons[name][0]+64)*844/s.width,y:(s.buttons[name][1]+64)*390/s.height});
  expect(128*390/s.height).toBeGreaterThanOrEqual(44);
  const cdp=await context.newCDPSession(page);
  await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:[point('Right',1),point('Jump',2)]});
  await expect.poll(async()=>(await snapshot(page)).right).toBe(true);
  await expect.poll(async()=>(await snapshot(page)).jump).toBe(true);
  await expect.poll(async()=>(await snapshot(page)).state).toBe('glide');
  expect((await snapshot(page)).x).toBeGreaterThan(s.x+50);
  await page.screenshot({path:'builds/web/preview-touch.png'});
  await cdp.send('Input.dispatchTouchEvent',{type:'touchCancel',touchPoints:[]});
  await expect.poll(async()=>(await snapshot(page)).right).toBe(false);
  await expect.poll(async()=>(await snapshot(page)).jump).toBe(false);
  await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:[point('Action',3)]});
  await expect.poll(async()=>(await snapshot(page)).action).toBe(true);
  await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
  await expect.poll(async()=>(await snapshot(page)).action).toBe(false);
  await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:[point('Right',4)]});
  await expect.poll(async()=>(await snapshot(page)).right).toBe(true);
  await page.keyboard.press('Escape');
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await expect.poll(async()=>(await snapshot(page)).right).toBe(false);
  await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
  await page.keyboard.press('Escape');
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(false);
  expect((await snapshot(page)).right).toBe(false);
  await page.setViewportSize({width:390,height:844});
  await expect(page.locator('#rotate')).toBeVisible();
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await page.setViewportSize({width:844,height:390});
  await expect(page.locator('#rotate')).toBeHidden();
  await page.keyboard.press('Escape');
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(false);
  await context.close();
});

test('dupla: pedra, túnel, investida, faro, chegada e nova partida',async({page})=>{
  const errors=[];
  page.on('console',m=>{if(m.type()==='error') errors.push(m.text());});
  await boot(page);
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).x).toBeGreaterThan(320);
  await page.keyboard.down('Space');
  await expect.poll(async()=>(await snapshot(page)).x).toBeGreaterThan(720);
  await page.keyboard.up('Space');
  await page.keyboard.up('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).grounded).toBe(true);
  await page.keyboard.press('q');
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).gate_open,{timeout:15000}).toBe(true);
  await page.keyboard.up('ArrowRight');
  await page.keyboard.press('q');
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Tico');
  await page.keyboard.down('ArrowRight'); await page.keyboard.down('Space');
  await expect.poll(async()=>(await snapshot(page)).x,{timeout:12000}).toBeGreaterThan(1280);
  await page.keyboard.up('Space');
  await expect.poll(async()=>(await snapshot(page)).x,{timeout:10000}).toBeGreaterThan(2020);
  await page.keyboard.up('ArrowRight');
  expect((await snapshot(page)).checkpoint).toBe(false);
  await expect.poll(async()=>(await snapshot(page)).grounded).toBe(true);
  await page.keyboard.press('q');
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).x).toBeGreaterThan(2110);
  await page.keyboard.up('ArrowRight');
  await page.keyboard.press('e');
  await expect.poll(async()=>(await snapshot(page)).heavy_broken).toBe(true);
  await expect.poll(async()=>(await snapshot(page)).ability).toBe('ready');
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).secret_revealed,{timeout:10000}).toBe(true);
  await page.screenshot({path:'builds/web/preview-etapa7-faro.png'});
  await expect.poll(async()=>(await snapshot(page)).checkpoint,{timeout:10000}).toBe(true);
  await page.keyboard.up('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).grounded).toBe(true);
  await page.keyboard.press('q');
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Tico');
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).x,{intervals:[50]}).toBeGreaterThan(3200);
  await page.keyboard.up('ArrowRight');
  for (const target of [3370,3510,3650]) {
    await page.keyboard.down('Space'); await page.keyboard.down('ArrowRight');
    await expect.poll(async()=>{const s=await snapshot(page);return s.completed || s.x>target;},{intervals:[50],timeout:8000}).toBe(true);
    await page.keyboard.up('ArrowRight'); await page.keyboard.up('Space');
    await page.waitForTimeout(1100);
  }
  await expect.poll(async()=>(await snapshot(page)).completed,{timeout:10000}).toBe(true);
  await page.keyboard.up('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).completed).toBe(true);
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);
  expect((await snapshot(page)).nuts).toBeGreaterThan(0);
  await page.screenshot({path:'builds/web/preview-etapa7-final.png'});
  // Botão Jogar de novo no painel central do canvas.
  await page.mouse.click(640,440);
  await expect.poll(async()=>(await snapshot(page)).restart_confirmation).toBe(true);
  const r=(await snapshot(page)).confirm_rect;
  await page.mouse.click(r[0]+r[2]/2,r[1]+r[3]/2);
  await expect.poll(async()=>(await snapshot(page)).completed).toBe(false);
  await expect.poll(async()=>(await snapshot(page)).nuts).toBe(0);
  expect((await snapshot(page)).health).toBe(3);
  expect(errors).toEqual([]);
});

test('Pipo no touch: trocar, investir com direção e cancelar contatos',async({browser})=>{
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true});
  const page=await context.newPage();
  const errors=[];page.on('console',m=>{if(m.type()==='error') errors.push(m.text());});
  await page.goto('http://127.0.0.1:8080/tico/?test=1');
  await page.locator('#play').tap();
  await expect.poll(()=>page.evaluate(()=>window.__ticoTest?.grounded),{timeout:45000}).toBe(true);
  let s=await snapshot(page);
  const r=s.switch_rect;
  expect(r[3]*390/s.height).toBeGreaterThanOrEqual(44);
  await page.touchscreen.tap((r[0]+r[2]/2)*844/s.width,(r[1]+r[3]/2)*390/s.height);
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
  s=await snapshot(page);
  const point=(name,id)=>({id,x:(s.buttons[name][0]+64)*844/s.width,y:(s.buttons[name][1]+64)*390/s.height});
  const cdp=await context.newCDPSession(page);
  await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:[point('Right',1),point('Action',2)]});
  await expect.poll(async()=>(await snapshot(page)).ability,{intervals:[30,50,100]}).toBe('prepare');
  await expect.poll(async()=>(await snapshot(page)).ability,{intervals:[30,50,100]}).toBe('charge');
  await page.screenshot({path:'builds/web/preview-etapa7-pipo-touch.png'});
  await cdp.send('Input.dispatchTouchEvent',{type:'touchCancel',touchPoints:[]});
  await expect.poll(async()=>(await snapshot(page)).right).toBe(false);
  await expect.poll(async()=>(await snapshot(page)).action).toBe(false);
  await expect.poll(async()=>(await snapshot(page)).ability).toBe('ready');
  await page.touchscreen.tap((r[0]+r[2]/2)*844/s.width,(r[1]+r[3]/2)*390/s.height);
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Tico');
  expect(errors).toEqual([]);
  await context.close();
});
