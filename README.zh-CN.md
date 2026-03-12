# OpenClaw Engram

`openclaw-engram` 是一个极简的 OpenClaw 插件，只提供固定的 slash commands，用来敦促 OpenClaw 更新记忆文件。

它不会分析对话，不会调用 LLM，也不会自己写入记忆文件。

当前提供 5 个命令：

- `/engram-user`
- `/engram-identity`
- `/engram-soul`
- `/engram-memory`
- `/engram-tools`

## 产品定位

这个项目不再是自动 reflection 机制，而是一个手动触发的 memory nudge 插件：

- 没有后台分析
- 没有自动写入
- 没有 write guardian
- 没有 consolidation
- 没有隐藏的判定链路

用户明确执行命令，OpenClaw 再决定是否更新目标文件。

## 安装

```bash
openclaw plugins install @parkgogogo/openclaw-engram
```

在 OpenClaw 配置里添加：

```json
{
  "plugins": {
    "entries": {
      "openclaw-engram": {
        "enabled": true,
        "config": {}
      }
    }
  }
}
```

不需要额外配置项。

## 命令说明

### `/engram-user`

返回固定提示词，敦促 OpenClaw 更新 `USER.md`，内容应是稳定的用户偏好、协作方式和持久个人上下文。

### `/engram-identity`

返回固定提示词，敦促 OpenClaw 更新 `IDENTITY.md`，内容应是明确的身份描述。

### `/engram-soul`

返回固定提示词，敦促 OpenClaw 更新 `SOUL.md`，内容应是助手原则、边界和连续性规则。

### `/engram-memory`

返回固定提示词，敦促 OpenClaw 更新 `MEMORY.md`，内容应是长期共享背景和持久结论。

### `/engram-tools`

返回固定提示词，敦促 OpenClaw 更新 `TOOLS.md`，内容应是工具映射、别名、端点和环境细节。

## 行为边界

每个命令都只返回固定纯文本：

- 不读取当前会话
- 不插入变量
- 命令一旦触发，就要求更新对应目标文件
- 新信息默认追加到目标文件末尾
- 如果有冲突事实，先提出替换建议并走 OpenClaw 现有确认流程
- 不直接写文件

## 开发

```bash
npm install
npm test
```
