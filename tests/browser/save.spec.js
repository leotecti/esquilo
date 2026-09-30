import {test,expect,chromium} from '@playwright/test';
import {mkdtemp,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';

const url='http://127.0.0.1:8080/tico/?test=1';
const key='tico.progress.v1';
const snapshot=page=>page.evaluate(()=>window.__ticoTest);
async function boot(page) {
  await page.goto(url);
  await page.locator('#play').click();
  await expect.poll(async()=>Boolean(await snapshot(page)),{timeout:45000}).toBe(true);
}
async function collect(page) {
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).nuts,{intervals:[50]}).toBeGreaterThan(0);
  await page.keyboard.up('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).save_state).toBe('saved');
}

test('fechar navegador, abrir offline e retomar save do mesmo perfil',async()=>{
  const profile=await mkdtemp(join(tmpdir(),'tico-stage6-'));
  let context;
  try {
    const options={channel:'chrome',headless:true,viewport:{width:1280,height:720},args:['--enable-unsafe-swiftshader']};
    context=await chromium.launchPersistentContext(profile,options);
    let page=await context.newPage();
    await boot(page);
    await expect.poll(()=>page.evaluate(()=>Boolean(navigator.serviceWorker.controller)),{timeout:45000}).toBe(true);
    await collect(page);
    const nuts=(await snapshot(page)).nuts;
    await page.keyboard.press('q');
    await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
    const before=await page.evaluate(k=>localStorage.getItem(k),key);
    await context.close();
    context=await chromium.launchPersistentContext(profile,options);
    await context.setOffline(true);
    page=await context.newPage();
    await boot(page);
    await expect.poll(async()=>(await snapshot(page)).resumed).toBe(true);
    expect((await snapshot(page)).nuts).toBe(nuts);
    expect((await snapshot(page)).character).toBe('Pipo');
    expect((await snapshot(page)).x).toBeCloseTo(160,0);
    expect(await page.evaluate(k=>localStorage.getItem(k),key)).toBe(before);
    await page.keyboard.down('ArrowRight');
    await expect.poll(async()=>(await snapshot(page)).x).toBeGreaterThan(370);
    await page.keyboard.up('ArrowRight');
    expect((await snapshot(page)).nuts).toBe(nuts);
    await page.screenshot({path:'builds/web/preview-etapa6-save-offline.png'});
  } finally {
    await context?.close();
    await rm(profile,{recursive:true,force:true});
  }
});

test('atualizar o service worker preserva progresso',async({page})=>{
  await boot(page);
  await expect.poll(()=>page.evaluate(()=>Boolean(navigator.serviceWorker.controller)),{timeout:45000}).toBe(true);
  await collect(page);
  const before=await page.evaluate(k=>localStorage.getItem(k),key);
  // URL versionada percorre install/activate/claim; o shell recarrega
  // automaticamente quando o novo worker assume o controle.
  const reloaded=page.waitForEvent('framenavigated',{predicate:frame=>frame===page.mainFrame()});
  await page.evaluate(async()=>{
    const registration=await navigator.serviceWorker.register('index.service.worker.js?update-test=1',{scope:'./',updateViaCache:'none'});
    await registration.update();
    const worker=registration.waiting || registration.installing;
    if (worker) {
      if (worker.state!=='installed') await new Promise(resolve=>worker.addEventListener('statechange',()=>{if(worker.state==='installed') resolve();}));
      worker.postMessage({type:'ACTIVATE_UPDATE'});
    }
  });
  await reloaded;
  await page.locator('#play').click();
  await expect.poll(async()=>(await snapshot(page))?.resumed,{timeout:45000}).toBe(true);
  expect(await page.evaluate(k=>localStorage.getItem(k),key)).toBe(before);
});

for (const [name,raw] of [['danificado','{interrompido'],['versão futura',JSON.stringify({save_version:99})]]) {
  test(`save ${name}: abre sem sobrescrever dados`,async({page})=>{
    await page.goto(url);
    await page.evaluate(({key,raw})=>localStorage.setItem(key,raw),{key,raw});
    await boot(page);
    expect((await snapshot(page)).resumed).toBe(false);
    await page.keyboard.down('ArrowRight');
    await expect.poll(async()=>(await snapshot(page)).x).toBeGreaterThan(240);
    await page.keyboard.up('ArrowRight');
    expect(await page.evaluate(k=>localStorage.getItem(k),key)).toBe(raw);
  });
}

test('armazenamento indisponível permite jogar e informa falha',async({page})=>{
  await page.addInitScript(()=>{
    Storage.prototype.setItem=function(){throw new DOMException('Storage disabled','QuotaExceededError');};
  });
  await boot(page);
  await expect.poll(async()=>(await snapshot(page)).save_state).toBe('unavailable');
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).nuts).toBeGreaterThan(0);
  await page.keyboard.up('ArrowRight');
  await page.screenshot({path:'builds/web/preview-etapa6-save-unavailable.png'});
});
