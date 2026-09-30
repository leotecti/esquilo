import {test,expect} from '@playwright/test';
const snapshot=page=>page.evaluate(()=>window.__ticoTest);

for (const mobile of [false,true]) {
  test(`esforço de Tico e passadas de Pipo: ${mobile?'touch':'teclado'}`,async({browser})=>{
    const viewport=mobile?{width:844,height:390}:{width:1280,height:720};
    const context=await browser.newContext({viewport,hasTouch:mobile,isMobile:mobile});
    const page=await context.newPage();
    const errors=[];page.on('console',m=>{if(m.type()==='error')errors.push(m.text());});
    try {
      await page.goto('http://127.0.0.1:8080/tico/?test=1');
      await page.locator('#play').click();
      await expect.poll(async()=>(await snapshot(page))?.grounded,{timeout:45000}).toBe(true);
      const s=await snapshot(page),cdp=await context.newCDPSession(page);
      const keys={Right:'ArrowRight',Jump:'Space'};
      let held=[];
      async function hold(names) {
        if(mobile) {
          const points=names.map(name=>({id:name==='Right'?1:2,x:(s.buttons[name][0]+64)*viewport.width/s.width,y:(s.buttons[name][1]+64)*viewport.height/s.height}));
          await cdp.send('Input.dispatchTouchEvent',{type:names.length?'touchStart':'touchEnd',touchPoints:points});
        } else {
          for(const name of held.filter(n=>!names.includes(n)))await page.keyboard.up(keys[name]);
          for(const name of names.filter(n=>!held.includes(n)))await page.keyboard.down(keys[name]);
        }
        held=names;
      }
      await hold(['Right']);
      await expect.poll(async()=>(await snapshot(page)).x,{intervals:[50]}).toBeGreaterThan(320);
      await hold(['Right','Jump']);
      await expect.poll(async()=>(await snapshot(page)).x,{intervals:[50]}).toBeGreaterThan(740);
      await hold([]);
      await expect.poll(async()=>(await snapshot(page)).grounded).toBe(true);
      await hold(['Right']);
      await expect.poll(async()=>(await snapshot(page)).pose).toBe('push_attempt');
      const stone=(await snapshot(page)).stone_x,frames=new Set();
      for(let i=0;i<12;i++){frames.add((await snapshot(page)).push_frame);await page.waitForTimeout(100);}
      expect(frames.size).toBeGreaterThan(1);
      expect((await snapshot(page)).stone_x).toBeCloseTo(stone,0);
      await page.screenshot({path:`builds/web/preview-tico-esforco-${mobile?'touch':'desktop'}.png`});
      await hold([]);
      await expect.poll(async()=>(await snapshot(page)).pose).not.toBe('push_attempt');
      if(mobile) {
        const r=(await snapshot(page)).switch_rect;
        await page.touchscreen.tap((r[0]+r[2]/2)*viewport.width/s.width,(r[1]+r[3]/2)*viewport.height/s.height);
      } else await page.keyboard.press('q');
      await expect.poll(async()=>(await snapshot(page)).character).toBe('Pipo');
      await hold(['Right']);
      await expect.poll(async()=>(await snapshot(page)).pose).toBe('push');
      frames.clear();
      for(let i=0;i<10;i++) {
        frames.add((await snapshot(page)).push_frame);
        if(i===2 || i===5)await page.screenshot({path:`builds/web/preview-pipo-passada-${mobile?'touch':'desktop'}-${i}.png`});
        await page.waitForTimeout(85);
      }
      expect(frames.size).toBeGreaterThan(1);
      expect((await snapshot(page)).stone_x).toBeGreaterThan(stone+50);
      await hold([]);
      await expect.poll(async()=>(await snapshot(page)).pose).not.toBe('push');
      expect(errors).toEqual([]);
    } finally {await context.close();}
  });
}
