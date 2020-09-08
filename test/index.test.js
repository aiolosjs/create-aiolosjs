const coffee = require('coffee');
const path = require('path');
const os = require('os');
const fs = require('fs');
const { winEOL } = require('umi-utils');

describe('test aiolosjs-create', () => {
  beforeAll(() => {
    process.env.TEST = 'test';
  });
  it('test generate aiolosjs pro project from github', async () => {
    let temp = fs.mkdtempSync(path.join(os.tmpdir(), `aiolosjs-create`));
    if (os.platform() === 'darwin') {
      temp = path.join('/private', temp);
    }
    const Coffee = coffee.Coffee;
    const fixtures = path.join(__dirname, 'fixtures');
    const response = await new Coffee({
      method: 'fork',
      cmd: path.join(__dirname, '../cli.js'),
      opt: { cwd: temp, stdout: process.stdout, stderr: process.stderr, stdin: process.stdin },
    })
      .beforeScript(path.join(fixtures, 'mock_github.js'))
      .waitForPrompt()
      .write('\n')
      .write('\n')
      .write('\n')
      .writeKey('DOWN', 'ENTER')
      .write('\n')
      .write('\n')
      .end();

    expect(winEOL(response.stdout).replace(/>/g, '❯')).toMatchSnapshot();
    expect(response.code).toBe(0);
    expect(fs.existsSync(path.join(temp, 'package.json'))).toBeTruthy();
  });
});

describe('typescript', () => {
  it('tsconfig.json should be removed if JavaScript is picked', async () => {
    let temp = fs.mkdtempSync(path.join(os.tmpdir(), `aiolosjs-create`));
    if (os.platform() === 'darwin') {
      temp = path.join('/private', temp);
    }
    const Coffee = coffee.Coffee;
    const fixtures = path.join(__dirname, 'fixtures');
    const response = await new Coffee({
      method: 'fork',
      cmd: path.join(__dirname, '../cli.js'),
      opt: { cwd: temp },
    })
      .beforeScript(path.join(fixtures, 'mock_github.js'))
      .waitForPrompt()
      .write('\n')
      .write('\n')
      .write('\n')
      .write('\n')
      .write('\n')
      .write('\n')
      .write('\n')
      .end();

    expect(response.code).toBe(0);
    expect(fs.existsSync(path.join(temp, 'jsconfig.json'))).toBeTruthy();
    expect(fs.existsSync(path.join(temp, 'tsconfig.json'))).toBeTruthy();
    expect(fs.existsSync(path.join(temp, 'package.json'))).toBeTruthy();
  });
});
