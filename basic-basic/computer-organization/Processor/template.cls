\NeedsTeXFormat{LaTeX2e}[1999/12/01]

\ProvidesClass{template}[notes template]

\LoadClass[openany,UTF8,zihao=-4,scheme=plain]{article}
\usepackage{ctex}

\RequirePackage{geometry}
\geometry{
    a4paper,
    left=19.1mm,
    right=19.1mm,
    top=25.4mm,
    bottom=25.4mm
}
% \geometry{
%   a4paper, % 210 * 297mm
%   hcentering,
%   ignoreall,
%   nomarginpar,
% }
% \geometry{% 版芯高度 = textheight(224) + head(5) + headsep(3) + footskip(8) = 240 mm
%   text={150true mm,224true mm},
%   top=37.5true mm,
%   left=30true mm,
%   head=5true mm,
%   headsep=3true mm,
%   footskip=0true mm,
%   foot=8true mm
% }


\newenvironment{myquote}{\begin{quote}\zihao{5}\kaishu}{\end{quote}}

% 设置全局字体族
% \renewcommand\familydefault{\ttdefault}

% 颜色
\usepackage{xcolor}
% 代码
\usepackage{listings}
% 配置代码块：https://zhuanlan.zhihu.com/p/261667944
\lstset{
    % frame=RBlt, % 大写的地方有重线R-right、B-bottom
    frame=shadowbox,
    frameround=tttf, % 边框圆角
    rulecolor=\color{gray}, % 边框颜色
    % rulesepcolor=\color{brown}, % 重线颜色
    keywordstyle=\color{purple}, % 关键字颜色
    commentstyle=\it\color{gray}, % 注释颜色
    identifierstyle=\color{black}, % 变量名和参数
    stringstyle=\color{green!60!black}, % 字符串颜色
    basicstyle=\small\ttfamily\color{black}, % 括号颜色
    showstringspaces=false,
    % numbers=left, %  代码行数显示
    % backgroundcolor=\color{white}, % 背景颜色
    % breaklines = true, % 一行代码过多，自动换行
}


% 图片
\usepackage{graphicx}


% 书签目录
\usepackage{hyperref}
% 不显示引用的红色小框框
\hypersetup{
    colorlinks=true,
    linkcolor=black
}
