#!/bin/bash

# ========== 用户配置(要检查哪些用户) ==========
USERS=("user1" "user2")

echo "========= GPU 使用情况检查 ========="

for USER in "${USERS[@]}"; do
  echo ""
  echo ">>> 正在以用户 $USER 的身份检查 GPU 使用情况..."

  # 获取用户的 GPU 使用信息（排除非 GPU 卡文件）
  OUTPUT=$(sudo -u "$USER" lsof /dev/nvidia* 2>/dev/null | grep -E "/dev/nvidia[0-9]+")

  if [[ -z "$OUTPUT" ]]; then

    echo "未检测到该用户占用 GPU。"
  else
    echo "$OUTPUT" | awk -v u="$USER" '
    {
      cmd = $1;
      pid = $2;
      file = $9;
      key = pid "|" cmd;
      files[key][file] = 1;
    }
    END {
      for (k in files) {
        split(k, arr, "|");
        pid = arr[1];
        cmd = arr[2];
        file_list = "";

        for (f in files[k]) {
          file_list = (file_list == "") ? f : file_list ", " f;
        }

        printf "用户: %-10s PID: %-7s 进程: %-15s 文件: %s\n", u, pid, cmd, file_list;
      }
    }'
  fi
done

echo ""
echo "✅ 检查完成。"
