# create-aiolosjs

通过命令创建应用/模板

## Usage

```bash
$ yarn create aiolosjs [appName]
```

## Boilerplates

- `aiolosjs-pro` - 创建一个 aiolosjs pro 模板, 基于 antd pro.
- `standardtable` - 创建一个标准 table.

## Usage Example

```bash
$ yarn create aiolosjs

? 请选择模板类型  (使用上下按键)
  aiolosjs-pro    - 创建一个aiolosjs pro 模板, 基于antd pro.
❯ standardtable   - 创建一个标准table.

? 请选择模板类型 standardtable
? 请输入菜单名称-中文 testTable
? 请输入菜单名称-英文 测试
   create 测试/Detail.tsx
   create 测试/index.tsx
   create 测试/interface.ts
   create 测试/ModalDetailForm.tsx
   create 测试/model.ts
   create 测试/pageConfig.tsx
✨ 文件创建成功

```

## FAQ

### `yarn create umi` command failed

这个问题基本上都是因为没有添加 yarn global module 的路径到 PATH 环境变量引起的。

先执行 `yarn global bin` 拿到路径，然后添加到 PATH 环境变量里。

```bash
$ yarn global bin
/usr/local/bin
```

你也可以尝试用 npm，

```bash
$ npm create aiolosjs
```

或者手动安装 create-aiolosjs，并执行他，

```bash
$ npm install create-aiolosjs -g
$ create-aiolosjs
```
