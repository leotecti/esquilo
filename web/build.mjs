import {spawnSync} from 'node:child_process';
import {createHash} from 'node:crypto';
import {mkdir, readFile, writeFile, readdir, copyFile} from 'node:fs/promises';
import {resolve} from 'node:path';
import {fileURLToPath} from 'node:url';

const root = fileURLToPath(new URL('../', import.meta.url));
const out = resolve(root, 'builds/web/validacao_intermediaria_2');
const godot = process.env.GODOT_BIN || 'D:\\Godot\\Godot_v4.7.2-stable\\Godot_v4.7.2-stable_win64_console.exe';
await mkdir(out,{recursive:true});
await mkdir(resolve(root,'node_modules'),{recursive:true});
await writeFile(resolve(root,'node_modules/.gdignore'),'');
function run(...args) {
  const result = spawnSync(godot, ['--headless','--path',root,...args], {stdio:'inherit'});
  if (result.error) throw result.error;
  if (result.status !== 0) throw new Error(`Godot terminou com código ${result.status}`);
}
run('--script','web/render_icons.gd');
run('--editor','--import','--quit');
run('--export-release','Web',resolve(out,'index.html'));
for (const size of [192,512]) await copyFile(resolve(root,`web/icons/icon-${size}.png`),resolve(out,`icon-${size}.png`));
await copyFile(resolve(root,'assets/slice/forest.png'),resolve(out,'forest-cover.png'));
const manifestPath = resolve(out,'index.manifest.json');
const manifest = JSON.parse(await readFile(manifestPath,'utf8'));
Object.assign(manifest, {
  id:'./', start_url:'./', scope:'./', lang:'pt-BR',
  name:'Tico e a Floresta das Nozes', short_name:'Tico',
  description:'Explore o bosque, o rio, a montanha e a vila com Tico e Pipo. Uma aventura entre amigos.',
  display:'fullscreen', orientation:'landscape', background_color:'#c4e0d9',theme_color:'#244b37',
  icons:[{src:'icon-192.png',sizes:'192x192',type:'image/png',purpose:'any'},
    {src:'icon-512.png',sizes:'512x512',type:'image/png',purpose:'any maskable'}]
});
await writeFile(manifestPath,JSON.stringify(manifest,null,2)+'\n');
const files = (await readdir(out)).filter(name => /\.(html|js|wasm|pck|png|json)$/.test(name) && name !== 'index.service.worker.js').sort();
const hash = createHash('sha256');
const assets = [];
for (const name of files) {
  const content = await readFile(resolve(out,name));
  const fileHash = createHash('sha256').update(content).digest('hex').slice(0,16);
  assets.push({name,size:content.byteLength,hash:fileHash});
  hash.update(name); hash.update(content);
}
const version = hash.digest('hex').slice(0,16);
const worker = (await readFile(resolve(root,'web/custom/service-worker.js'),'utf8'))
  .replace('__BUILD_VERSION__',version).replace('__ASSET_MANIFEST__',JSON.stringify(assets));
await writeFile(resolve(out,'index.service.worker.js'),worker);
await copyFile(resolve(root,'web/deploy.htaccess'),resolve(out,'.htaccess'));
console.log(`Web/PWA pronta: ${out}\nCache: ${version}\nDestino: https://projetosdoleo.com/tico/`);
