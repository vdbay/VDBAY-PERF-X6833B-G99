su -lp 2000 -c "cmd notification post -S bigtext -t 'VDBay Performance' -i file:///data/local/tmp/vdbay_logo.png -I file:///data/local/tmp/vdbay_logo.png 'Tag$(date +%s)' 'Starting...'" >/dev/null 2>&1 &

#===== PERFORMANCE =====#
# CREDIT: SAKURABLAZE AIO ICELAVA #GORE (1733)
# Variables
ZRAMSIZE=8G
SWAPSIZE=0

# Zram functions
disable_zram() {
    swapoff /dev/block/zram0
    echo "0" >/sys/class/zram-control/hot_remove
}

change_zram() {
    sleep 5
    swapoff /dev/block/zram0
    echo "1" >/sys/block/zram0/reset
    echo "$ZRAMSIZE" >/sys/block/zram0/disksize
    mkswap /dev/block/zram0
    swapon /dev/block/zram0
}

# disable overlay HW
doverlay() {
    service call SurfaceFlinger 1008 i32 1
}

# Advanced FPSGO Settings
fpsgo() {
    echo "31" >/sys/module/mtk_fpsgo/parameters/bhr_opp
    echo "0" >/sys/module/mtk_fpsgo/parameters/bhr_opp_l
    echo "1" >/sys/module/mtk_fpsgo/parameters/uboost_enhance_f
    echo "90" >/sys/module/mtk_fpsgo/parameters/rescue_enhance_f
    echo "1" >/sys/module/mtk_fpsgo/parameters/qr_mod_frame
    echo "1" >/sys/module/mtk_fpsgo/parameters/fstb_separate_runtime_enable
    echo "1" >/sys/module/mtk_fpsgo/parameters/fstb_consider_deq
    echo "5" >/sys/pnpmgr/fpsgo_boost/fstb/fstb_tune_quantile
    echo "1" >/sys/pnpmgr/fpsgo_boost/fstb/fstb_tune_error_threshold
    echo "10" >/sys/pnpmgr/fpsgo_boost/fbt/bhr_opp
    echo "0" >/sys/pnpmgr/fpsgo_boost/fbt/floor_opp
    echo "90" >/sys/pnpmgr/fpsgo_boost/fbt/rescue_enhance_f
    echo "100" >/sys/module/mtk_fpsgo/parameters/run_time_percent
    echo "1" >/sys/module/mtk_fpsgo/parameters/loading_ignore_enable
    echo "120" >/sys/module/mtk_fpsgo/parameters/kmin
    echo "60" >/sys/pnpmgr/fpsgo_boost/fbt/rescue_opp_c
    echo "80" >/sys/pnpmgr/fpsgo_boost/fbt/rescue_opp_f
    echo "90" >/sys/pnpmgr/fpsgo_boost/fbt/rescue_percent
    echo "1" >/sys/pnpmgr/fpsgo_boost/fbt/ultra_rescue
    echo 0 >/sys/module/ged/parameters/gpu_cust_upbound_freq
    echo 100 >/sys/module/ged/parameters/gpu_cust_boost_freq
}

fpsgo2() {
    # Set FPSGO fstb parameters
    echo 1 >/sys/kernel/fpsgo/fstb/boost_ta
    echo 0 >/sys/kernel/fpsgo/fstb/enable_switch_sync_flag

    # Set GPU boost level
    echo -1 >/sys/kernel/ged/hal/gpu_boost_level

    # Set GED parameters
    echo 1 >/sys/module/ged/parameters/ged_smart_boost
    echo 1 >/sys/module/ged/parameters/enable_gpu_boost
    echo 1 >/sys/module/ged/parameters/ged_boost_enable
    echo 1 >/sys/module/ged/parameters/boost_gpu_enable
    echo 1 >/sys/module/ged/parameters/gpu_dvfs_enable
    echo 1 >/sys/module/ged/parameters/gpu_idle
    echo 0 >/sys/module/ged/parameters/is_GED_KPI_enabled

    # Set additional GPU boost parameters
    echo 1 >/sys/module/ged/parameters/gx_frc_mode
    echo 1 >/sys/module/ged/parameters/gx_boost_on
    echo 1 >/sys/module/ged/parameters/gx_game_mode
    echo 1 >/sys/module/ged/parameters/gx_3D_benchmark_on
    echo 1 >/sys/module/ged/parameters/cpu_boost_policy
    echo 1 >/sys/module/ged/parameters/boost_extra

    # Set PNPMGR parameters
    echo 1 >/sys/pnpmgr/fpsgo_boost/boost_mode
    echo 1 >/sys/pnpmgr/install
    echo 1 >/sys/pnpmgr/mwn

    # Set MTK FPSGo parameters
    echo 1 >/sys/module/mtk_fpsgo/parameters/boost_affinity
    echo 1 >/sys/module/mtk_fpsgo/parameters/boost_LR
    echo 1 >/sys/module/mtk_fpsgo/parameters/xgf_uboost
}

# Enable all tweak

su -lp 2000 -c "cmd notification post -S bigtext -t 'Sakura AI' tag 'Waiting to Apply'" >/dev/null 2>&1

# Change zram
change_zram

#doverlay

fpsgo

fpsgo2

sleep 5

# Set kernel scheduler parameters for specific apps/libraries
echo "com.miHoYo.,com.HoYoverse.,UnityMain,libunity.so" >/proc/sys/kernel/sched_lib_name
echo 255 >/proc/sys/kernel/sched_lib_mask_force

# Set the I/O scheduler to "deadline" for all block devices
for device in /sys/block/*; do
    queue="$device/queue"
    if [ -f "$queue/scheduler" ]; then
        echo "deadline" >"$queue/scheduler"
    fi
done

# Disable fsync
echo N >/sys/module/sync/parameters/fsync_enabled

# Kernel performance configuration
echo "0 0 0 0" >/proc/sys/kernel/printk
echo "off" >/proc/sys/kernel/printk_devkmsg
echo "Y" >/sys/module/printk/parameters/console_suspend
echo "N" >/sys/module/printk/parameters/cpu
echo "0" >/sys/kernel/printk_mode/printk_mode
echo "Y" >/sys/module/printk/parameters/ignore_loglevel

# DisableHotPlug
for cpu in /sys/devices/system/cpu/cpu[1-7] /sys/devices/system/cpu/cpu1[0-7]; do
    echo "0" >$cpu/core_ctl/enable
    echo "0" >$cpu/core_ctl/core_ctl_boost
done

# DevStune
for path in /dev/stune/*; do
    base=$(basename "$path")
    if [[ "$base" == "top-app" || "$base" == "foreground" ]]; then
        echo 1 >"$path/schedtune.boost"
        echo 1 >"$path/schedtune.sched_boost_enabled"
    else
        echo 1 >"$path/schedtune.boost"
        echo 1 >"$path/schedtune.sched_boost_enabled"
    fi
    echo 1 >"$path/schedtune.prefer_idle"
    echo 1 >"$path/schedtune.colocate"
done

# Kernel Optimized
echo 32 >/proc/sys/kernel/sched_nr_migrate
echo 50000 >/proc/sys/kernel/sched_migration_cost_ns
echo 1000000 >/proc/sys/kernel/sched_min_granularity_ns

# Virtual Memory Optimized
echo 250 >/proc/sys/vm/watermark_scale_factor
echo 250 >/proc/sys/vm/watermark_boost_factor
echo 120 >/proc/sys/vm/stat_interval

# Networking tweaks for low latency
echo "cubic" >/proc/sys/net/ipv4/tcp_congestion_control
echo 1 >/proc/sys/net/ipv4/tcp_low_latency
echo 1 >/proc/sys/net/ipv4/tcp_ecn
echo 1 >/proc/sys/net/ipv4/tcp_sack
echo 3 >/proc/sys/net/ipv4/tcp_fastopen
echo 0 >/proc/sys/net/ipv4/tcp_timestamps

for zone in /sys/class/thermal/thermal_zone*; do
    if [ -f "$zone/trip_point_0_temp" ]; then
        echo 999999999 >"$zone/trip_point_0_temp"
        echo "Set $zone/trip_point_0_temp to 999999999"
    fi
done

# Better Battery Efficient
chmod 0644 /sys/module/workqueue/parameters/power_efficient
echo "N" >/sys/module/workqueue/parameters/power_efficient
chmod 0644 /sys/module/workqueue/parameters/disable_numa
echo "N" >/sys/module/workqueue/parameters/disable_numa

echo 1 >/proc/ppm/enabled
echo 0 0 >/proc/ppm/policy_status
echo 1 0 >/proc/ppm/policy_status
echo 2 0 >/proc/ppm/policy_status
echo 3 0 >/proc/ppm/policy_status
echo 4 0 >/proc/ppm/policy_status
echo 5 0 >/proc/ppm/policy_status
echo 6 0 >/proc/ppm/policy_status
echo 7 1 >/proc/ppm/policy_status
echo 8 0 >/proc/ppm/policy_status
echo 9 0 >/proc/ppm/policy_status

cmd power set-adaptive-power-saver-enabled false
cmd power set-fixed-performance-mode-enabled true

for cpu in /sys/devices/system/cpu/cpu[0-7]; do
    if [ -f "$cpu/online" ]; then
        echo 1 >"$cpu/online"
    fi
done

# Set CPU frequency governors to performance mode
for policy in /sys/devices/system/cpu/cpufreq/policy*; do
    chmod 644 "$policy/scaling_governor"
    echo "performance" >"$policy/scaling_governor"
done

# Set device frequency governors to performance mode
for device in /sys/class/devfreq/*; do
    if [ -f "$device/governor" ]; then
        chmod 644 "$device/governor"
        echo "performance" >"$device/governor"
    fi
done

if [ -d /proc/gpufreq ]; then
    gpu_freq="$(awk '/freq = [0-9]+/ {print $3}' /proc/gpufreq/gpufreq_opp_dump | sort -nr | head -n 1)"
    echo "$gpu_freq" /proc/gpufreq/gpufreq_opp_freq
elif [ -d /proc/gpufreqv2 ]; then
    echo 00 /proc/gpufreqv2/fix_target_opp_index
fi

# Set permissions and manage cluster frequencies
chmod 644 /sys/devices/system/cpu/*/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/*/cpufreq/scaling_min_freq
cluster=0
for path in /sys/devices/system/cpu/cpufreq/policy*; do
    max_freq=$(cat "$path/scaling_available_frequencies" | cut -d' ' -f1)
    min_freq=$(cat "$path/scaling_available_frequencies" | awk '{print $NF}')
    echo "$cluster $max_freq" >/proc/ppm/policy/hard_userlimit_min_cpu_freq
    echo "$cluster $max_freq" >/proc/ppm/policy/hard_userlimit_max_cpu_freq
    cluster=$(($cluster + 1))
done
# Set individual CPU frequencies
for cpu in /sys/devices/system/cpu/cpu[0-7]; do
    [ ! -d "$cpu/cpufreq" ] && continue
    freqs=$(cat "$cpu/cpufreq/scaling_available_frequencies" 2>/dev/null) || continue
    max_freq=$(echo "$freqs" | cut -d' ' -f1)
    min_freq=$(echo "$freqs" | awk '{print $NF}')

    if echo "$max_freq" >"$cpu/cpufreq/scaling_max_freq"; then
        echo "CPU $cpu: max freq set to $max_freq"
    else
        echo "CPU $cpu: failed to set max freq"
    fi

    if echo "$max_freq" >"$cpu/cpufreq/scaling_min_freq"; then
        echo "CPU $cpu: min freq set to $max_freq"
    else
        echo "CPU $cpu: failed to set min freq"
    fi
done
chmod 444 /sys/devices/system/cpu/*/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/*/cpufreq/scaling_min_freq

# Additional GPU settings
echo "coarse_demand" >/sys/class/misc/mali0/device/power_policy

if [ -f "/proc/gpufreq/gpufreq_power_limited" ]; then
    apply "ignore_batt_oc 1" /proc/gpufreq/gpufreq_power_limited
    apply "ignore_batt_percent 1" /proc/gpufreq/gpufreq_power_limited
    apply "ignore_low_batt 1" /proc/gpufreq/gpufreq_power_limited
    apply "ignore_thermal_protect 1" /proc/gpufreq/gpufreq_power_limited
    apply "ignore_pbm_limited 1" /proc/gpufreq/gpufreq_power_limited
fi

# Disable Energy Aware Scheduling (EAS) and set various CPU freq settings
echo 0 >/sys/devices/system/cpu/eas/enable
echo 3 >/proc/cpufreq/cpufreq_power_mode
echo 1 >/proc/cpufreq/cpufreq_cci_mode
echo 1 >/proc/cpufreq/cpufreq_sched_disable
echo 0 >/sys/kernel/eara_thermal/enable
echo stop 1 >/proc/pbm/pbm_stop

# CPUSET configuration
for cs in /dev/cpuset; do
    echo 0-7 >"$cs/cpus"
    echo 0-5 >"$cs/background/cpus"
    echo 0-4 >"$cs/system-background/cpus"
    echo 0-7 >"$cs/foreground/cpus"
    echo 0-7 >"$cs/top-app/cpus"
    echo 0-5 >"$cs/restricted/cpus"
    echo 0-7 >"$cs/camera-daemon/cpus"
done

# Disallow power saving mode for display
for dlp in /proc/displowpower; do
    echo 1 >"$dlp/hrt_lp"
    echo 1 >"$dlp/idlevfp"
    echo 100 >"$dlp/idletime"
done

# Scheduler settings
echo 3 >/proc/sys/kernel/perf_cpu_time_max_percent
echo 1 >/proc/sys/kernel/sched_child_runs_first
echo 0 >/proc/sys/kernel/sched_energy_aware
echo 0 >/proc/sys/kernel/sched_schedstats

# Block device settings
for device in /sys/block/*; do
    if [ -d "$device/queue" ]; then
        echo 64 >"$device/queue/nr_requests"
        echo 256 >"$device/queue/read_ahead_kb"
    fi
done

# Power level settings
for pl in /sys/devices/system/cpu/perf; do
    echo 1 >"$pl/gpu_pmu_enable"
    echo 1 >"$pl/fuel_gauge_enable"
    echo 1 >"$pl/enable"
    echo 1 >"$pl/charger_enable"
done

# Virtual memory settings
echo 80 >/proc/sys/vm/vfs_cache_pressure
echo 0 >/proc/sys/vm/compaction_proactiveness
echo 10 >/proc/sys/vm/swappiness

# DCM
echo set 0xf8007 2 >/sys/dcm/dcm_state

am kill-all
#===== PERFORMANCE =====#

su -lp 2000 -c "cmd notification post -S bigtext -t 'VDBay Performance' -i file:///data/local/tmp/vdbay_logo.png -I file:///data/local/tmp/vdbay_logo.png 'Tag$(date +%s)' 'Module applied successfully'" >/dev/null 2>&1 &
