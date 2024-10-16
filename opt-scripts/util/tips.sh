#!/bin/bash

remind() {
  echo -e "\e[42m###########请看这里###########\e[0m"
  if [[ $SHELL == *"/bash" ]]; then
    echo -e "请执行 \e[32m\"source ~/.bashrc\"\e[0m 激活环境!!!"
  elif [[ $SHELL == *"/zsh" ]]; then
    echo -e "请执行 \e[32m\"source ~/.zshrc\"\e[0m 激活环境!!!"
  fi
}

next_login() {
    echo -e "\e[32m当前shell已切换\e[0m"
    echo -e "请执行\e[33m'exit'\e[0m退出登录"
    echo -e "\e[33m下次登录\e[0m时修改才会生效！"
}