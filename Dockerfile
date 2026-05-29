FROM php:8.4.21-apache

# 1. 用 apt 安装底层系统依赖库（对应你的 rpm 依赖，如 gd 库、zip 库、gettext 库等所需的底层 C 库）
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libpcre3-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. 配置并编译安装 PHP 官方原生自带的扩展
# (包含：mysqli, pdo_mysql, pcntl, gettext, opcache, zip, 以及带有 freetype 和 jpeg 支持的 gd 库)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    mysqli \
    gettext \
    pcntl \
    opcache \
    zip \
    gd

# 3. 通过 pecl 安装第三方 Redis 扩展并启用（对应你的 php-pecl-redis）
RUN pecl install redis && docker-php-ext-enable redis

# 4. 自动打通 Apache 的 URL 重写内核（省去在宿主机执行 a2enmod）
RUN a2enmod rewrite

# 5. 修改 Apache 主配置，允许 ThinkPHP 的 .htaccess 伪静态规则完全生效
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
