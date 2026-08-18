#!/bin/bash

#
# ImmortalWrt DIY Part2
# After Update feeds
#

set -e


echo "===== DIY part2 start ====="


#
# 修改 .config
#

echo "===== Modify config ====="


# Argon主题

if grep -q "CONFIG_PACKAGE_luci-theme-argon" .config; then

    sed -i \
    's/^CONFIG_PACKAGE_luci-theme-argon=.*/CONFIG_PACKAGE_luci-theme-argon=y/' \
    .config

else

    echo "CONFIG_PACKAGE_luci-theme-argon=y" >> .config

fi



#
# 删除 Docker
#

echo "===== Disable Docker ====="


sed -i \
'/CONFIG_PACKAGE_.*docker.*/d' \
.config


sed -i \
'/CONFIG_PACKAGE_containerd=/d' \
.config


sed -i \
'/CONFIG_PACKAGE_runc=/d' \
.config


cat >> .config <<EOF
# CONFIG_PACKAGE_docker is not set
# CONFIG_PACKAGE_dockerd is not set
# CONFIG_PACKAGE_docker-compose is not set
# CONFIG_PACKAGE_luci-app-dockerman is not set
# CONFIG_PACKAGE_containerd is not set
# CONFIG_PACKAGE_runc is not set
EOF



#
# 删除多余主题
#

echo "===== Remove extra themes ====="


sed -i \
'/CONFIG_PACKAGE_luci-theme-material=/d' \
.config


sed -i \
'/CONFIG_PACKAGE_luci-theme-openwrt-2020=/d' \
.config



#
# 修改默认IP
#

echo "===== Set LAN IP ====="


sed -i \
's/192\.168\.1\.1/10.0.0.1/g' \
package/base-files/files/bin/config_generate



#
# 保留 ImmortalWrt 名称
#

echo "===== Keep ImmortalWrt ====="


sed -i \
's/OpenWrt/ImmortalWrt/g' \
package/base-files/files/bin/config_generate



#
# banner
#

echo "===== Copy banner ====="


if [ -f "$GITHUB_WORKSPACE/banner" ]; then

    cp -f \
    "$GITHUB_WORKSPACE/banner" \
    package/base-files/files/etc/banner

fi



#
# Argon 壁纸
#

echo "===== Copy Argon background ====="


ARGON_DIR="feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon"


if [ -f "$GITHUB_WORKSPACE/argon/background/background.jpg" ]; then


    mkdir -p \
    "$ARGON_DIR/background"


    cp -f \
    "$GITHUB_WORKSPACE/argon/background/background.jpg" \
    "$ARGON_DIR/background/background.jpg"



    # 兼容旧版 Argon

    cp -f \
    "$GITHUB_WORKSPACE/argon/background/background.jpg" \
    "$ARGON_DIR/background.jpg"


fi



#
# Argon 图标资源
#

if [ -d "$GITHUB_WORKSPACE/argon/icon" ]; then


    mkdir -p \
    "$ARGON_DIR/icon"


    cp -rf \
    "$GITHUB_WORKSPACE/argon/icon/"* \
    "$ARGON_DIR/icon/"


fi



#
# 调用默认设置
#

echo "===== Install default settings ====="


if [ -f "$GITHUB_WORKSPACE/99-default-settings" ]; then


    mkdir -p \
    package/base-files/files/etc/uci-defaults


    cp -f \
    "$GITHUB_WORKSPACE/99-default-settings" \
    package/base-files/files/etc/uci-defaults/99-default-settings


fi

echo "===== AFTER DIY CHECK ====="

grep -iE "docker|container|runc" .config || true

#
# 清理LuCI缓存
#

rm -rf /tmp/luci-modulecache
rm -f /tmp/luci-indexcache



echo "===== DIY part2 finish ====="