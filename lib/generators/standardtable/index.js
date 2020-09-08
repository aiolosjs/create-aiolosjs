const BasicGenerator = require('../../BasicGenerator');

const { firstUpperCase, firstLowerCase } = require('../../utils');

const hasFeature = (features = [], key = '') => {
  return features.findIndex(f => f === key) !== -1;
};

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
      {
        name: 'features',
        message: '需要开启哪些功能?',
        type: 'checkbox',
        choices: [
          { name: '新增', value: 'create' },
          { name: '编辑', value: 'update' },
          { name: '删除', value: 'delete' },
          { name: '查看详情', value: 'queryDetail' },
        ],
      },
    ];
    return this.prompt(prompts).then(props => {
      const { projectName, features } = props;
      console.log('props', props);

      Object.assign(props, {
        firstUpperCaseProjectName: firstUpperCase(projectName),
        firstLowerCaseProjectName: firstLowerCase(projectName),
        lowerCaseProjectName: projectName.toLowerCase(),
        fCreate: hasFeature(features, 'create'),
        fUpdate: hasFeature(features, 'update'),
        fDelete: hasFeature(features, 'delete'),
        fQueryDetail: hasFeature(features, 'queryDetail'),
      });
      // console.log('props', props);

      this.prompts = props;
    });
  }

  writing() {
    const { fCreate, fUpdate, fQueryDetail } = this.prompts;
    this.writeFiles({
      context: this.prompts,
      filterFiles: f => {
        if (f.startsWith('ModalDetailForm') && !fCreate && !fUpdate) return false;
        if (f.startsWith('Detail') && !fQueryDetail) return false;
        return true;
      },
    });
  }
}

module.exports = Generator;
