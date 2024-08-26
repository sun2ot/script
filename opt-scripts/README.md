## Linux 运维脚本

### 组织结构

```
menu.sh                     # 脚本主菜单
├── 00deploy-aios.sh        # 见说明1
├── init-menu.sh            # 见说明2
├── apt-sources.sh          # 配置源
├── dns.sh                  # 配置dns
├── sshd-config.sh          # 配置 sshd (主要是切换 sftp 的模式)
├── install-aios.sh         # 常用软件安装
├── batch-create-user.sh    # 批量创建用户
├── create-user.sh          # 创建用户
├── batch-init-user.sh      # 批量初始化用户
├── init-user.sh            # 初始化用户
├── chsh-zsh.sh             # 切换shell: zsh
├── mihomo.sh               # Clash 代理
├── miniconda3.sh           # 安装 miniconda3
└── proxy.sh                # 写入代理配置函数

# 环境相关，需提前将安装包放置在指定路径
├── prepare.sh
├── node16.sh
├── go.sh
└── java.sh

# 示例文件
├── passwd.example.txt
└── user-list.example.txt
```

### 说明

1. `00deploy-aios.sh`：若干个脚本的集合，用于快速部署 AIOS 开发环境。
2. `init-menu.sh`：初始化脚本主菜单，主要执行以下操作
    - 软链接脚本到 `/usr/local/script`
    - 软链接shell配置到骨架目录 `/etc/skel`