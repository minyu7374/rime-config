--[[
librime-lua 样例

调用方法：
在配方文件中作如下修改：
```
  engine:
    ...
    translators:
      ...
      - lua_translator@lua_function3
      - lua_translator@lua_function4
      ...
    filters:
      ...
      - lua_filter@lua_function1
      - lua_filter@lua_function2
      ...
```

其中各 `lua_function` 为在本文件所定义变量名。
--]]

--[[
本文件的后面是若干个例子，按照由简单到复杂的顺序示例了 librime-lua 的用法。
每个例子都被组织在 `lua` 目录下的单独文件中，打开对应文件可看到实现和注解。

各例可使用 `require` 引入。
如：
```
  foo = require("bar")
```
可认为是载入 `lua/bar.lua` 中的例子，并起名为 `foo`。
配方文件中的引用方法为：`...@foo`。

--]]


-- I. translators:

-- date_translator: 将 `date` 翻译为当前日期
-- 详见 `lua/date.lua`:
date_translator = require("date")

-- time_translator: 将 `time` 翻译为当前时间
-- 详见 `lua/time.lua`
time_translator = require("time")

-- plum 目前还不能自动引入 lua 脚本，所以在使用以词定字之前还需要手动在 rime 配置目录下的 rime.lua 文件中添加以下
-- select_character_processor: 以词定字
-- 详见 `lua/select_character.lua`
select_character_processor = require("select_character")

-- II. filters:

-- charset_filter: 滤除含 CJK 扩展汉字的候选项
-- charset_comment_filter: 为候选项加上其所属字符集的注释
-- 详见 `lua/charset.lua`
local charset = require("charset")
charset_filter = charset.filter
charset_comment_filter = charset.comment_filter

-- single_char_filter: 候选项重排序，使单字优先
-- 详见 `lua/single_char.lua`
single_char_filter = require("single_char")

-- reverse_lookup_filter: 依地球拼音为候选项加上带调拼音的注释
-- 详见 `lua/reverse.lua`
reverse_lookup_filter = require("reverse")

-- easy_en_enhance_filter: 连续输入增强
-- 详见 `lua/easy_en.lua`
local easy_en = require("easy_en")
easy_en_enhance_filter = easy_en.enhance_filter

