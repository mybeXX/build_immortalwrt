#!/bin/bash

#
# OpenWrt DIY script part 2
# After Update feeds
#

set -e


echo "===== 开始执行 DIY part2 ====="


#
# 设置软件包
# 使用 scripts/config 避免破坏 .config
#

echo "===== 设置 LuCI 主题 ====="

./scripts/config set PACKAGE_luci-theme-argon


#
# 禁用不需要的软件
#

echo "===== 清理无用组件 ====="

# Docker
./scripts/config unset PACKAGE_docker || true
./scripts/config unset PACKAGE_dockerd || true
./scripts/config unset PACKAGE_docker-compose || true


# 开发工具
./scripts/config unset PACKAGE_gdb || true
./scripts/config unset PACKAGE_git || true
./scripts/config unset PACKAGE_gcc || true
./scripts/config unset PACKAGE_g++ || true


#
# TurboACC
#
# 如果你的 .config 已经选择，这里不强制
#

echo "===== TurboACC 保留配置 ====="

# ./scripts/config set PACKAGE_luci-app-turboacc


#
# 修改默认 LAN IP
#

echo "===== 修改默认 LAN ====="

sed -i 's/192\.168\.1\.1/10.0.0.1/g' \
package/base-files/files/bin/config_generate


#
# 修改默认主机名
#

sed -i 's/ImmortalWrt/ImmortalWrt/g' \
package/base-files/files/bin/config_generate


#
# 默认密码为空
#

echo "===== 设置默认空密码 ====="

sed -i 's/root::0:0:99999:7:::/root::0:0:99999:7:::/g' \
package/base-files/files/etc/shadow 2>/dev/null || true



#
# Banner
#

echo "===== 设置系统 Banner ====="

if [ -f "$GITHUB_WORKSPACE/banner" ]; then
    cp -f \
    "$GITHUB_WORKSPACE/banner" \
    package/base-files/files/etc/banner
fi



#
# Argon 壁纸
#

echo "===== 设置 Argon 壁纸 ====="


ARGON_PATH="feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon"


if [ -d "$ARGON_PATH" ]; then


    mkdir -p \
    "$ARGON_PATH/background"


    if [ -f "$GITHUB_WORKSPACE/argon/background/background.jpg" ]; then

        cp -f \
        "$GITHUB_WORKSPACE/argon/background/background.jpg" \
        "$ARGON_PATH/background/background.jpg"

    fi


fi



#
# Argon 图标资源
#

if [ -d "$GITHUB_WORKSPACE/argon" ]; then


    mkdir -p \
    "$ARGON_PATH/img"


    [ -f "$GITHUB_WORKSPACE/argon/img/bg1.jpg" ] && \
    cp -f \
    "$GITHUB_WORKSPACE/argon/img/bg1.jpg" \
    "$ARGON_PATH/img/bg1.jpg"


    [ -f "$GITHUB_WORKSPACE/argon/img/argon.svg" ] && \
    cp -f \
    "$GITHUB_WORKSPACE/argon/img/argon.svg" \
    "$ARGON_PATH/img/argon.svg"


fi



#
# ImmortalWrt版本显示
#

echo "===== 修改版本显示 ====="


if [ -f package/emortal/default-settings/files/99-default-settings ]; then

    cp -f \
    "$GITHUB_WORKSPACE/99-default-settings" \
    package/emortal/default-settings/files/99-default-settings \
    || true

fi



#
# DNS日志关闭
#

if [ -f /etc/dnsmasq.conf ]; then

    sed -i '/log-facility/d' /etc/dnsmasq.conf
    echo "log-facility=/dev/null" >> /etc/dnsmasq.conf

fi



#
# 清理缓存
#

rm -rf /tmp/luci-modulecache
rm -f /tmp/luci-indexcache



echo "===== DIY part2 完成 ====="