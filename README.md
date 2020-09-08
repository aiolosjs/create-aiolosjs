# create-aiolosjs

通过命令创建应用/模板

## Usage

``` bash
$ yarn create aiolosjs [appName]
```

## Boilerplates

* `aiolosjs-pro` - 创建一个aiolosjs pro 模板, 基于antd pro.
* `standardtable ` - 创建一个标准table.

## Usage Example

``` bash
$ yarn create aiolosjs

? 请选择模板类型  (使用上下按键)
  aiolosjs-pro    - 创建一个aiolosjs pro 模板, 基于antd pro.
❯ standardtable   - 创建一个标准table.

? 是否使用typescript? (y/N)

```

## FAQ

### `yarn create umi` command failed

这个问题基本上都是因为没有添加 yarn global module 的路径到 PATH 环境变量引起的。

先执行 `yarn global bin` 拿到路径，然后添加到 PATH 环境变量里。

``` bash
$ yarn global bin
/usr/local/bin
```

你也可以尝试用 npm，

``` bash
$ npm create aiolosjs
```

或者手动安装 create-aiolosjs，并执行他，

``` bash
$ npm install create-aiolosjs -g
$ create-aiolosjs
```
