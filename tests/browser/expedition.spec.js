import {test,expect} from '@playwright/test';
const snapshot=page=>page.evaluate(()=>window.__ticoTest);
const devices={4:[],5:['Tronco'],6:['Ponte'],7:[],8:[],9:['Rocha'],10:[],11:[],12:['Peso'],13:['Comporta'],14:['Tora','Roda','Engrenagem'],15:['Arena']};
function fixture(index) {
  const levels={};
  for(let i=0;i<=index;i++) levels[i]={character:'Tico',checkpoint:false,completed:i<index,rescued:i>=2,items:[],blocks:[],stone:i===2?1110:850,gate:i===2,heavy:i===2,secret:false,boss_done:i<index&&i%4===3,
    ...(i>=4?{mechanisms:Object.fromEntries(devices[i].map(id=>[id,i<index]))}:{})};
  return {save_version:1,stage:index,unlocked:index,finished:false,settings:{music:false,effects:false},levels};
}
async function seed(page,data,key='tico.campaign.v1') {
  await page.addInitScript(({data,key})=>{if(!sessionStorage.getItem('seeded')){localStorage.setItem(key,JSON.stringify(data));sessionStorage.setItem('seeded','1');}},{data,key});
}
async function boot(page) {
  await page.goto('./?test=1');await page.locator('#play').click();
  await expect.poll(async()=>(await snapshot(page))?.stage,{timeout:45000}).toBe(9);
}
async function ground(page){await expect.poll(async()=>(await snapshot(page)).grounded,{timeout:10000}).toBe(true);}
async function walk(page,x){await page.keyboard.down('ArrowRight');await expect.poll(async()=>{const s=await snapshot(page);return s.x>=x||s.completed;},{timeout:18000,intervals:[30]}).toBe(true);await page.keyboard.up('ArrowRight');}
async function glide(page,x) {
  await page.keyboard.down('ArrowRight');let held=0;const deadline=Date.now()+25000;
  while(Date.now()<deadline) {
    const s=await snapshot(page);if(s.x>=x||s.completed)break;
    if(held&&((Date.now()-held>200&&s.grounded)||Date.now()-held>2500)){await page.keyboard.up('Space');held=0;}
    else if(!held&&s.grounded){await page.keyboard.down('Space');held=Date.now();}
    await page.waitForTimeout(30);
  }
  await page.keyboard.up('ArrowRight');await page.keyboard.up('Space');await ground(page);
  expect((await snapshot(page)).x).toBeGreaterThan(x-10);
}
async function clickRect(page,name,touch=false){const s=await snapshot(page),r=s[name],v=page.viewportSize();const x=(r[0]+r[2]/2)*v.width/s.width,y=(r[1]+r[3]/2)*v.height/s.height;if(touch)await page.touchscreen.tap(x,y);else await page.mouse.click(x,y);}
function errorsFor(page){const errors=[];page.on('pageerror',e=>errors.push(e.message));page.on('console',m=>{if(m.type()==='error')errors.push(m.text());});return errors;}

test('Bosque migra para Rio; percurso, checkpoint e reabertura offline',async({page,context})=>{
  test.setTimeout(150000);
  const old=fixture(3);old.levels['3'].completed=true;old.levels['3'].boss_done=true;old.finished=true;
  await seed(page,old,'tico.world1.v1');const errors=errorsFor(page);await boot(page);
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);await clickRect(page,'next_rect');
  await expect.poll(async()=>(await snapshot(page)).campaign_stage).toBe(4);
  await walk(page,565);await glide(page,1230);await walk(page,1510);await glide(page,2180);
  expect((await snapshot(page)).checkpoint).toBe(true);
  await page.screenshot({path:'builds/web/etapa9-rio.png'});
  await walk(page,2460);await glide(page,2940);await glide(page,3350);await walk(page,3590);
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);
  expect(await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.world1.v1')))).toEqual(old);
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await page.locator('#play').click();
  await expect.poll(async()=>(await snapshot(page))?.result,{timeout:45000}).toBe(true);
  expect((await snapshot(page)).campaign_stage).toBe(4);expect(errors).toEqual([]);
});

test('Montanha: subida, vento, planagem e saída',async({page})=>{
  test.setTimeout(100000);await seed(page,fixture(8));const errors=errorsFor(page);await boot(page);
  await glide(page,1030);await page.keyboard.down('Space');await walk(page,1740);await page.keyboard.up('Space');await ground(page);
  await page.screenshot({path:'builds/web/etapa9-montanha.png'});
  await walk(page,1920);await glide(page,2530);await walk(page,2730);await glide(page,3310);await walk(page,3590);
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);expect(errors).toEqual([]);
});

test('Vila no toque: peso, troca, elevador, multitoque, pausa e rotação',async({browser})=>{
  test.setTimeout(90000);
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true,baseURL:'http://127.0.0.1:8080/tico/'});
  const page=await context.newPage();await seed(page,fixture(12));const errors=errorsFor(page);await boot(page);
  const cdp=await context.newCDPSession(page);
  let touching=false;
  async function hold(names){if(touching)await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});const s=await snapshot(page);if(names.length)await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:names.map((name,i)=>({id:i+1,x:(s.buttons[name][0]+64)*844/s.width,y:(s.buttons[name][1]+64)*390/s.height}))});touching=names.length>0;}
  await hold(['Right']);await expect.poll(async()=>(await snapshot(page)).x,{intervals:[20]}).toBeGreaterThan(800);await hold([]);await ground(page);
  expect((await snapshot(page)).mechanisms.Peso).toBe(false);
  await clickRect(page,'switch_rect',true);await expect.poll(async()=>(await snapshot(page)).mechanisms.Peso).toBe(true);
  await page.screenshot({path:'builds/web/etapa9-vila-touch.png'});
  await clickRect(page,'switch_rect',true);await hold(['Right','Jump']);await expect.poll(async()=>(await snapshot(page)).state).toBe('glide');await hold([]);
  await page.keyboard.press('Escape');await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  const before=(await snapshot(page)).movers;await page.waitForTimeout(200);expect((await snapshot(page)).movers).toEqual(before);
  await clickRect(page,'music_rect',true);await page.keyboard.press('Escape');
  await page.setViewportSize({width:390,height:844});await expect(page.locator('#rotate')).toBeVisible();
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await page.setViewportSize({width:844,height:390});await page.reload();await page.locator('#play').tap();
  await expect.poll(async()=>(await snapshot(page))?.mechanisms?.Peso,{timeout:45000}).toBe(true);
  expect((await snapshot(page)).music_enabled).toBe(true);expect(errors).toEqual([]);await context.close();
});

test('Comporta: investida, drenagem e save',async({page})=>{
  await seed(page,fixture(13));const errors=errorsFor(page);await boot(page);await walk(page,650);await ground(page);await page.keyboard.press('q');
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');await page.keyboard.press('e');
  await expect.poll(async()=>(await snapshot(page)).mechanisms.Comporta).toBe(true);
  await page.reload();await page.locator('#play').click();await expect.poll(async()=>(await snapshot(page))?.mechanisms?.Comporta,{timeout:45000}).toBe(true);expect(errors).toEqual([]);
});

test('Save futuro fica intacto até confirmar nova aventura',async({page})=>{
  await seed(page,{save_version:999});await boot(page);expect((await snapshot(page)).save_state).toBe('incompatible');
  await clickRect(page,'restart_rect');await expect.poll(async()=>(await snapshot(page)).restart_confirmation).toBe(true);
  await clickRect(page,'cancel_rect');expect(await page.evaluate(()=>localStorage.getItem('tico.campaign.v1'))).toBe('{"save_version":999}');
  await clickRect(page,'restart_rect');await clickRect(page,'confirm_rect');await expect.poll(async()=>(await snapshot(page)).save_state).toBe('saved');expect((await snapshot(page)).campaign_stage).toBe(0);
});
