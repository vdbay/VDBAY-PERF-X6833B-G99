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

su -lp 2000 -c "cmd notification post -S bigtext -t 'VDBay Performance' -i file:///data/local/tmp/vdbay_logo.png -I file:///data/local/tmp/vdbay_logo.png 'Tag$(date +%s)' 'Install Completed'" >/dev/null 2>&1 &
am start -a android.intent.action.VIEW -d https://t.me/vdbaymodule >/dev/null 2>&1 &
