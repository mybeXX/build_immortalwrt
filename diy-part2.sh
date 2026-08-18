#!/bin/bash

#
# ImmortalWrt DIY Part2
# After Update feeds
#

set -e


echo "===== DIY part2 start ====="



#
# 修改配置
#

echo "===== Modify config ====="



CONFIG_FILE=".config"



#
# 强制关闭 Docker
#

echo "===== Disable Docker ====="



for pkg in \
docker \
dockerd \
docker-compose \
luci-app-docker \
luci-app-dockerman \
containerd \
runc

do

    sed -i "/CONFIG_PACKAGE_${pkg}=/d" "$CONFIG_FILE"

    echo "# CONFIG_PACKAGE_${pkg} is not set" >> "$CONFIG_FILE"

done





#
# 禁止 mihomo 冲突
#

echo "===== Disable mihomo conflict ====="



sed -i '/CONFIG_PACKAGE_mihomo-alpha=/d' "$CONFIG_FILE"

sed -i '/CONFIG_PACKAGE_mihomo-meta=/d' "$CONFIG_FILE"



echo "# CONFIG_PACKAGE_mihomo-alpha is not set" >> "$CONFIG_FILE"

echo "# CONFIG_PACKAGE_mihomo-meta is not set" >> "$CONFIG_FILE"







#
# Argon主题
#

echo "===== Enable Argon ====="



if grep -q "^CONFIG_PACKAGE_luci-theme-argon=" "$CONFIG_FILE"
then

    sed -i \
    's/^CONFIG_PACKAGE_luci-theme-argon=.*/CONFIG_PACKAGE_luci-theme-argon=y/' \
    "$CONFIG_FILE"

else

    echo "CONFIG_PACKAGE_luci-theme-argon=y" >> "$CONFIG_FILE"

fi







#
# 删除多余主题
#

echo "===== Remove extra themes ====="



for theme in \
luci-theme-material \
luci-theme-openwrt-2020

do

    sed -i "/CONFIG_PACKAGE_${theme}=/d" "$CONFIG_FILE"

    echo "# CONFIG_PACKAGE_${theme} is not set" >> "$CONFIG_FILE"

done






#
# 修改默认IP
#

echo "===== Set LAN IP ====="



CONFIG_GENERATE="package/base-files/files/bin/config_generate"


if [ -f "$CONFIG_GENERATE" ]
then

    sed -i \
    's/192\.168\.1\.1/10.0.0.1/g' \
    "$CONFIG_GENERATE"

fi







#
# 保留 ImmortalWrt 名称
#

echo "===== Keep ImmortalWrt ====="



if [ -f "$CONFIG_GENERATE" ]
then

    sed -i \
    's/OpenWrt/ImmortalWrt/g' \
    "$CONFIG_GENERATE"

fi








#
# banner
#

echo "===== Install banner ====="



if [ -f "$GITHUB_WORKSPACE/banner" ]
then

    mkdir -p package/base-files/files/etc


    cp -f \
    "$GITHUB_WORKSPACE/banner" \
    package/base-files/files/etc/banner

fi







#
# Argon资源
#

echo "===== Install Argon resources ====="



ARGON_DIR="feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon"




if [ -d "feeds/luci/themes/luci-theme-argon" ]
then



    mkdir -p "$ARGON_DIR"



    #
    # 壁纸
    #

    if [ -f "$GITHUB_WORKSPACE/argon/background/background.jpg" ]
    then


        mkdir -p "$ARGON_DIR/background"


        cp -f \
        "$GITHUB_WORKSPACE/argon/background/background.jpg" \
        "$ARGON_DIR/background/background.jpg"



        cp -f \
        "$GITHUB_WORKSPACE/argon/background/background.jpg" \
        "$ARGON_DIR/background.jpg"


    fi





    #
    # 图标
    #

    if [ -d "$GITHUB_WORKSPACE/argon/icon" ]
    then


        mkdir -p "$ARGON_DIR/icon"


        cp -rf \
        "$GITHUB_WORKSPACE/argon/icon/"* \
        "$ARGON_DIR/icon/"


    fi


fi







#
# 默认设置
#

echo "===== Install default settings ====="



if [ -f "$GITHUB_WORKSPACE/99-default-settings" ]
then


    mkdir -p \
    package/base-files/files/etc/uci-defaults



    cp -f \
    "$GITHUB_WORKSPACE/99-default-settings" \
    package/base-files/files/etc/uci-defaults/99-default-settings


fi







#
# 清理缓存
#

echo "===== Clean LuCI cache ====="



rm -rf /tmp/luci-modulecache || true

rm -f /tmp/luci-indexcache || true






#
# 最终检查
#

echo "===== FINAL CONFIG CHECK ====="



echo "---- Docker ----"

grep -E '^CONFIG_PACKAGE_(docker|dockerd|docker-compose|luci-app-docker|luci-app-dockerman|containerd|runc)=' "$CONFIG_FILE" || echo "Docker disabled"



echo "---- Mihomo ----"

grep -E '^CONFIG_PACKAGE_(mihomo|mihomo-alpha|mihomo-meta)=' "$CONFIG_FILE" || echo "Mihomo disabled"



echo "===== DIY part2 finish ====="