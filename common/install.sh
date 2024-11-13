set_perm_recursive $MODPATH 0 0 0755 0644
VCOMPAT=1422

ui_print " _    ______  ____  _____  __                                           "
ui_print "| |  / / __ \/ __ )/   \ \/ /                                           "
ui_print "| | / / / / / __  / /| |\  /                                            "
ui_print "| |/ / /_/ / /_/ / ___ |/ /                                             "
ui_print "|___/_____/_____/_/  |_/_/                                              "
ui_print "    _____   _____________   _______  __                                 "
ui_print "   /  _/ | / / ____/  _/ | / /  _/ |/ /                                 "
ui_print "   / //  |/ / /_   / //  |/ // / |   /                                  "
ui_print " _/ // /|  / __/ _/ // /|  // / /   |                                   "
ui_print "/___/_/ |_/_/   /___/_/ |_/___//_/|_|                                   "
ui_print "    _   ______  ____________                                            "
ui_print "   / | / / __ \/_  __/ ____/                                            "
ui_print "  /  |/ / / / / / / / __/                                               "
ui_print " / /|  / /_/ / / / / /___                                               "
ui_print "/_/ |_/\____/ /_/ /_____/                                               "
ui_print "   _____ ____                                                           "
ui_print "  |__  // __ \                                                          "
ui_print "   /_ </ / / /                                                          "
ui_print " ___/ / /_/ /                                                           "
ui_print "/____/\____/                                                            "
ui_print "    ___    ________                                                     "
ui_print "   /   |  /  _/ __ \                                                    "
ui_print "  / /| |  / // / / /                                                    "
ui_print " / ___ |_/ // /_/ /                                                     "
ui_print "/_/  |_/___/\____/                                                      "
ui_print "    ____  __________  __________  ____  __  ______    _   ______________"
ui_print "   / __ \/ ____/ __ \/ ____/ __ \/ __ \/  |/  /   |  / | / / ____/ ____/"
ui_print "  / /_/ / __/ / /_/ / /_  / / / / /_/ / /|_/ / /| | /  |/ / /   / __/   "
ui_print " / ____/ /___/ _, _/ __/ / /_/ / _, _/ /  / / ___ |/ /|  / /___/ /___   "
ui_print "/_/   /_____/_/ |_/_/    \____/_/ |_/_/  /_/_/  |_/_/ |_/\____/_____/   "
ui_print "                                                                        "

# Check module compatibility
VIS_COMPATIBLE=$(wc -c <"$MODPATH/system.prop")
ui_print "Checking module compatibility..."
if [ "$VIS_COMPATIBLE" = "$VCOMPAT"]; then
    abort "Module not compatible, can't install. Please ask your maintainer."
else
    ui_print "Module compatible! Continuing..."
fi

ui_print "Thanks to:"
ui_print "- Tester"
ui_print "- Follower/Subscriber"
ui_print "- Topjohnwu"
ui_print "- MiAzami"
ui_print "- Zackptg5"
ui_print "- Kutu Moba"
ui_print "- Feravolt"

cp "$MODPATH/vdbay_logo.png" /data/local/tmp/vdbay_logo.png >/dev/null 2>&1

#===== DISABLE THERMAL =====#
# CREDIT: X-THERMAL V7.5
find /system/vendor/ -name "*thermal*" -type f -print0 | while IFS= read -r -d '' nama; do
    if [[ "$nama" == *.conf ]]; then
        if [[ "$nama" != *camera* && "$nama" != *youtube* ]]; then
            mkdir -p "$MODPATH/$nama"
            rmdir "$MODPATH/$nama"
            touch "$MODPATH/$nama"
        fi
    fi
done >/dev/null 2>&1

if [ -f /system/bin/thermald ]; then
    mkdir -p $MODPATH/system/bin/thermald
    rmdir $MODPATH/system/bin/thermald
    touch $MODPATH/system/bin/thermald
fi >/dev/null 2>&1
if [ -f /system/vendor/bin/mi_thermald ]; then
    mkdir -p $MODPATH/system/vendor/bin/mi_thermald
    rmdir $MODPATH/system/vendor/bin/mi_thermald
    touch $MODPATH/system/vendor/bin/mi_thermald
fi >/dev/null 2>&1
if [ -f /system/vendor/bin/thermal_factory ]; then
    mkdir -p $MODPATH/system/vendor/bin/thermal_factory
    rmdir $MODPATH/system/vendor/bin/thermal_factory
    touch $MODPATH/system/vendor/bin/thermal_factory
fi >/dev/null 2>&1
if [ -f /system/vendor/bin/thermal-engine ]; then
    mkdir -p $MODPATH/system/vendor/bin/thermal-engine
    rmdir $MODPATH/system/vendor/bin/thermal-engine
    touch $MODPATH/system/vendor/bin/thermal-engine
fi >/dev/null 2>&1
if [ -f /system/vendor/bin/thermal-engine-v2 ]; then
    mkdir -p $MODPATH/system/vendor/bin/thermal-engine-v2
    rmdir $MODPATH/system/vendor/bin/thermal-engine-v2
    touch $MODPATH/system/vendor/bin/thermal-engine-v2
fi >/dev/null 2>&1
if [ -f /system/vendor/bin/thermal_core ]; then
    mkdir -p $MODPATH/system/vendor/bin/thermal_core
    rmdir $MODPATH/system/vendor/bin/thermal_core
    touch $MODPATH/system/vendor/bin/thermal_core
fi >/dev/null 2>&1
if [ -f /system/vendor/bin/thermal_intf ]; then
    mkdir -p $MODPATH/system/vendor/bin/thermal_intf
    rmdir $MODPATH/system/vendor/bin/thermal_intf
    touch $MODPATH/system/vendor/bin/thermal_intf
fi >/dev/null 2>&1
if [ -f /system/lib64/libthermalservice.so ]; then
    mkdir -p $MODPATH/system/lib64/libthermalservice.so
    rmdir $MODPATH/system/lib64/libthermalservice.so
    touch $MODPATH/system/lib64/libthermalservice.so
fi >/dev/null 2>&1
if [ -f /system/etc/init/init.thermald.rc ]; then
    mkdir -p $MODPATH/system/etc/init/init.thermald.rc
    rmdir $MODPATH/system/etc/init/init.thermald.rc
    touch $MODPATH/system/etc/init/init.thermald.rc
fi >/dev/null 2>&1
if [ -f /system/vendor/etc/init/android.hardware.thermal@2.0-service.mtk.rc ]; then
    mkdir -p $MODPATH/system/vendor/etc/init/android.hardware.thermal@2.0-service.mtk.rc
    rmdir $MODPATH/system/vendor/etc/init/android.hardware.thermal@2.0-service.mtk.rc
    touch $MODPATH/system/vendor/etc/init/android.hardware.thermal@2.0-service.mtk.rc
fi >/dev/null 2>&1
if [ -f /system/vendor/etc/init/init.thermal_core.rc ]; then
    mkdir -p $MODPATH/system/vendor/etc/init/init.thermal_core.rc
    rmdir $MODPATH/system/vendor/etc/init/init.thermal_core.rc
    touch $MODPATH/system/vendor/etc/init/init.thermal_core.rc
fi >/dev/null 2>&1
for i in $(pgrep -fl thermal | awk '{print $2}'); do
    mkdir -p "$MODPATH/$i"
    rmdir "$MODPATH/$i"
    touch "$MODPATH/$i"
done >/dev/null 2>&1
#===== END OF DISABLE THERMAL =====#

su -lp 2000 -c "cmd notification post -S bigtext -t 'VDBay Performance' -i file:///data/local/tmp/vdbay_logo.png -I file:///data/local/tmp/vdbay_logo.png 'Tag$(date +%s)' 'Install Completed'" >/dev/null 2>&1 &
am start -a android.intent.action.VIEW -d https://t.me/vdbaymodule >/dev/null 2>&1 &
