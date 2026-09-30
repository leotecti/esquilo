import {defineConfig} from '@playwright/test';
export default defineConfig({
  testDir:'./tests/browser', timeout:90000, workers:1,
  testMatch: process.env.TICO_WEB_STAGE === '7' ? ['tico.spec.js','save.spec.js','slice.spec.js','push.spec.js'] : 'world.spec.js',
  use:{baseURL:'http://127.0.0.1:8080/tico/', viewport:{width:1280,height:720},
    launchOptions:{channel:'chrome',args:['--enable-unsafe-swiftshader']},
    screenshot:'only-on-failure'},
  webServer:{command:'node web/serve.mjs',url:'http://127.0.0.1:8080/tico/',reuseExistingServer:true}
});
