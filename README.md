# Bash-INI-Parser
ini parser for bash.     用于解析ini配置文件的bash函数
>[中文_简化字 [en_US](https://github.com/LGY07/Bash-INI-Parser/blob/main/README_en_US.md)]

### 使用方法
(可忽略`INI_Paser.sh`文件，以此教程为主)
#### 1.将以下代码块直接加入需要解析ini的脚本

```
NAME='_'$2
SECTION_NUM=$(grep "^\\[" $1 | grep "]$" | wc -l)
export $NAME'__SECNUM'=$(grep "^\\[" $1 | grep "]$" | wc -l)
SEC_TIMES=1
export $NAME'__SECTIONS'="$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//")"
while [[ $SEC_TIMES -le $SECTION_NUM ]]
do
    let SEC_TIMES_ADD=$SEC_TIMES+1
    SECTION_NAME_A=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES" | sed "s/^$SEC_TIMES://")
    SECTION_NAME_B=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES_ADD" | sed "s/^$SEC_TIMES_ADD://")
    let STA_LINE=$(cat $1 | grep "^\\[$SECTION_NAME_A]" -n | grep -Eo '^[0-9]*')+1
    if [[ $SEC_TIMES -eq $SECTION_NUM ]];then END_LINE=$(cat $1 | wc -l)
    else let END_LINE=$(cat $1 | grep "^\\[$SECTION_NAME_B]" -n | grep -Eo '^[0-9]*')-1;fi
    KEY_NUM=$(cat $1 | sed -n "$STA_LINE,$END_LINE p" | grep -v "^;" | wc -l)
    KEY_TIMES=1
    export $NAME'__SEC'$SEC_TIMES=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES" | sed "s/^$SEC_TIMES://")
    while [[ $KEY_TIMES -le $KEY_NUM ]]
    do
        export $NAME'_'$SECTION_NAME_A'_'"$(cat $1 | sed -n "$STA_LINE,$END_LINE p" | grep -v "^;" | grep -v -e '^$'| grep -n "" | grep "^$KEY_TIMES" | sed "s/^$KEY_TIMES://")"
        export $NAME'__SEC'$SEC_TIMES'_'"$(cat $1 | sed -n "$STA_LINE,$END_LINE p" | grep -v "^;" | grep -v -e '^$'| grep -n "" | grep "^$KEY_TIMES" | sed "s/^$KEY_TIMES://")"
        let KEY_TIMES=$KEY_TIMES+1
    done
    let SEC_TIMES=$SEC_TIMES+1
done
#return 0
}
```
#### 2.使用INI_Parser解析ini文件
```
INI_Parser ini_file string
```
以上`ini_file`替换为需要解析的文件名，`string`替换为一个字符串(字符串是为了防止多个ini混淆,可以为空)

#### 3.ini文件的内容将会被储存到变量中,以解析`example.ini`为例
`example.ini`:
```
[SECTION]
KEY=1
```
储存在以下变量：

`_string_SECTION_KEY`:"SECTION"节中的"KEY"键的值，example.ini中的值为"1"

`_string__SECNUM`:节的数量，example.ini中的值为"1"

`_string__SECTIONS`:所有的节的名称(用空格分开)，example.ini中的值为"SECTION"

`_string__SEC1`:第一个节的名称(若需要不同的节的名称，请将"1"替换为对应节的序数)，example.ini中的值为"SECTION"

`_string__SEC1_KEY`:第一个节中"KEY"键的值，example.ini中的值为"1"

#### 4.一些复杂的示例：

`a.ini`
```
[abc1]
a=1
b=2
c=3
;这句话为注释内容不会被读取

[abc2]
a=4
b=5
c=6
```
`a.sh`
```
#!/bin/bash
##函数声明
INI_Parser() {
NAME='_'$2
SECTION_NUM=$(grep "^\\[" $1 | grep "]$" | wc -l)
export $NAME'__SECNUM'=$(grep "^\\[" $1 | grep "]$" | wc -l)
SEC_TIMES=1
export $NAME'__SECTIONS'="$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//")"
while [[ $SEC_TIMES -le $SECTION_NUM ]]
do
    let SEC_TIMES_ADD=$SEC_TIMES+1
    SECTION_NAME_A=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES" | sed "s/^$SEC_TIMES://")
    SECTION_NAME_B=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES_ADD" | sed "s/^$SEC_TIMES_ADD://")
    let STA_LINE=$(cat $1 | grep "^\\[$SECTION_NAME_A]" -n | grep -Eo '^[0-9]*')+1
    if [[ $SEC_TIMES -eq $SECTION_NUM ]];then END_LINE=$(cat $1 | wc -l)
    else let END_LINE=$(cat $1 | grep "^\\[$SECTION_NAME_B]" -n | grep -Eo '^[0-9]*')-1;fi
    KEY_NUM=$(cat $1 | sed -n "$STA_LINE,$END_LINE p" | grep -v "^;" | wc -l)
    KEY_TIMES=1
    export $NAME'__SEC'$SEC_TIMES=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES" | sed "s/^$SEC_TIMES://")
    while [[ $KEY_TIMES -le $KEY_NUM ]]
    do
        export $NAME'_'$SECTION_NAME_A'_'"$(cat $1 | sed -n "$STA_LINE,$END_LINE p" | grep -v "^;" | grep -v -e '^$'| grep -n "" | grep "^$KEY_TIMES" | sed "s/^$KEY_TIMES://")"
        export $NAME'__SEC'$SEC_TIMES'_'"$(cat $1 | sed -n "$STA_LINE,$END_LINE p" | grep -v "^;" | grep -v -e '^$'| grep -n "" | grep "^$KEY_TIMES" | sed "s/^$KEY_TIMES://")"
        let KEY_TIMES=$KEY_TIMES+1
    done
    let SEC_TIMES=$SEC_TIMES+1
done
#return 0
}

##解析a.ini
INI_Parser a.ini ABC

##输出变量值
echo $_ABC_abc1_a $_ABC_abc1_b $_ABC_abc1_c
echo $_ABC_abc2_a $_ABC_abc2_b $_ABC_abc2_c
echo $_ABC__SECNUM
echo $_ABC__SECTIONS
echo $_ABC__SEC1
echo $_ABC__SEC2
echo $_ABC__SEC1_a
```
`输出结果`
```
1 2 3
4 5 6
2
abc1 abc2
abc1
abc2
1
```
