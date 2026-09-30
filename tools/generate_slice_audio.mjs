// Composição e síntese originais. node tools/generate_slice_audio.mjs
import {mkdir,writeFile} from 'node:fs/promises';
const dir=new URL('../assets/audio/slice/',import.meta.url);
await mkdir(dir,{recursive:true});
const rate=22050;
const hz=n=>440*2**((n-69)/12);
function tone(buffer,start,length,note,gain=.2,kind='bell') {
  const offset=Math.round(start*rate), count=Math.min(Math.round(length*rate),buffer.length-offset);
  const f=hz(note);
  for(let i=0;i<count;i++) {
    const t=i/rate,p=t/length;
    const env=Math.min(t/.015,1)*Math.sin(Math.PI*Math.min(p*1.05,1))**.55*Math.exp(-p*(kind==='bell'?3:1));
    const wave=Math.sin(2*Math.PI*f*t)+.25*Math.sin(2*Math.PI*f*2*t)+.08*Math.sin(2*Math.PI*f*3*t);
    buffer[offset+i]+=wave*env*gain;
  }
}
async function wav(name,data) {
  const bytes=Buffer.alloc(44+data.length*2);
  bytes.write('RIFF');bytes.writeUInt32LE(bytes.length-8,4);bytes.write('WAVEfmt ',8);
  bytes.writeUInt32LE(16,16);bytes.writeUInt16LE(1,20);bytes.writeUInt16LE(1,22);
  bytes.writeUInt32LE(rate,24);bytes.writeUInt32LE(rate*2,28);bytes.writeUInt16LE(2,32);bytes.writeUInt16LE(16,34);
  bytes.write('data',36);bytes.writeUInt32LE(data.length*2,40);
  for(let i=0;i<data.length;i++)bytes.writeInt16LE(Math.round(Math.max(-.96,Math.min(.96,data[i]))*32767),44+i*2);
  await writeFile(new URL(name+'.wav',dir),bytes);
}
// 16 compassos em Dó maior, 100 BPM. Frases curtas com espaço para os efeitos.
const beat=.6, music=new Float32Array(Math.round(16*4*beat*rate));
const chords=[[48,52,55],[53,57,60],[45,48,52],[55,59,62]];
const melody=[[72,76,79,76],[74,72,69,72],[76,79,81,79],[74,71,67,71],
 [72,76,79,84],[81,79,76,72],[76,74,72,69],[71,74,72,67]];
for(let bar=0;bar<16;bar++) {
  const chord=chords[bar%4];
  for(let i=0;i<8;i++)tone(music,(bar*4+i/2)*beat,.42,chord[i%3]+12,.055);
  tone(music,bar*4*beat,1.5,chord[0]-12,.13,'soft');
  for(let i=0;i<4;i++)tone(music,(bar*4+i)*beat,.47,melody[bar%8][i],.1,'soft');
}
await wav('bosque',music);
const effects={jump:[72,79],collect:[84,91],impact:[43,36],hurt:[67,60],checkpoint:[72,76,79,84],
 secret:[79,83,86,91],interface:[76,79],switch:[72,79,84],charge:[48,55,60],victory:[72,76,79,84,88],step:[43],land:[48,43]};
for(const [name,notes] of Object.entries(effects)) {
  const duration=name==='step'?.045:name==='victory'?.15:.075;
  const data=new Float32Array(Math.ceil((notes.length*duration+.08)*rate));
  notes.forEach((note,i)=>tone(data,i*duration,duration+.06,note,name==='step'?.09:.25));
  await wav(name,data);
}
console.log('13 faixas WAV originais geradas em assets/audio/slice.');
