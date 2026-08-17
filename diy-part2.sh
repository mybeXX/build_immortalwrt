#!/bin/bash

#
# ImmortalWrt Custom DIY Part2
#


echo "

# Argon主题
CONFIG_PACKAGE_luci-theme-argon=y


# TurboACC
CONFIG_PACKAGE_luci-app-turboacc=y


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


# 网络工具
CONFIG_PACKAGE_ethtool=y


" >> .config



# =========================
# 默认 LAN IP
# =========================

sed -i 's/192.168.1.1/10.0.0.1/g' \
package/base-files/files/bin/config_generate



# =========================
# 保留 ImmortalWrt 名称
# =========================

sed -i 's/OpenWrt/ImmortalWrt/g' \
package/base-files/files/bin/config_generate



# =========================
# Banner
# =========================

if [ -f "$GITHUB_WORKSPACE/banner" ]; then

cp -f \
$GITHUB_WORKSPACE/banner \
package/base-files/files/etc/banner

fi



# =========================
# Argon 自定义壁纸
# =========================

if [ -f "$GITHUB_WORKSPACE/argon/background/background.jpg" ]; then


mkdir -p \
feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background


cp -f \
$GITHUB_WORKSPACE/argon/background/background.jpg \
feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background/background.jpg



# 兼容部分 Argon 版本

cp -f \
$GITHUB_WORKSPACE/argon/background/background.jpg \
feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/background.jpg


fi



# =========================
# 默认设置
# =========================

if [ -f "$GITHUB_WORKSPACE/99-default-settings" ]; then


mkdir -p \
package/base-files/files/etc/uci-defaults


cp -f \
$GITHUB_WORKSPACE/99-default-settings \
package/base-files/files/etc/uci-defaults/99-default-settings


fi



# =========================
# 删除无用主题
# =========================

sed -i '/CONFIG_PACKAGE_luci-theme-material=y/d' .config

sed -i '/CONFIG_PACKAGE_luci-theme-openwrt-2020=y/d' .config



# =========================
# 清理 LuCI缓存
# =========================

rm -rf tmp/luci-modulecache
rm -f tmp/luci-indexcache
