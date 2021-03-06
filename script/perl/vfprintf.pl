#!/usr/bin/perl

# 1. 格式化示例
$text = "google runoob taobao";
format STDOUT =
first: ^<<<<<  # 左边对齐，字符长度为6
    $text
second: ^<<<<< # 左边对齐，字符长度为6
    $text
third: ^<<<< # 左边对齐，字符长度为5，taobao 最后一个 o 被截断
    $text  
.
write
# 打印结果
# first: google
# second: runoob
# third: taoba

# 2. 格式行（图形行）语法
格式行以 @ 或者 ^ 开头，这些行不作任何形式的变量代换。
@ 字段(不要同数组符号 @ 相混淆)是普通的字段。
@,^ 后的 <, >,| 长度决定了字段的长度，如果变量超出定义的长度,那么它将被截断。
<, >,| 还分别表示,左对齐,右对齐,居中对齐。
^ 字段用于多行文本块填充。

# 3.值域格式
@<<<        # 左对齐输出
@>>>        # 右对齐输出
@|||        # 中对齐输出
@##.##      # 固定精度数字 （表示6个字符宽，小数点前3个，小数点后两个）
@*          # 多行文本

# 4.示例
format EMPLOYEE =
===================================
@<<<<<<<<<<<<<<<<<<<<<< @<< 
$name, $age
@#####.##
$salary
===================================
.
 
select(STDOUT);
$~ = EMPLOYEE;
 
@n = ("Ali", "Runoob", "Jaffer");
@a  = (20,30, 40);
@s = (2000.00, 2500.00, 4000.000);
 
$i = 0;
foreach (@n){
    $name = $_;
    $age = $a[$i];
    $salary = $s[$i++];
    write;
}
# 打印结果
===================================
Ali                     20
  2000.00
===================================
===================================
Runoob                  30
  2500.00
===================================
===================================
Jaffer                  40
  4000.00
===================================

# 5. 格式变量
$~ ($FORMAT_NAME) ：格式名字 $^ ($FORMAT_TOP_NAME) ：当前的表头格式名字存储在
$% ($FORMAT_PAGE_NUMBER) ：当前输出的页号
$= ($FORMAT_LINES_PER_PAGE) ：每页中的行数
$| ($FORMAT_AUTOFLUSH) ：是否自动刷新输出缓冲区存储
$^L ($FORMAT_FORMFEED) ：在每一页(除了第一页)表头之前需要输出的字符串存储在

# 6. $~格式化行
$~ = "MYFORMAT"; # 指定默认文件变量下所使用的格式
write;           # 输出 $~ 所指定的格式
 
format MYFORMAT = # 定义格式 MYFORMAT 
=================================
      Text # 菜鸟教程
=================================
.
write;
# 每个write即打印一个format格式输出
# 打印结果
=================================
      Text # 菜鸟教程
=================================
=================================
      Text # 菜鸟教程
=================================

# 7. 不指定 $~ 情况，输出STDOUT格式
write;           # 不指定$~的情况下会寻找名为STDOUT的格式

format STDOUT = 
~用~号指定的文字不会被输出
----------------
  STDOUT格式
----------------
.                
# 以.结束format定义
# 打印结果
----------------
  STDOUT格式
----------------


# 8. 添加报表头部信息示例
format EMPLOYEE =
===================================
@<<<<<<<<<<<<<<<<<<<<<< @<< 
$name, $age
@#####.##
$salary
===================================
.
 
format EMPLOYEE_TOP =
===================================
Name                    Age
===================================
.
 
select(STDOUT);
$~ = EMPLOYEE;
$^ = EMPLOYEE_TOP;
 
@n = ("Ali", "Runoob", "Jaffer");
@a  = (20,30, 40);
@s = (2000.00, 2500.00, 4000.000);
 
$i = 0;
foreach (@n){
   $name = $_;
   $age = $a[$i];
   $salary = $s[$i++];
   write;
}
# 打印结果
===================================
Name                    Age
===================================
===================================
Ali                     20
  2000.00
===================================
===================================
Runoob                  30
  2500.00
===================================
===================================
Jaffer                  40
  4000.00
===================================

# 9.为报表设置分页
format EMPLOYEE =
===================================
@<<<<<<<<<<<<<<<<<<<<<< @<< 
$name, $age
@#####.##
$salary
===================================
.
 
# 添加分页 $% 
format EMPLOYEE_TOP =
===================================
Name                    Age Page @<
                                 $%
=================================== 
.
 
select(STDOUT);
$~ = EMPLOYEE;
$^ = EMPLOYEE_TOP;
 
@n = ("Ali", "Runoob", "Jaffer");
@a  = (20,30, 40);
@s = (2000.00, 2500.00, 4000.000);
 
$i = 0;
foreach (@n){
   $name = $_;
   $age = $a[$i];
   $salary = $s[$i++];
   write;
}
# 打印结果
===================================
Name                    Age Page 1
===================================
===================================
Ali                     20
  2000.00
===================================
===================================
Runoob                  30
  2500.00
===================================
===================================
Jaffer                  40
  4000.00
===================================

# 10. perl格式化输出到其他文件
if (open(MYFILE, ">tmp.v")) {
$~ = "MYFORMAT"   #不能用$~变量来改变所使用的打印格式。系统变量$~只对默认文件变量起作用，
                  #因此可以改变默认文件变量，改变$~，再调用write
write MYFILE; # 含文件变量的输出，此时会打印与变量同名的格式，即MYFILE。$~里指定的值被忽略。

format MYFILE = # 与文件变量同名 
=================================
      输入到文件中
=================================
.
close MYFILE;
}

# 11. select改变默认文件变量
if (open(MYFILE, ">>tmp")) {
select (MYFILE); # 使得默认文件变量的打印输出到MYFILE中
$~ = "OTHER";
write;           # 默认文件变量，打印到select指定的文件中，必使用$~指定的格式 OTHER
 
format OTHER =
=================================
  使用定义的格式输入到文件中
=================================
. 
close MYFILE;
}
#打印结果
=================================
      输入到文件中
=================================
=================================
  使用定义的格式输入到文件中
=================================


