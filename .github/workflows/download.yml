name: Download Docker Image

# 触发条件：当推送到 main 分支，或者你手动点击运行时触发
on:
  push:
    branches: [ "main" ]
  workflow_dispatch:

jobs:
  download-and-pack:
    runs-on: ubuntu-latest

    steps:
    # 1. 并在 GitHub 服务器上拉取目标 PHP 镜像
    - name: Pull PHP Image
      run: |
        docker pull php:8.4.21-apache

    # 2. 将镜像保存为 tar 归档文件，并进行 gzip 压缩（减小文件体积，方便下载）
    - name: Save and Compress Image
      run: |
        docker save php:8.4.21-apache | gzip > php-8.4.21-apache.tar.gz

    # 3. 将打包好的文件上传到 GitHub 的 Artifacts（下载产物）中
    - name: Upload Artifact
      uses: actions/upload-artifact@v4
      with:
        name: php-8.4.21-apache-image
        path: php-8.4.21-apache.tar.gz
        retention-days: 1 # 下载链接保留1天
