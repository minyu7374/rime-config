# Rime输入方案轻量化定制配置

## 万象维护约定

本项目独立维护输入方案，按需借鉴万象的词库和功能。同步脚本只更新项目明确选用的上游依赖，下载的万象词表统一放在 `dicts/`。

含项目定制的代码以仓库版本为准。例如 `lua/shijian.lua` 保留了时间命令和生日提醒，`lua/wanxiang/super_replacer.lua` 支持本项目启用的多种方案。日常同步直接安装这两个文件。上游出现相关改进时，审阅后把需要的改动合入项目源码。同步流程不维护针对上游的补丁。

## 更新依赖

在仓库根目录运行以下命令可将依赖更新到当前项目。

```sh
rime_dict="$PWD" bin/rime_plum
```

`rime_dict` 指定 Rime 数据目录。省略时沿用平台默认目录，macOS 为 `~/Library/Rime`。也可以单独传入 Plum recipe，例如 `rime_dict="$PWD" bin/rime_plum essay`。

脚本默认使用 `/opt/src/tool/plum` 中的 Plum 安装器。全量同步会用到 Git、curl、jq、unzip、shasum 和 Python 3。

## 词库选择

- 中文主词典使用万象的字表、基础词库、错音和多音词库，并启用地名、人名、诗词及专业词库。上游持续发布的 14 张词表随脚本更新。项目保留原有的 `lianxiang` 长词和 `renming` 人名词表，补充新版词库未覆盖的条目。[万象词库发布](https://github.com/amzxyz/rime-wanxiang-data/releases/tag/dict-nightly)
- 英文候选由 `easy_en` 提供。中英混合词来自 `dicts/mixed.dict.yaml`，优先级为 `-2`，低于 `easy_en` 的 `-1`。混合词源支持输入补全，关闭自动组句和用户词学习。
- 朙月全拼、地球拼音、小鹤双拼和自然码共用这一份混合词表，分别使用自己的拼写索引。例如「iOS开发」在全拼下输入 `ioskaifa`，在小鹤下输入 `ioskdfa`，在自然码下输入 `iosklfa`。地球拼音可用 `iosban,` 输入「iOS版」。

## 主要配置结构

```
├── bin
│   ├── rime_dedup                                      # 字典去重脚本
│   └── rime_plum                                       # 配置管理和词库下载相关操作整合成脚本（主要使用plum-install）
├── build
│   └── {zdict,kMandarin,pinyin,...}.reverse.bin        # 部件拆字方案（radical_pinyin）编译好的提示码词表（当前选用pinyin）
├── common.yaml                                         # 主力输入方案通用自定义配置
├── custom_phrase.txt                                   # 私人词库（加入.gitignore）
├── {default,key_bindings,punctuation,symbols}.yaml     # 输入法基础配置（rime-install prelude）
├── default.custom.yaml                                 # 基础默认配置自定义调整
├── symbols.custom.yaml                                 # 针对符号候选条目的自定义调整
├── dicts
│   └── *.dict.yaml                                     # 三方词库文件（当前主要使用万象词库）
├── mixed.dict.yaml                                     # 各方案共用的混合词典入口，导入 dicts/mixed.dict.yaml
├── double_pinyin{,_flypy,_abc,...}.schema.yaml         # 双拼输入方案（rime-install double_pinyin）
├── double_pinyin.custom.yaml                           # 双拼自然码自定义调整
├── double_pinyin_flypy.custom.yaml                     # 小鹤双拼自定义调整
├── easy_en.{schema,dict,}.yaml                         # 英语输入法，用于中英混输（rime-install easy_en）
├── easy_en_fix.yaml                                    # 主力输入方案使用的 easy_en 候选配置
├── emoji_suggestion.yaml                               # 表情符输入（rime-install emoji）
├── essay.txt                                           # Rime预设词库，当前使用的词库配置已不加载（rime-install essay）
├── {grammar.yaml,*.gram}                               # 预设词库配套语言模型（rime-install lotem/rime-octagram-data ）
├── grammar.custom.yaml                                 # 自定义语言模型（参考万象输入方案）
├── lua_select_character.yaml                           # 以词定字（rime-install BlindingDark/rime-lua-select-character）
├── lua
│   ├── easy_en.lua                                     # easy_en的lua工具函数定义
│   ├── search.lua                                      # radical_pinyin 的反查候选lua工具
│   ├── select_character.lua                            # 以词定字lua工具
│   ├── shijian.lua                                     # 日期时间处理小工具（取自万象输入方案，微调少量键序）
│   └── super_calculator.lua                            # 计算器工具（取自万象输入方案）
├── luna_{pinyin*,quanpin}.{schema,dict,...}.yaml       # 朙月拼音输入方案配置及词库（rime-install 朙月拼音）
├── pinyin.yaml                                         # 朙月拼音方案定义的模糊音处理规则
├── luna_pinyin.custom.yaml                             # 朙月拼音方案自定义配置
├── luna_pinyin.extended.dict.yaml                      # 朙月拼音方案自定义扩展词库
├── opencc
│   └── emoji*                                          # 表情符输入opencc配置
├── radical_pinyin.*.yaml                               # 部件拆字方案（rime-install radical_pinyin）
├── terra_pinyin.{schema,dict,...}.yaml                 # 地球拼音输入方案配置及词库（rime-install terra_pinyin）
├── terra_pinyin.custom.yaml                            # 地球拼音方案自定义配置
├── terra_pinyin.extended.dict.yaml                     # 地球拼音方案自定义扩展词库
├── wanxiang.dict.yaml                                  # 自定义万象词库配置
├── squirrel.custom.yaml                                # MacOS 鼠鬚管前端自定义配置
└── weasel.custom.yaml                                  # windows 小狼毫前端自定义配置
```

## 主要功能

- [中英混输](https://github.com/BlindingDark/rime-easy-en)
- [以词定字](https://github.com/BlindingDark/rime-lua-select-character) （用 `[` 和 `]` 选取词组开头或结尾的一个字）
- [部件拆字](https://github.com/mirtlecn/rime-radical-pinyin)
    - `~` 直接触发拆字反查 （对应Rime原有的五笔画反查触发键`` ` ``）
    - 拼音后`` ` `` 触发候选列表中反查（当前配置使用radical_pinyin反查方案，也可配置使用五笔画反查方案）
- [万象输入方案](https://github.com/amzxyz/rime_wanxiang)功能引用:
    - 中英文翻译（Ctrl+Shift+6 切换，默认开启）。英译中随上游的 `english_chinese.txt` 更新，中译英使用项目保留的 `chinese_english.txt`。
    - 计算器（`V` 触发）
    - 时间、日期、节气、农历信息等 （/sj、/rq、/ts、/jq、/nl、/day 等触发；另外，`N` 触发农历转换）
- [表情符输入](https://github.com/rime/rime-emoji) （Ctrl+Shift+8 切换开关）
- [特殊符号候选](https://github.com/rime/rime-prelude) （Rime官方提供，`/` 触发，如 /fs：½ 等符号）
