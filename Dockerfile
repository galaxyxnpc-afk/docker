name: Download Docker Image
on: [push] # 当你点击提交时自动触发
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Pull and Save Image
        run: |
          docker pull php:8.4.21-apache
          docker save -o php-8.4.21-apache.tar php:8.4.21-apache
      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: php-image
          path: php-8.4.21-apache.tar
