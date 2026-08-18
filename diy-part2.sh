#!/bin/bash
#
# ImmortalWrt DIY Part2
# After Update feeds
#

set -e


echo "========== DIY PART2 START =========="


# ==============================
# 添加 OpenClash
# ==============================

echo "添加 OpenClash"

rm -rf package/luci-app-openclash

git clone --depth=1 \
https://github.com/vernesong/OpenClash.git \
package/luci-app-openclash



# ==============================
# 添加 TurboACC
# ==============================

echo "添加 TurboACC"


curl -sSL \
https://raw.githubusercontent.com/mufeng05/turboacc/main/add_turboacc.sh \
-o add_turboacc.sh


chmod +x add_turboacc.sh


# x86 不开启 SFE
bash add_turboacc.sh --no-sfe



# ==============================
# 写入配置
# ==============================

cat >> .config <<EOF


# Argon主题
CONFIG_PACKAGE_luci-theme-argon=y


# OpenClash
CONFIG_PACKAGE_luci-app-openclash=y


# TurboACC
CONFIG_PACKAGE_luci-app-turboacc=y


# TCP BBR
CONFIG_PACKAGE_kmod-tcp-bbr=y


# FullCone NAT
CONFIG_PACKAGE_nft-fullcone=y


# irqbalance
CONFIG_PACKAGE_irqbalance=y


# 常用工具
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_wget=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_nano=y


EOF



# ==============================
# 修改默认LAN地址
# ==============================

echo "修改 LAN IP"


sed -i \
's/192.168.1.1/10.0.0.1/g' \
package/base-files/files/bin/config_generate



# ==============================
# root空密码
# ==============================


echo "设置root空密码"


mkdir -p files/etc/uci-defaults


cat > files/etc/uci-defaults/99-default-settings <<'EOF'

#!/bin/sh

passwd -d root

exit 0

EOF


chmod +x files/etc/uci-defaults/99-default-settings



# ==============================
# 系统banner
# ==============================


if [ -f "$GITHUB_WORKSPACE/banner" ]; then

cp -f \
$GITHUB_WORKSPACE/banner \
package/base-files/files/etc/banner

fi



# ==============================
# Argon资源替换
# ==============================


ARGON_DIR="feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon"


if [ -d "$ARGON_DIR" ]; then


echo "替换 Argon资源"


cp -f \
$GITHUB_WORKSPACE/argon/img/bg1.jpg \
$ARGON_DIR/img/bg1.jpg || true


cp -f \
$GITHUB_WORKSPACE/argon/img/argon.svg \
$ARGON_DIR/img/argon.svg || true


cp -f \
$GITHUB_WORKSPACE/argon/favicon.ico \
$ARGON_DIR/favicon.ico || true


cp -f \
$GITHUB_WORKSPACE/argon/icon/*.png \
$ARGON_DIR/icon/ 2>/dev/null || true


fi



# ==============================
# 默认主题
# ==============================

mkdir -p files/etc/uci-defaults


cat > files/etc/uci-defaults/98-theme <<'EOF'

#!/bin/sh


uci set luci.main.mediaurlbase='/luci-static/argon'

uci commit luci


exit 0

EOF


chmod +x files/etc/uci-defaults/98-theme



echo "========== DIY PART2 END =========="
