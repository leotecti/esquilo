import http from 'node:http';
import {createReadStream} from 'node:fs';
import {stat} from 'node:fs/promises';
import {resolve, extname, sep} from 'node:path';
import {fileURLToPath} from 'node:url';

const folder = ['7','8','9'].includes(process.env.TICO_WEB_STAGE) ? `etapa_${process.env.TICO_WEB_STAGE}` : 'validacao_intermediaria_2';
const root = resolve(fileURLToPath(new URL(`../builds/web/${folder}/`, import.meta.url)));
const port = Number(process.env.PORT || 8080);
const host = process.env.HOST || '127.0.0.1';
const types = {'.html':'text/html; charset=utf-8','.js':'text/javascript; charset=utf-8','.json':'application/json','.webmanifest':'application/manifest+json','.wasm':'application/wasm','.pck':'application/octet-stream','.png':'image/png','.svg':'image/svg+xml'};
const server = http.createServer(async (req,res) => {
  try {
    const url = new URL(req.url, 'http://localhost');
    if (url.pathname === '/' || url.pathname === '/tico') { res.writeHead(302,{Location:'/tico/'}).end(); return; }
    if (!url.pathname.startsWith('/tico/')) { res.writeHead(404).end(); return; }
    const path = resolve(root, decodeURIComponent(url.pathname.slice(6)) || 'index.html');
    if (!path.startsWith(root + sep) || !['GET','HEAD'].includes(req.method)) { res.writeHead(403).end(); return; }
    const info = await stat(path);
    if (!info.isFile()) { res.writeHead(404).end(); return; }
    res.writeHead(200,{'Content-Type':types[extname(path)] || 'application/octet-stream','Content-Length':info.size,'Cache-Control':'no-cache','X-Content-Type-Options':'nosniff'});
    if (req.method === 'HEAD') res.end(); else createReadStream(path).pipe(res);
  } catch { res.writeHead(404).end('Arquivo não encontrado'); }
});
server.listen(port,host,() => console.log(`Tico: http://${host}:${port}/tico/`));
