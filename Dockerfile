FROM php:8.4.21-apache

# 1. 安装底层系统依赖库（补充安装 php-pear 所需的底层依赖）
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 2. 内置扩展配置与安装
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    mysqli \
    gettext \
    pcntl \
    opcache \
    zip \
    gd

# 3. 安装并启用第三方 Redis 扩展
RUN pecl install redis && docker-php-ext-enable redis

# 4. 【核心修复】动态下载并安装旧版 PHP 8.4 兼容的 PEAR 核心及 DB 组件
RUN wget http://pear.php.net/go-pear.phar \
    && php go-pear.phar \
    && pear install DB \
    && rm -f go-pear.phar

# 5. 自动打通 Apache 的 URL 重写内核
RUN a2enmod rewrite

# 6. 修改 Apache 主配置，允许 ThinkPHP 的伪静态规则完全生效
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
