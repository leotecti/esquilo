import {test,expect} from '@playwright/test';
import {writeFile} from 'node:fs/promises';
const snapshot=page=>page.evaluate(()=>window.__ticoTest);
async function boot(page) {
  await page.goto('./?test=1');await page.locator('#play').click();
  await expect.poll(async()=>(await snapshot(page))?.stage,{timeout:45000}).toBe(7);
}
async function clickRect(page,key) {
  const s=await snapshot(page),r=s[key];
  const viewport=page.viewportSize();
  await page.mouse.click((r[0]+r[2]/2)*viewport.width/s.width,(r[1]+r[3]/2)*viewport.height/s.height);
}

test('slice: menu de pausa, áudio, preferências e save anterior',async({page})=>{
  const errors=[];page.on('console',m=>{if(m.type()==='error')errors.push(m.text());});
  await page.goto('./');
  const old={save_version:1,level:'prototype_1',character:'Pipo',items:['330:715'],blocks:[],stone:850,gate:false,heavy:false,secret:false,checkpoint:false,completed:false};
  await page.evaluate(data=>localStorage.setItem('tico.progress.v1',JSON.stringify(data)),old);
  await boot(page);
  expect((await snapshot(page)).character).toBe('Pipo');
  expect((await snapshot(page)).nuts).toBe(1);
  expect((await snapshot(page)).music_enabled).toBe(true);
  await page.keyboard.press('Escape');
  await expect.poll(async()=>(await snapshot(page)).audio_paused).toBe(true);
  await clickRect(page,'music_rect');await clickRect(page,'effects_rect');
  await expect.poll(async()=>(await snapshot(page)).effects_enabled).toBe(false);
  expect((await snapshot(page)).music_enabled).toBe(false);
  await page.screenshot({path:'builds/web/preview-etapa7-pausa.png'});
  await boot(page);
  expect((await snapshot(page)).music_enabled).toBe(false);
  expect((await snapshot(page)).effects_enabled).toBe(false);
  expect((await snapshot(page)).nuts).toBe(1);
  expect(errors).toEqual([]);
});

test('slice: amostra de desempenho Web desktop',async({page})=>{
  await boot(page);
  await page.waitForTimeout(4000);
  await page.keyboard.down('ArrowRight');await page.keyboard.down('Space');
  await page.waitForTimeout(1600);
  await page.keyboard.up('Space');await page.keyboard.up('ArrowRight');
  await page.waitForTimeout(900);
  await page.keyboard.press('q');
  await page.keyboard.down('ArrowRight');await page.waitForTimeout(5500);await page.keyboard.up('ArrowRight');
  const s=await snapshot(page);
  expect(s.frame_ms_p95).toBeGreaterThan(0);
  expect(s.frame_ms_p95).toBeLessThan(150); // Detecta travamento grave; não certifica 60 FPS.
  await writeFile('builds/web/performance-etapa7.json',JSON.stringify({environment:'Chrome headless, SwiftShader, desktop 1280x720',p50_ms:s.frame_ms_p50,p95_ms:s.frame_ms_p95,draw_calls:s.draw_calls},null,2));
  await page.screenshot({path:'builds/web/preview-etapa7-bosque.png'});
});
