FROM php:8.4.21-apache

# 1. 彻底补齐编译 gd, zip, pcntl, gettext 所需的底层依赖库（适配 Debian 13 核心）
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. 完美的内置扩展配置与安装
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    mysqli \
    gettext \
    pcntl \
    opcache \
    zip \
    gd

# 3. 安装并启用第三方 Redis
RUN pecl install redis && docker-php-ext-enable redis

# 4. 自动打通 Apache 的 URL 重写内核
RUN a2enmod rewrite

# 5. 修改 Apache 主配置，允许 ThinkPHP 的伪静态规则完全生效
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
