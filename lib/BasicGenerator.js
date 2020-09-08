const Generator = require('yeoman-generator');
const glob = require('glob');
const { statSync } = require('fs');
const { basename } = require('path');
const debug = require('debug')('create-aiolosjs:BasicGenerator');

function noop() {
  return true;
}

class BasicGenerator extends Generator {
  constructor(opts) {
    super(opts);
    this.opts = opts;
    this.name = basename(opts.env.cwd);
  }

  isTsFile(f) {
    return f.endsWith('.ts') || f.endsWith('.tsx') || !!/(tsconfig\.json)/g.test(f);
  }

  writeFiles({ context, filterFiles = noop }) {
    const projectName = context.projectName;
    debug(`context: ${JSON.stringify(context)}`);
    glob
      .sync('**/*', {
        cwd: this.templatePath(),
        dot: true,
      })
      .filter(filterFiles)
      .forEach(file => {
        debug(`copy ${file}`);
        const filePath = this.templatePath(file);
        if (statSync(filePath).isFile()) {
          this.fs.copyTpl(
            this.templatePath(filePath),
            this.destinationPath(projectName, file.replace(/\.tpl$/, '')),
            context,
          );
        }
      });
  }

  prompt(questions) {
    process.send && process.send({ type: 'prompt' });
    process.emit('message', { type: 'prompt' });
    return super.prompt(questions);
  }
}

module.exports = BasicGenerator;
