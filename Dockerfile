FROM php:8.4.21-apache

# 设置工作目录
WORKDIR /var/www/html

# 安装依赖、PHP 扩展、redis、locale 设置、软链、权限设置等
# （这里完全保留你原汁原味的命令，仅在 apt-get 里加上了 wget 供后续下载 pear 包）
RUN apt-get update && \
    apt-get install -y \
        libzip-dev zip unzip cron locales wget \
    && docker-php-ext-install pdo pdo_mysql gettext mysqli pcntl \
    && yes "" | pecl install redis && docker-php-ext-enable redis \
    && a2enmod rewrite \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && sed -i 's/^;date.timezone =/date.timezone = PRC/' /usr/local/etc/php/php.ini \
    && ln -sf /usr/local/bin/php /usr/bin/php \
    && mkdir -p /etc/asterisk/ && chmod -R 777 /etc/asterisk/ \
    && echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen \
    && rm -rf /var/lib/apt/lists/*

# 1. 拷贝你本地项目里原有的 PHP 额外库（保护你的特定调整）
COPY ./src/pear/ /usr/local/lib/php/

# 2. 【精准修复】直接在上面 COPY 过去的基础上，在线把缺失的 DB 库及其驱动补进去
RUN wget http://pear.php.net/go-pear.phar \
    && php go-pear.phar \
    && pear install DB \
    && rm -f go-pear.phar

# 添加启动脚本并授权
COPY ./src/start.sh /data/doscs/start.sh
RUN chmod +x /data/doscs/start.sh

# 设置容器启动命令
CMD ["/data/doscs/start.sh"]
