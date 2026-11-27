"""从万象拼写规则和混合词表生成项目使用的四种拼写索引规则。"""

import re
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
mixed = re.search(r"^mixed:\s*\n(.*?)(?=^\w[^\n]*:|\Z)", source, re.M | re.S).group(1)
print("mixed:")
for name in ("混合派生", "全拼", "自然码", "小鹤双拼"):
    section = re.search(rf"^  {name}:\n.*?(?=^  \S|\Z)", mixed, re.M | re.S)
    if not section:
        sys.exit(f"缺少上游 mixed/{name} 拼写规则")
    print(section.group().rstrip())

# 地球拼音逐音节派生声调，重复次数取决于词表里最长的带调编码。
words = Path(sys.argv[2]).read_text(encoding="utf-8").split("\n...\n", 1)[1]
tones = re.compile("[āáǎàōóǒòēéěèīíǐìūúǔùǖǘǚǜńňǹḿ]")
codes = (line.split("\t")[1] for line in words.splitlines() if "\t" in line and not line.startswith("#"))
max_tones = max(len(tones.findall(code)) for code in codes)
print("  地球拼音逐音节标调:\n    __patch:")
print("      - mixed_algebra:/mixed/混合派生")
print("      - terra_pinyin.custom:/mixed_mark_tones")
for _ in range(max_tones):
    print("      - terra_pinyin.custom:/mixed_one_tone")
print("      - terra_pinyin.custom:/mixed_finish_spelling")
