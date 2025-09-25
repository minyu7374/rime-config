# Rime输入方案轻量化定制配置

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
├── double_pinyin{,_flypy,_abc,...}.schema.yaml         # 双拼输入方案（rime-install double_pinyin）
├── double_pinyin.custom.yaml                           # 双拼自然码自定义调整
├── double_pinyin_flypy.custom.yaml                     # 小鹤双拼自定义调整
├── easy_en.{schema,dict,}.yaml                         # 英语输入法，用于中英混输（rime-install easy_en）
├── easy_en_fix.yaml                                    # 针对 essay_en.yaml 的配置修正，在主力输入法自定义配置中替换
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
│   ├── (chinese|english)*                              # 中英翻译opencc配置（取自万象输入方案）
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
    - 中英文翻译（ctrl+shift+5切换开关，默认关闭）
    - 计算器（`V` 触发）
    - 时间、日期、节气、农历信息等 （/sj、/rq、/ts、/jq、/nl、/day 等触发；另外，`N` 触发农历转换）
    - 词库配置中将万象的中英文混合词汇也加了进来
- [表情符输入](https://github.com/rime/rime-emoji) （ctrl+shift+7切换开关）
- [特殊符号候选](https://github.com/rime/rime-prelude) （Rime官方提供，`/` 触发，如 /fs：½ 等符号）
