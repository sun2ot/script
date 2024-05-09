import os
import shutil

# 源路径（Zotero存储路径）
source_path = r'F:\Documents\zotero\storage'

# 目标路径（要复制到的路径）
target_path = r'F:\zotero-pdf'

try:
  # 遍历源路径下的所有文件夹和文件
  for root, dirs, files in os.walk(source_path):
      for file in files:
          # 检查文件扩展名是否为.pdf
          if file.endswith('.pdf'):
              # 构建源文件的完整路径
              source_file = os.path.join(root, file)
              # 构建目标文件的完整路径
              target_file = os.path.join(target_path, file)
              # 复制文件
              shutil.copy2(source_file, target_file)
  print(f'export all zotero pdf files to "{target_path}"')
except Exception as e:
  print(e)

