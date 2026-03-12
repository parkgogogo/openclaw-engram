# OpenClaw Engram

## 让 OpenClaw 的记忆写入变简单。

`openclaw-engram` 是一种更简单的方式，让 OpenClaw 按你的明确意图更新记忆。

没有自动 reflection pipeline。  
没有后台分析。  
没有隐藏的写入判断。  
没有一个自作聪明的记忆系统替你做决定。

装一个 plugin，就得到 5 个随包附带的 skill commands。OpenClaw 会去更新你指定的那个记忆文件。

## 安装

```bash
openclaw plugins install @parkgogogo/openclaw-engram
```

把下面这段加入 OpenClaw 配置：

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

不需要额外配置。

## 为什么是 Engram

Reflection 很强。
Engram 更简单。

它把记忆写入变成一个明确动作：

- 一个命令
- 一个目标文件
- 一个清晰的写入意图

什么时候该改记忆，由你决定。

## 它怎么工作

这个 plugin 随包携带了 5 个 `user-invocable` skills，并把它们暴露成 slash commands：

- `/engram-user`
- `/engram-identity`
- `/engram-soul`
- `/engram-memory`
- `/engram-tools`

你执行哪个命令，OpenClaw 就会把它路由进 agent，并更新对应文件。

这就是整个产品。

## 写入规则

Engram 的规则也保持简单：

- 只更新目标文件
- 新增信息默认追加
- 如果有冲突事实，先走 OpenClaw 的确认流程再替换
- 既然触发了命令，就不应该跳过写入

## 五个命令

### `/engram-user`

更新 `USER.md`。

### `/engram-identity`

更新 `IDENTITY.md`。

### `/engram-soul`

更新 `SOUL.md`。

### `/engram-memory`

更新 `MEMORY.md`。

### `/engram-tools`

更新 `TOOLS.md`。

## 开发

```bash
npm install
npm test
npm run e2e:openclaw-plugin
```

`npm test` 用来验证 bundled skill 契约和包元数据。

`npm run e2e:openclaw-plugin` 会在隔离 profile 里跑一遍真实的本地 OpenClaw gateway 流程，并验证 `USER.md` 和 `TOOLS.md` 的实际写入。

如果要临时覆盖 `.env` 里的 key，可以先导出 `OPENCLAW_E2E_API_KEY` 再跑 e2e。
