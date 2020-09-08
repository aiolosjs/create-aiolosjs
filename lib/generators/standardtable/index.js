const BasicGenerator = require('../../BasicGenerator');

const { firstUpperCase } = require('../../utils');

class Generator extends BasicGenerator {
  prompting() {
    const prompts = [
      {
        name: 'name',
        message: `请输入菜单名称-中文`,
        default: this.name,
      },
      {
        name: 'projectName',
        message: `请输入菜单名称-英文`,
      },
    ];
    return this.prompt(prompts).then(props => {
      const { projectName } = props;
      Object.assign(props, {
        firstUpperCaseProjectName: firstUpperCase(projectName),
        lowerCaseProjectName: projectName.toLowerCase(),
      });
      this.prompts = props;
    });
  }

  writing() {
    this.writeFiles({
      context: this.prompts,
      filterFiles: f => {
        return true;
      },
    });
  }
}

module.exports = Generator;
