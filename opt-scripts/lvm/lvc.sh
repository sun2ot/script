#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

# 如果不是 root，就使用 sudo 执行需要的命令
SUDO=""
if [[ $EUID -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    echo "非 root 用户且系统中未找到 sudo，无法继续。" >&2
    exit 1
  fi
fi

read_nonempty() {
  local prompt="$1"
  local var
  while :; do
    read -r -p "$prompt" var
    if [[ -n "${var// /}" ]]; then
      printf "%s" "$var"
      return 0
    fi
    echo "输入不能为空，请重试。"
  done
}

echo "=== 创建逻辑卷并格式化为 ext4 ==="

VG=$(read_nonempty "请输入卷组名 (VG name): ")
# 检查卷组是否存在
if ! $SUDO vgs --noheadings "$VG" >/dev/null 2>&1; then
  echo "卷组 '$VG' 不存在。请先创建卷组或输入正确的卷组名。" >&2
  exit 2
fi

LV=$(read_nonempty "请输入逻辑卷名 (LV name): ")
# 检查 LV 是否已存在
if $SUDO lvs "/dev/$VG/$LV" >/dev/null 2>&1 || $SUDO lvs "${VG}/${LV}" >/dev/null 2>&1; then
  echo "逻辑卷 '$VG/$LV' 已存在，请选择其他名称或先移除已有的 LV。" >&2
  exit 3
fi

SIZE=$(read_nonempty "请输入逻辑卷大小 (例如 1T 或 25%VG): ")
# 简单校验大小是否为空（更复杂的格式校验可按需添加）
if [[ -z "$SIZE" ]]; then
  echo "大小不能为空。" >&2
  exit 4
fi

echo
echo "将要执行："
echo "  卷组: $VG"
echo "  逻辑卷: $LV"
echo "  大小: $SIZE"
echo

read -r -p "确认现在创建并格式化？(yes/NO): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "已取消。"
  exit 0
fi

# 创建 LV
echo "创建逻辑卷: lvcreate -L $SIZE -n $LV $VG"
if ! $SUDO lvcreate -L "$SIZE" -n "$LV" "$VG"; then
  echo "lvcreate 失败，退出。" >&2
  exit 5
fi

# 尝试获取 LV 的设备路径
LV_PATH=""
# lvs 可以输出 lv_path 字段
if LV_PATH=$($SUDO lvs --noheadings -o lv_path --separator ':' "${VG}/${LV}" 2>/dev/null | tr -d '[:space:]'); then
  :
fi
# 备选路径
if [[ -z "$LV_PATH" ]]; then
  if [[ -e "/dev/$VG/$LV" ]]; then
    LV_PATH="/dev/$VG/$LV"
  elif [[ -e "/dev/mapper/${VG}-${LV}" ]]; then
    LV_PATH="/dev/mapper/${VG}-${LV}"
  fi
fi

if [[ -z "$LV_PATH" ]]; then
  echo "创建了逻辑卷，但无法定位设备路径。请手动检查 /dev 下的 LV。"
  exit 6
fi

echo "找到 LV 设备: $LV_PATH"

# 格式化为 ext4
echo "开始格式化 $LV_PATH 为 ext4（mkfs.ext4）..."
if ! $SUDO mkfs.ext4 -F "$LV_PATH"; then
  echo "mkfs.ext4 失败，建议手动检查并清理已创建的 LV。" >&2
  exit 7
fi

echo "格式化成功：$LV_PATH 已被格式化为 ext4。"

echo
echo "提示：可创建挂载点并挂载："
echo "  sudo mount $LV_PATH /target_path"

exit 0

