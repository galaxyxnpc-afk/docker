FROM php:8.4.21-apache

# 设置工作目录
WORKDIR /var/www/html

# 安装依赖、PHP 扩展、redis、locale 设置、软链、权限设置等
RUN apt-get update && \
    apt-get install -y \
        libzip-dev zip unzip cron locales \
    && docker-php-ext-install pdo pdo_mysql gettext mysqli pcntl \
    && yes "" | pecl install redis && docker-php-ext-enable redis \
    && a2enmod rewrite \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && sed -i 's/^;date.timezone =/date.timezone = PRC/' /usr/local/etc/php/php.ini \
    && ln -sf /usr/local/bin/php /usr/bin/php \
    && mkdir -p /etc/asterisk/ && chmod -R 777 /etc/asterisk/ \
    && echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen \
    && rm -rf /var/lib/apt/lists/*

# 拷贝 PHP 额外库（如 pear 目录）
COPY ./src/pear/ /usr/local/lib/php/

# 添加启动脚本并授权
COPY ./src/start.sh /data/doscs/start.sh
RUN chmod +x /data/doscs/start.sh

# 设置容器启动命令
CMD ["/data/doscs/start.sh"]
