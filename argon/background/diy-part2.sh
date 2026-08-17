#!/bin/bash

echo "
# Argon主题
CONFIG_PACKAGE_luci-theme-argon=y

# TurboACC
CONFIG_PACKAGE_luci-app-turboacc=y

# 网络工具
CONFIG_PACKAGE_ethtool=y

# 网卡驱动
CONFIG_PACKAGE_kmod-e1000=y
CONFIG_PACKAGE_kmod-e1000e=y
CONFIG_PACKAGE_kmod-igb=y
CONFIG_PACKAGE_kmod-igbvf=y
CONFIG_PACKAGE_kmod-igc=y

CONFIG_PACKAGE_kmod-r8101=y
CONFIG_PACKAGE_kmod-r8169=y
CONFIG_PACKAGE_kmod-r8125=y
CONFIG_PACKAGE_kmod-r8126=y

" >> .config


# 设置默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate


# 保留ImmortalWrt名称
sed -i 's/OpenWrt/ImmortalWrt/g' package/base-files/files/bin/config_generate


# banner
cp -f $GITHUB_WORKSPACE/banner package/base-files/files/etc/banner


# Argon壁纸
if [ -d "$GITHUB_WORKSPACE/argon" ]; then

    cp -rf \
    $GITHUB_WORKSPACE/argon/* \
    feeds/luci/themes/luci-theme-argon/

fi


# 默认设置
if [ -f "$GITHUB_WORKSPACE/99-default-settings" ]; then

    mkdir -p package/base-files/files/etc/uci-defaults

    cp -f \
    $GITHUB_WORKSPACE/99-default-settings \
    package/base-files/files/etc/uci-defaults/99-default-settings

fi


# 清理重复主题
sed -i '/CONFIG_PACKAGE_luci-theme-material=y/d' .config
sed -i '/CONFIG_PACKAGE_luci-theme-openwrt-2020=y/d' .config


# 删除旧缓存
rm -rf tmp/luci-modulecache
rm -f tmp/luci-indexcache
