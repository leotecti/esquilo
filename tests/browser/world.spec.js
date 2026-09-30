import {test,expect} from '@playwright/test';
const snapshot = page => page.evaluate(()=>window.__ticoTest);
async function boot(page) {
  await page.goto('./?test=1');
  await page.locator('#play').click();
  await expect.poll(async()=>(await snapshot(page))?.stage,{timeout:45000}).toBe(8);
}
async function ground(page) {await expect.poll(async()=>{const s=await snapshot(page);return s.grounded||s.completed;},{timeout:8000}).toBe(true);}
async function walk(page,x,left=false) {
  const key=left?'ArrowLeft':'ArrowRight'; await page.keyboard.down(key);
  await expect.poll(async()=>{const s=await snapshot(page);return s.completed||(left?s.x<=x:s.x>=x);},{timeout:18000,intervals:[40]}).toBe(true);
  await page.keyboard.up(key);
}
async function traverse(page) {
  await page.keyboard.down('ArrowRight');
  let until=0;
  const deadline=Date.now()+45000;
  while(Date.now()<deadline) {
    const s=await snapshot(page); if(s.completed)break;
    if(until && Date.now()>=until){await page.keyboard.up('Space');until=0;}
    else if(!until && s.grounded){await page.keyboard.down('Space');until=Date.now()+450;}
    await page.waitForTimeout(60);
  }
  await page.keyboard.up('Space');await page.keyboard.up('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);
}
async function clickRect(page,name,touch=false) {
  const s=await snapshot(page),r=s[name],v=page.viewportSize();
  const x=(r[0]+r[2]/2)*v.width/s.width,y=(r[1]+r[3]/2)*v.height/s.height;
  if(touch)await page.touchscreen.tap(x,y);else await page.mouse.click(x,y);
}
async function advance(page,index) {
  await clickRect(page,'next_rect');
  await expect.poll(async()=>(await snapshot(page)).world_stage).toBe(index);
  await ground(page);
}
function errorsFor(page) {
  const errors=[];
  page.on('pageerror',e=>errors.push(e.message));
  page.on('console',m=>{if(m.type()==='error')errors.push(m.text());});
  return errors;
}

test('Mundo 1 inteiro: três fases, resgate, Guardião, save e offline',async({page,context})=>{
  test.setTimeout(240000);
  const errors=errorsFor(page);
  await boot(page);
  expect((await snapshot(page)).world_stage).toBe(0);
  await page.keyboard.press('q');expect((await snapshot(page)).character).toBe('Tico');
  await page.screenshot({path:'builds/web/etapa8-primeiros-passos.png'});
  await traverse(page);await advance(page,1);
  await page.screenshot({path:'builds/web/etapa8-blocos.png'});
  await traverse(page);await advance(page,2);
  await walk(page,445);await ground(page);
  await page.screenshot({path:'builds/web/etapa8-resgate.png'});
  await page.keyboard.down('Space');
  await expect.poll(async()=>(await snapshot(page)).rescued).toBe(true);
  await page.keyboard.up('Space');await ground(page);
  await walk(page,770);await ground(page);await page.keyboard.press('q');
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).gate_open,{timeout:15000}).toBe(true);
  await page.keyboard.up('ArrowRight');await page.keyboard.press('q');
  await page.keyboard.down('Space');await walk(page,1280);await page.keyboard.up('Space');
  await walk(page,2020);await ground(page);await page.keyboard.press('q');
  await walk(page,2110);await page.keyboard.press('e');
  await expect.poll(async()=>(await snapshot(page)).heavy_broken).toBe(true);
  await expect.poll(async()=>(await snapshot(page)).ability).toBe('ready');
  await page.keyboard.down('Space');await walk(page,2720);await page.keyboard.up('Space');
  await walk(page,3070);await ground(page);await page.keyboard.press('q');
  await walk(page,3200);
  for(const x of [3370,3510,3650]) {
    await page.keyboard.down('Space');await walk(page,x);await page.keyboard.up('Space');await ground(page);
  }
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);
  await advance(page,3);await walk(page,2520);await ground(page);await page.keyboard.press('q');
  for(let hit=0;hit<3;hit++) {
    await expect.poll(async()=>(await snapshot(page)).boss_phase,{timeout:12000,intervals:[50]}).toBe('tired');
    await walk(page,2650);await page.keyboard.press('e');
    await expect.poll(async()=>(await snapshot(page)).boss_health).toBe(2-hit);
    await expect.poll(async()=>(await snapshot(page)).ability).toBe('ready');
    if(hit<2) {
      await walk(page,2520,true);
      expect((await snapshot(page)).health).toBe(3);
    }
  }
  await page.screenshot({path:'builds/web/etapa8-guardiao.png'});
  await walk(page,3510);
  await expect.poll(async()=>(await snapshot(page)).world_finished).toBe(true);
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);
  await page.screenshot({path:'builds/web/etapa8-final.png'});
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await page.close();await context.setOffline(true);
  const offline=await context.newPage();await boot(offline);
  await expect.poll(async()=>(await snapshot(offline)).world_finished).toBe(true);
  expect((await snapshot(offline)).boss_health).toBe(0);
  expect(errors).toEqual([]);
});

test('toque: primeira fase, multitoque, pausa, áudio e rotação',async({browser})=>{
  test.setTimeout(120000);
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true});
  const page=await context.newPage();const errors=errorsFor(page);
  await page.goto('http://127.0.0.1:8080/tico/?test=1');await page.locator('#play').tap();
  await expect.poll(async()=>(await snapshot(page))?.stage,{timeout:45000}).toBe(8);
  const s=await snapshot(page),cdp=await context.newCDPSession(page);
  const points=names=>names.map((name,i)=>({id:i+1,x:(s.buttons[name][0]+64)*844/s.width,y:(s.buttons[name][1]+64)*390/s.height}));
  await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:points(['Right','Jump'])});
  await expect.poll(async()=>(await snapshot(page)).state).toBe('glide');
  await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
  await page.keyboard.press('Escape');
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await clickRect(page,'music_rect',true);
  await expect.poll(async()=>(await snapshot(page)).music_enabled).toBe(false);
  await page.keyboard.press('Escape');
  await page.screenshot({path:'builds/web/etapa8-touch.png'});
  await page.setViewportSize({width:390,height:844});
  await expect(page.locator('#rotate')).toBeVisible();
  await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await page.setViewportSize({width:844,height:390});
  await page.keyboard.press('Escape');
  let jumping=false,until=0;
  await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:points(['Right'])});
  const deadline=Date.now()+45000;
  while(Date.now()<deadline) {
    const current=await snapshot(page);if(current.completed)break;
    if(jumping && Date.now()>until) {
      await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
      await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:points(['Right'])});jumping=false;
    } else if(!jumping && current.grounded) {
      await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
      await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:points(['Right','Jump'])});jumping=true;until=Date.now()+450;
    }
    await page.waitForTimeout(60);
  }
  await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);
  await clickRect(page,'next_rect',true);
  await expect.poll(async()=>(await snapshot(page)).world_stage).toBe(1);
  expect((await snapshot(page)).music_enabled).toBe(false);
  expect(errors).toEqual([]);await context.close();
});

test('save danificado é preservado; nova aventura precisa de confirmação',async({page})=>{
  await page.addInitScript(()=>{
    if(!localStorage.getItem('seeded')) {
      localStorage.setItem('tico.world1.v1','{"save_version":999}');localStorage.setItem('seeded','1');
    }
  });
  await boot(page);
  expect((await snapshot(page)).save_state).toBe('incompatible');
  expect(await page.evaluate(()=>localStorage.getItem('tico.world1.v1'))).toBe('{"save_version":999}');
  await clickRect(page,'restart_rect');
  await expect.poll(async()=>(await snapshot(page)).restart_confirmation).toBe(true);
  await clickRect(page,'cancel_rect');
  await expect.poll(async()=>(await snapshot(page)).restart_confirmation).toBe(false);
  expect(await page.evaluate(()=>localStorage.getItem('tico.world1.v1'))).toBe('{"save_version":999}');
  await clickRect(page,'restart_rect');
  await expect.poll(async()=>(await snapshot(page)).restart_confirmation).toBe(true);
  await clickRect(page,'confirm_rect');
  await expect.poll(async()=>(await snapshot(page)).save_state).toBe('saved');
  expect((await snapshot(page)).world_stage).toBe(0);
});

test('toque na fase 1-3: resgate, troca, esforço e passadas',async({browser})=>{
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true});
  await context.addInitScript(()=>{
    const state={character:'Tico',checkpoint:false,completed:false,rescued:false,items:[],blocks:[],stone:850,gate:false,heavy:false,secret:false,boss_done:false};
    localStorage.setItem('tico.world1.v1',JSON.stringify({save_version:1,stage:2,unlocked:2,finished:false,
      settings:{music:false,effects:false},levels:{'0':{...state,completed:true},'1':{...state,completed:true},'2':state}}));
  });
  const page=await context.newPage(),errors=errorsFor(page);
  await page.goto('http://127.0.0.1:8080/tico/?test=1');await page.locator('#play').tap();
  await expect.poll(async()=>(await snapshot(page))?.world_stage,{timeout:45000}).toBe(2);
  const s=await snapshot(page),cdp=await context.newCDPSession(page);
  const ids={Right:1,Jump:2,Action:3};
  let touching=false;
  async function hold(names) {
    if(touching)await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
    if(names.length)await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:names.map(name=>({id:ids[name],x:(s.buttons[name][0]+64)*844/s.width,y:(s.buttons[name][1]+64)*390/s.height}))});
    touching=names.length>0;
  }
  await hold(['Right']);await expect.poll(async()=>(await snapshot(page)).x,{intervals:[30]}).toBeGreaterThan(445);
  await hold([]);await ground(page);
  await hold(['Jump']);await expect.poll(async()=>(await snapshot(page)).rescued).toBe(true);
  await hold([]);await ground(page);
  expect(await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.world1.v1')).levels['2'].rescued)).toBe(true);
  await hold(['Right']);await expect.poll(async()=>(await snapshot(page)).pose).toBe('push_attempt');
  expect((await snapshot(page)).stone_x).toBeCloseTo(850,0);
  await hold([]);await clickRect(page,'switch_rect',true);
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
  await hold(['Right']);await expect.poll(async()=>(await snapshot(page)).pose).toBe('push');
  const frames=new Set();
  for(let i=0;i<8;i++){frames.add((await snapshot(page)).push_frame);await page.waitForTimeout(100);}
  expect(frames.size).toBeGreaterThan(1);
  await page.screenshot({path:'builds/web/etapa8-pipo-touch.png'});
  await expect.poll(async()=>(await snapshot(page)).gate_open,{timeout:10000}).toBe(true);
  await hold([]);await hold(['Action']);
  await expect.poll(async()=>(await snapshot(page)).ability,{intervals:[30]}).not.toBe('ready');
  await hold([]);expect(errors).toEqual([]);await context.close();
});
