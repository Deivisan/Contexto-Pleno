const size = 1_000_000;
const data = Array.from({ length: size }, (_, i) => ({ id: i, value: Math.random() }));

async function run() {
    console.time('JSON Stringify');
    const json = JSON.stringify(data);
    console.timeEnd('JSON Stringify');

    console.time('File Write');
    if (typeof Bun !== 'undefined') {
        await Bun.write('test_bench.json', json);
    } else {
        const fs = require('fs/promises');
        await fs.writeFile('test_bench.json', json);
    }
    console.timeEnd('File Write');

    console.time('File Read');
    if (typeof Bun !== 'undefined') {
        const file = Bun.file('test_bench.json');
        await file.text();
    } else {
        const fs = require('fs/promises');
        await fs.readFile('test_bench.json', 'utf8');
    }
    console.timeEnd('File Read');

    console.time('Computational Loop (Math)');
    let sum = 0;
    for (let i = 0; i < 10_000_000; i++) {
        sum += Math.sqrt(i) * Math.sin(i);
    }
    console.timeEnd('Computational Loop (Math)');
}

run();
