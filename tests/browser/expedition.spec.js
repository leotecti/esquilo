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
  await page.goto('./?test=1');await startGame(page);
}
async function startGame(page,enter=true) {
  await page.locator('#play').click();
  await expect.poll(async()=>(await snapshot(page))?.stage,{timeout:45000}).toBe(9);
  if(enter&&(await snapshot(page)).map_open&&!(await snapshot(page)).game_over){
    await clickRect(page,'map_back_rect');
    await expect.poll(async()=>(await snapshot(page)).map_open).toBe(false);
  }
}
async function ground(page){await expect.poll(async()=>(await snapshot(page)).grounded,{timeout:10000}).toBe(true);}
async function walk(page,x){await page.keyboard.down('ArrowRight');await expect.poll(async()=>{const s=await snapshot(page);return s.x>=x||s.completed;},{timeout:18000,intervals:[30]}).toBe(true);await page.keyboard.up('ArrowRight');}
async function glide(page,x) {
  await page.keyboard.down('ArrowRight');let held=0;const deadline=Date.now()+25000;
  while(Date.now()<deadline) {
    const s=await snapshot(page);if(s.x>=x||s.completed)break;
    if(s.pose==='glide'&&!page.ticoGlideCaptured){
      await page.screenshot({path:'builds/web/e04-planagem.png'});page.ticoGlideCaptured=true;
    }
    if(held&&((Date.now()-held>200&&s.grounded)||Date.now()-held>2500)){await page.keyboard.up('Space');held=0;}
    else if(!held&&s.grounded){await page.keyboard.down('Space');held=Date.now();}
    await page.waitForTimeout(30);
  }
  await page.keyboard.up('ArrowRight');await page.keyboard.up('Space');await ground(page);
  expect((await snapshot(page)).x).toBeGreaterThan(x-10);
}
async function clickRect(page,name,touch=false){const s=await snapshot(page),r=s[name],v=page.viewportSize();const x=(r[0]+r[2]/2)*v.width/s.width,y=(r[1]+r[3]/2)*v.height/s.height;if(touch)await page.touchscreen.tap(x,y);else await page.mouse.click(x,y);}
function errorsFor(page){const errors=[];page.on('pageerror',e=>errors.push(e.message));page.on('console',m=>{if(m.type()==='error')errors.push(m.text());});return errors;}

async function clickMapRect(page,r,touch=false){const s=await snapshot(page),v=page.viewportSize();const x=(r[0]+r[2]/2)*v.width/s.width,y=(r[1]+r[3]/2)*v.height/s.height;if(touch)await page.touchscreen.tap(x,y);else await page.mouse.click(x,y);}
async function mapWorld(page,target,touch=false){
  for(let i=0;i<4;i++){
    const current=(await snapshot(page)).map_world;if(current===target)return;
    const next=(current+1)%4;await clickRect(page,'map_next_rect',touch);
    await expect.poll(async()=>(await snapshot(page)).map_world).toBe(next);
  }
  expect((await snapshot(page)).map_world).toBe(target);
}

test('E07: resultado final por toque, mapa e campanha preservada offline',async({browser})=>{
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true,baseURL:'http://127.0.0.1:8080/tico/'});
  const page=await context.newPage();const data=fixture(15);
  data.levels['15'].completed=true;data.levels['15'].boss_done=true;
  data.levels['15'].mechanisms.Arena=true;data.finished=true;
  await seed(page,data);const errors=errorsFor(page);await boot(page);
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);
  await page.screenshot({path:'builds/web/e07-resultado-touch.png'});
  await clickRect(page,'next_rect',true);
  await expect.poll(async()=>(await snapshot(page)).map_open).toBe(true);
  expect((await snapshot(page)).map_selected).toBe(15);
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await startGame(page,false);
  expect((await snapshot(page)).map_selected).toBe(15);
  expect(await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')).finished)).toBe(true);
  await clickRect(page,'map_enter_rect',true);
  await expect.poll(async()=>(await snapshot(page)).map_open).toBe(false);
  expect((await snapshot(page)).completed).toBe(false);expect(errors).toEqual([]);
  await context.close();
});

test('E06: mapa inicial, caminhos bloqueados e entrada por teclado',async({page})=>{
  const errors=errorsFor(page);await page.goto('./?test=1');await startGame(page,false);
  const s=await snapshot(page);expect(s.map_open).toBe(true);expect(s.map_world).toBe(0);
  expect(s.map_states).toEqual({'0':'CURRENT','1':'LOCKED','2':'LOCKED','3':'LOCKED'});
  await page.screenshot({path:'builds/web/e06-mapa-inicial.png'});
  await clickMapRect(page,s.map_nodes['1']);expect((await snapshot(page)).map_selected).toBe(0);
  await page.keyboard.press('Escape');await page.keyboard.down('ArrowRight');await page.waitForTimeout(250);await page.keyboard.up('ArrowRight');
  expect((await snapshot(page)).x).toBe(s.x);expect((await snapshot(page)).map_open).toBe(true);
  for(const world of [1,2,3]){
    await mapWorld(page,world);
    expect((await snapshot(page)).map_tico_visible).toBe(false);
    await page.screenshot({path:`builds/web/e06-mapa-arte-${world}.png`});
  }
  expect(Object.values((await snapshot(page)).map_states)).toEqual(['LOCKED','LOCKED','LOCKED','LOCKED']);
  await clickRect(page,'map_enter_rect');expect((await snapshot(page)).campaign_stage).toBe(0);
  await mapWorld(page,0);await clickMapRect(page,(await snapshot(page)).map_nodes['0']);await page.keyboard.press('Enter');
  await expect.poll(async()=>(await snapshot(page)).map_open).toBe(false);
  await walk(page,270);expect((await snapshot(page)).pipo_unlocked).toBe(false);expect(errors).toEqual([]);
});

test('E06: mapa por toque, revisita com Pipo e reabertura offline',async({browser})=>{
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true,baseURL:'http://127.0.0.1:8080/tico/'});
  const page=await context.newPage();await seed(page,fixture(4));const errors=errorsFor(page);
  await page.goto('./?test=1');await startGame(page,false);
  await expect.poll(async()=>(await snapshot(page)).map_world).toBe(1);
  await page.screenshot({path:'builds/web/e06-mapa-rio-touch.png'});
  await page.setViewportSize({width:390,height:844});await expect(page.locator('#rotate')).toBeVisible();
  await expect.poll(async()=>{const s=await snapshot(page);return s.height>s.width;}).toBe(true);
  await page.keyboard.press('Enter');await page.waitForTimeout(200);expect((await snapshot(page)).map_open).toBe(true);
  await page.setViewportSize({width:844,height:390});await expect(page.locator('#rotate')).toBeHidden();
  await expect.poll(async()=>{const s=await snapshot(page);return s.width>s.height;}).toBe(true);
  await mapWorld(page,0,true);
  await expect.poll(async()=>(await snapshot(page)).map_world).toBe(0);
  expect((await snapshot(page)).map_states['0']).toBe('COMPLETED');
  await clickMapRect(page,(await snapshot(page)).map_nodes['0'],true);await clickRect(page,'map_enter_rect',true);
  await expect.poll(async()=>(await snapshot(page)).campaign_stage).toBe(0);await ground(page);
  await clickRect(page,'switch_rect',true);await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
  await page.keyboard.press('Escape');await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);await clickRect(page,'map_menu_rect',true);
  await expect.poll(async()=>(await snapshot(page)).map_open).toBe(true);
  await page.screenshot({path:'builds/web/e06-mapa-revisita-touch.png'});
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await startGame(page,false);
  expect((await snapshot(page)).map_world).toBe(0);expect((await snapshot(page)).pipo_unlocked).toBe(true);
  const saved=await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')));
  expect(saved.unlocked).toBe(4);expect(saved.levels['0'].completed).toBe(true);
  await clickRect(page,'map_enter_rect',true);await expect.poll(async()=>(await snapshot(page)).map_open).toBe(false);
  expect((await snapshot(page)).character).toBe('Pipo');expect(errors).toEqual([]);await context.close();
});

test('E05: migra V1, coleta e recupera após fechar a página offline',async({page,context})=>{
  await seed(page,fixture(0));const errors=errorsFor(page);await boot(page);
  await expect.poll(()=>page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')).save_version)).toBe(2);
  await walk(page,270);
  await expect.poll(()=>page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')).levels['0'].items.length)).toBeGreaterThan(0);
  const saved=await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')));
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await page.close();await context.setOffline(true);
  const reopened=await context.newPage();const reopenedErrors=errorsFor(reopened);await boot(reopened);
  const restored=await reopened.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')));
  expect(restored.levels['0'].items).toEqual(saved.levels['0'].items);
  expect(restored.tutorials).toEqual(saved.tutorials);
  expect(restored.settings).toEqual(saved.settings);
  expect((await snapshot(reopened)).nuts).toBeGreaterThan(0);
  expect(errors.concat(reopenedErrors)).toEqual([]);
});

test('E05: V2 preserva conquistas, narrativa, vilarejo e Pipo offline',async({page,context})=>{
  const data=fixture(9);data.save_version=2;
  Object.assign(data.levels['9'],{character:'Pipo',checkpoint:true,secret:true,items:['1580:718'],mechanisms:{Rocha:true}});
  data.survival={lives:7,pending_return:false,return_stage:4,replay:false,pipo_unlocked:true,claimed:[0,4]};
  data.tutorials={tutorial_glide_seen:true};data.context_hints_seen=['walk'];
  data.collectibles={golden_nuts:{'9':['caverna_01']}};
  data.story={events:['mentor_clue_01'],village:{bridge_repaired:true}};
  await seed(page,data);const errors=errorsFor(page);await boot(page);
  expect((await snapshot(page)).character).toBe('Pipo');expect((await snapshot(page)).lives).toBe(7);
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await startGame(page);
  await expect.poll(async()=>(await snapshot(page))?.checkpoint,{timeout:45000}).toBe(true);
  const restored=await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')));
  expect(restored.collectibles).toEqual(data.collectibles);
  expect(restored.story.events).toContain('mentor_clue_01');expect(restored.story.events).toContain('pipo_rescued');
  expect(restored.story.village).toEqual(data.story.village);
  expect(restored.levels['9'].items).toContain('1580:718');expect(restored.survival.lives).toBe(7);
  expect(errors).toEqual([]);
});

test('E05: falha de armazenamento mantém save anterior e permite tentar novamente',async({page})=>{
  await page.addInitScript(data=>{
    localStorage.setItem('tico.campaign.v1',JSON.stringify(data));
    const original=Storage.prototype.setItem;
    Storage.prototype.setItem=function(key,value){if(key==='tico.campaign.v1')throw new DOMException('Quota','QuotaExceededError');return original.call(this,key,value);};
    window.restoreStorage=()=>{Storage.prototype.setItem=original;};
  },fixture(0));
  await boot(page);expect((await snapshot(page)).save_state).toBe('unavailable');
  expect(await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')).save_version)).toBe(1);
  await page.evaluate(()=>window.restoreStorage());await walk(page,270);
  await expect.poll(async()=>(await snapshot(page)).save_state).toBe('saved');
  expect(await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')).save_version)).toBe(2);
});

test('E05: leitura indisponível não sobrescreve campanha',async({page})=>{
  const data=fixture(4);
  await page.addInitScript(data=>{
    localStorage.setItem('tico.campaign.v1',JSON.stringify(data));
    const original=Storage.prototype.getItem;
    window.readOriginalCampaign=()=>original.call(localStorage,'tico.campaign.v1');
    Storage.prototype.getItem=function(key){if(key==='tico.campaign.v1')throw new DOMException('Blocked','SecurityError');return original.call(this,key);};
  },data);
  await boot(page);await walk(page,270);
  expect((await snapshot(page)).save_state).toBe('unavailable');
  expect(await page.evaluate(()=>JSON.parse(window.readOriginalCampaign()))).toEqual(data);
});

test('E04: dica contextual, HUD compacto e tutorial persistente offline',async({page,context})=>{
  await seed(page,fixture(0));const errors=errorsFor(page);await boot(page);
  await walk(page,270);
  await expect.poll(async()=>(await snapshot(page)).hint_id).toBe('tutorial_life_seen');
  expect((await snapshot(page)).compact_hud_height).toBeLessThan(120);
  expect((await snapshot(page)).hint_size[1]).toBeLessThanOrEqual(92);
  expect((await snapshot(page)).hud_controls_clear).toBe(true);
  expect((await snapshot(page)).paused).toBe(false);
  await page.screenshot({path:'builds/web/e04-hud-desktop.png'});
  await expect.poll(()=>page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')).tutorials.tutorial_life_seen)).toBe(true);
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await startGame(page);
  await expect.poll(async()=>(await snapshot(page))?.tutorials?.tutorial_life_seen,{timeout:45000}).toBe(true);
  await walk(page,270);expect((await snapshot(page)).hint_id).not.toBe('tutorial_life_seen');
  expect(errors).toEqual([]);
});

test('E04: dica do ninho mantém painel compacto',async({page})=>{
  const data=fixture(10);data.context_hints_seen=['walk'];
  await seed(page,data);const errors=errorsFor(page);await boot(page);
  await expect.poll(async()=>(await snapshot(page)).hint_text).toContain('Suba até o ninho');
  expect((await snapshot(page)).hint_size[1]).toBeLessThanOrEqual(92);
  await page.screenshot({path:'builds/web/e04-ninho-corrigido.png'});
  expect(errors).toEqual([]);
});

test('E04: interface e dicas por toque sem bloquear os controles',async({browser})=>{
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true,baseURL:'http://127.0.0.1:8080/tico/'});
  const page=await context.newPage();await seed(page,fixture(0));const errors=errorsFor(page);await boot(page);
  await expect.poll(async()=>(await snapshot(page)).hint_text).toContain('PULO');
  const cdp=await context.newCDPSession(page);const s=await snapshot(page);
  await cdp.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:[{id:1,x:(s.buttons.Right[0]+64)*844/s.width,y:(s.buttons.Right[1]+64)*390/s.height}]});
  await expect.poll(async()=>(await snapshot(page)).x).toBeGreaterThan(260);
  await cdp.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
  await expect.poll(async()=>(await snapshot(page)).tutorials.tutorial_life_seen).toBe(true);
  expect((await snapshot(page)).compact_hud_height).toBeLessThan(120);
  await page.screenshot({path:'builds/web/e04-hud-touch.png'});
  expect((await snapshot(page)).hud_controls_clear).toBe(true);
  await page.keyboard.press('Escape');await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await expect.poll(async()=>(await snapshot(page)).hint_visible).toBe(false);
  await page.screenshot({path:'builds/web/e04-pausa-touch.png'});
  expect(errors).toEqual([]);await context.close();
});

test('E03: derrota retorna à bandeira com Pipo e persiste offline',async({page,context})=>{
  const data=fixture(4);data.levels['4'].checkpoint=true;data.levels['4'].character='Pipo';
  await seed(page,data);const errors=errorsFor(page);await boot(page);
  expect((await snapshot(page)).checkpoint).toBe(true);
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).respawning,{timeout:30000}).toBe(true);
  await page.keyboard.up('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).respawning).toBe(false);
  const returned=await snapshot(page);
  expect(returned.lives).toBe(2);expect(returned.health).toBe(3);expect(returned.character).toBe('Pipo');
  expect(Math.abs(returned.x-returned.return_position[0])).toBeLessThan(10);
  await page.screenshot({path:'builds/web/e03-checkpoint.png'});
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await startGame(page);
  await expect.poll(async()=>(await snapshot(page))?.character,{timeout:45000}).toBe('Pipo');
  const reopened=await snapshot(page);
  expect(reopened.checkpoint).toBe(true);expect(reopened.lives).toBe(2);expect(reopened.health).toBe(3);
  expect(Math.abs(reopened.x-reopened.return_position[0])).toBeLessThan(10);
  expect(errors).toEqual([]);
});

test('E03: reiniciar fase por toque, cancelar e preservar comporta e save',async({browser})=>{
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true,baseURL:'http://127.0.0.1:8080/tico/'});
  const page=await context.newPage();const data=fixture(13);
  Object.assign(data.levels['13'],{checkpoint:true,character:'Pipo',mechanisms:{Comporta:true}});
  await seed(page,data);const errors=errorsFor(page);await boot(page);
  await page.keyboard.press('Escape');await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await page.screenshot({path:'builds/web/e03-pausa-touch.png'});
  await clickRect(page,'phase_restart_rect',true);
  await expect.poll(async()=>(await snapshot(page)).phase_restart_confirmation).toBe(true);
  await page.screenshot({path:'builds/web/e03-confirmacao-touch.png'});
  await clickRect(page,'phase_cancel_rect',true);
  await expect.poll(async()=>(await snapshot(page)).phase_restart_confirmation).toBe(false);
  expect((await snapshot(page)).checkpoint).toBe(true);expect((await snapshot(page)).paused).toBe(true);
  await clickRect(page,'phase_restart_rect',true);
  await expect.poll(async()=>(await snapshot(page)).phase_restart_confirmation).toBe(true);
  await clickRect(page,'phase_confirm_rect',true);
  await expect.poll(async()=>(await snapshot(page)).checkpoint).toBe(false);
  const restarted=await snapshot(page);
  expect(restarted.x).toBeLessThan(200);expect(restarted.health).toBe(3);expect(restarted.lives).toBe(3);
  expect(restarted.character).toBe('Pipo');expect(restarted.mechanisms.Comporta).toBe(true);
  await expect.poll(()=>page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')).levels['13'].checkpoint)).toBe(false);
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await startGame(page);
  await expect.poll(async()=>(await snapshot(page))?.campaign_stage,{timeout:45000}).toBe(13);
  expect((await snapshot(page)).checkpoint).toBe(false);expect((await snapshot(page)).mechanisms.Comporta).toBe(true);
  expect(errors).toEqual([]);await context.close();
});

test('E02: derrota real, Game Over, retorno offline e Pipo preservado',async({page,context})=>{
  const data=fixture(4);
  data.survival={lives:1,pending_return:false,return_stage:0,replay:false,pipo_unlocked:true,claimed:[]};
  await seed(page,data);const errors=errorsFor(page);await boot(page);
  await page.keyboard.down('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).game_over,{timeout:30000}).toBe(true);
  await page.keyboard.up('ArrowRight');
  await expect.poll(async()=>(await snapshot(page)).return_rect).toBeTruthy();
  expect((await snapshot(page)).return_stage).toBe(0);
  expect((await snapshot(page)).lives).toBe(3);
  await page.screenshot({path:'builds/web/e02-game-over.png'});
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await startGame(page);
  await expect.poll(async()=>(await snapshot(page))?.return_rect,{timeout:45000}).toBeTruthy();
  await clickRect(page,'return_rect');
  await expect.poll(async()=>(await snapshot(page)).campaign_stage).toBe(0);
  await ground(page);
  await page.keyboard.press('q');await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
  const saved=await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')));
  expect(saved.unlocked).toBe(4);expect(saved.levels['0'].completed).toBe(true);
  expect(saved.survival.pending_return).toBe(false);
  await page.screenshot({path:'builds/web/e02-retorno.png'});
  expect(errors).toEqual([]);
});

test('E02: retorno por toque mantém mundos posteriores acessíveis',async({browser})=>{
  const context=await browser.newContext({viewport:{width:844,height:390},hasTouch:true,isMobile:true,baseURL:'http://127.0.0.1:8080/tico/'});
  const page=await context.newPage();const data=fixture(12);
  data.survival={lives:3,pending_return:true,return_stage:8,replay:false,pipo_unlocked:true,claimed:[0,4]};
  await seed(page,data);const errors=errorsFor(page);await boot(page);
  await expect.poll(async()=>(await snapshot(page)).return_rect).toBeTruthy();
  await page.screenshot({path:'builds/web/e02-retorno-touch.png'});
  await clickRect(page,'return_rect',true);
  await expect.poll(async()=>(await snapshot(page)).campaign_stage).toBe(8);
  const saved=await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.campaign.v1')));
  expect(saved.unlocked).toBe(12);expect(saved.survival.claimed).toEqual([0,4]);
  expect(errors).toEqual([]);await context.close();
});

test('Corrida: Tico e Pipo alternam quatro passadas e param ao soltar',async({page})=>{
  await seed(page,fixture(7));const errors=errorsFor(page);await boot(page);await ground(page);
  for(const name of ['Tico','Pipo']) {
    if(name==='Pipo'){await page.keyboard.press('q');await expect.poll(async()=>(await snapshot(page)).character).toBe(name);}
    const seen=new Set();await page.keyboard.down('ArrowRight');
    const deadline=Date.now()+4000;
    while(seen.size<4&&Date.now()<deadline){
      const s=await snapshot(page);
      if(s.pose==='run'&&!seen.has(s.run_frame)){
        seen.add(s.run_frame);
      }
      await page.waitForTimeout(25);
    }
    await page.screenshot({path:`builds/web/corrida-${name}.png`});
    await page.keyboard.up('ArrowRight');expect(seen.size).toBe(4);
    await expect.poll(async()=>(await snapshot(page)).pose).toBe('idle');
    expect((await snapshot(page)).run_frame).toBe(0);
  }
  expect(errors).toEqual([]);
});

test('Bosque migra para Rio; percurso, checkpoint e reabertura offline',async({page,context})=>{
  test.setTimeout(150000);
  const old=fixture(3);old.levels['3'].completed=true;old.levels['3'].boss_done=true;old.finished=true;
  await seed(page,old,'tico.world1.v1');const errors=errorsFor(page);await boot(page);
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);await clickRect(page,'next_rect');
  await expect.poll(async()=>(await snapshot(page)).map_open).toBe(true);
  expect((await snapshot(page)).map_selected).toBe(4);
  await clickRect(page,'map_enter_rect');
  await expect.poll(async()=>(await snapshot(page)).campaign_stage).toBe(4);
  await walk(page,565);await glide(page,1230);await walk(page,1510);await glide(page,2180);
  expect((await snapshot(page)).checkpoint).toBe(true);
  await page.screenshot({path:'builds/web/etapa9-rio.png'});
  await walk(page,2460);await glide(page,2940);await glide(page,3350);await walk(page,3590);
  await expect.poll(async()=>(await snapshot(page)).result).toBe(true);
  await page.screenshot({path:'builds/web/e07-resultado-rio.png'});
  await clickRect(page,'next_rect');
  await expect.poll(async()=>(await snapshot(page)).map_open).toBe(true);
  expect((await snapshot(page)).map_selected).toBe(5);
  expect((await snapshot(page)).map_states['5']).toBe('AVAILABLE');
  await page.screenshot({path:'builds/web/e07-desbloqueio.png'});
  expect(await page.evaluate(()=>JSON.parse(localStorage.getItem('tico.world1.v1')))).toEqual(old);
  await expect.poll(()=>page.evaluate(()=>!!navigator.serviceWorker.controller),{timeout:45000}).toBe(true);
  await context.setOffline(true);await page.reload();await startGame(page);
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
  await page.keyboard.press('Escape');await page.waitForTimeout(200);
  expect((await snapshot(page)).paused).toBe(true);
  await page.setViewportSize({width:844,height:390});await page.reload();await startGame(page);
  await expect.poll(async()=>(await snapshot(page))?.mechanisms?.Peso,{timeout:45000}).toBe(true);
  expect((await snapshot(page)).music_enabled).toBe(true);expect(errors).toEqual([]);await context.close();
});

test('Comporta: investida, drenagem e save',async({page})=>{
  await seed(page,fixture(13));const errors=errorsFor(page);await boot(page);await walk(page,650);await ground(page);await page.keyboard.press('q');
  await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');await page.keyboard.press('e');
  await expect.poll(async()=>(await snapshot(page)).mechanisms.Comporta).toBe(true);
  await page.reload();await startGame(page);await expect.poll(async()=>(await snapshot(page))?.mechanisms?.Comporta,{timeout:45000}).toBe(true);expect(errors).toEqual([]);
});

test('Save futuro fica intacto até confirmar nova aventura',async({page})=>{
  await seed(page,{save_version:999});await boot(page);expect((await snapshot(page)).save_state).toBe('incompatible');
  await page.keyboard.press('Escape');await expect.poll(async()=>(await snapshot(page)).paused).toBe(true);
  await clickRect(page,'restart_rect');await expect.poll(async()=>(await snapshot(page)).restart_confirmation).toBe(true);
  await clickRect(page,'cancel_rect');
  await expect.poll(async()=>(await snapshot(page)).restart_confirmation).toBe(false);
  expect(await page.evaluate(()=>localStorage.getItem('tico.campaign.v1'))).toBe('{"save_version":999}');
  await clickRect(page,'restart_rect');
  await expect.poll(async()=>(await snapshot(page)).restart_confirmation).toBe(true);
  await clickRect(page,'confirm_rect');await expect.poll(async()=>(await snapshot(page)).save_state).toBe('saved');expect((await snapshot(page)).campaign_stage).toBe(0);
});
