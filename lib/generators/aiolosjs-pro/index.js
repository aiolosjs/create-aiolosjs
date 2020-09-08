const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');
const glob = require('glob');
const exec = require('execa');
const rimraf = require('rimraf');
const BasicGenerator = require('../../BasicGenerator');
const filterPkg = require('./filterPkg');
const prettier = require('prettier');
const sylvanas = require('sylvanas');
const sortPackage = require('sort-package-json');

function log(...args) {
  console.log(`${chalk.gray('>')}`, ...args);
}

function globList(patternList, options) {
  let fileList = [];
  patternList.forEach(pattern => {
    fileList = [...fileList, ...glob.sync(pattern, options)];
  });

  return fileList;
}

const getGithubUrl = () => {
  return 'https://github.com/aiolosjs/aiolojs-pro';
};

class AiolosJsProGenerator extends BasicGenerator {
  prompting() {
    if (this.opts.args.language) {
      this.prompts = {
        language: this.opts.args.language,
      };
    } else {
      const prompts = [
        {
          name: 'proVersion',
          type: 'list',
          choices: ['Pro V1'],
          message: '🧙 AiolisJs Pro',
          default: 'Pro V1',
          when: () => {
            // 为了测试，没有任何用处
            process.send && process.send({ type: 'prompt' });
            process.emit('message', { type: 'prompt' });
            return true;
          },
        },
        {
          name: 'language',
          type: 'list',
          message: '🤓 您想使用哪种语言?',
          choices: ['TypeScript', 'JavaScript'],
          default: 'TypeScript',
          when: ({ proVersion }) => {
            process.send && process.send({ type: 'prompt' });
            process.emit('message', { type: 'prompt' });
            return proVersion === 'Pro V1';
          },
        },
      ];
      return this.prompt(prompts).then(props => {
        this.prompts = props;
      });
    }
  }

  async writing() {
    const { language = 'TypeScript', proVersion } = this.prompts;

    const isTypeScript = language === 'TypeScript';
    const projectName = this.opts.name || this.opts.env.cwd;
    const projectPath = path.resolve(projectName);

    const envOptions = {
      cwd: projectPath,
    };

    const githubUrl = getGithubUrl();
    const gitArgs = [`clone`, githubUrl, `--depth=1`];

    if (proVersion === 'Pro V1') {
      gitArgs.push('--branch', 'master');
    }

    gitArgs.push(projectName);

    // // 没有提供关闭的配置
    // // https://github.com/yeoman/environment/blob/9880bc7d5b26beff9f0b4d5048c672a85ce4bcaa/lib/util/repository.js#L50
    const yoConfigPth = path.join(projectPath, '.yo-repository');
    if (fs.existsSync(yoConfigPth)) {
      // 删除 .yo-repository
      rimraf.sync(yoConfigPth);
    }

    if (
      fs.existsSync(projectPath) &&
      fs.statSync(projectPath).isDirectory() &&
      fs.readdirSync(projectPath).length > 0
    ) {
      console.log('\n');
      console.log('\n');
      console.log(`🙈 请在空文件夹中使用，或者使用 ${chalk.red('yarn create aiolosjs myapp')}`);
      process.exit(1);
    }

    // Clone remote branch
    // log(`git ${[`clone`, githubUrl].join(' ')}`);
    await exec(
      `git`,
      gitArgs,
      process.env.TEST
        ? {}
        : {
            stdout: process.stdout,
            stderr: process.stderr,
            stdin: process.stdin,
          },
    );

    log(`🚚 clone success`);

    const packageJsonPath = path.resolve(projectPath, 'package.json');
    const pkg = require(packageJsonPath);
    // Handle js version
    if (!isTypeScript) {
      log('[Sylvanas] Prepare js environment...');
      const tsFiles = globList(['**/*.tsx', '**/*.ts'], {
        ...envOptions,
        ignore: ['**/*.d.ts'],
      });

      sylvanas(tsFiles, {
        ...envOptions,
        action: 'overwrite',
      });

      log('[JS] Clean up...');
      const removeTsFiles = globList(['tsconfig.json', '**/*.d.ts'], envOptions);
      removeTsFiles.forEach(filePath => {
        const targetPath = path.resolve(projectPath, filePath);
        fs.removeSync(targetPath);
      });
    }
  }
}

module.exports = AiolosJsProGenerator;
