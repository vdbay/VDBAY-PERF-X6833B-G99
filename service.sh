#===== WAIT UNTIL BOOT IS COMPLETED =====#
while [ -z "$(getprop sys.boot_completed)" ]; do
    sleep 30
done

#===== CHANGE PERMISSION, INSERT VALUE, AND LOCK VALUE =====#
# $1 VALUE, $2 FILEPATH(S)
v_set_value() {
    for file_path in $2; do
        if [ -f "$file_path" ]; then
            chown root:root "$file_path"
            chmod 644 "$file_path"
            echo "$1" >"$file_path"
            chmod 444 "$file_path"
        fi
    done
}

#===== DISABLE THERMAL =====#
# CREDIT: X-THERMAL V7.5 with slight modification
for thermal_zone in /sys/class/thermal/thermal_zone*/mode; do
    v_set_value "disabled" "$thermal_zone"
done

v_set_value "0" "/proc/sys/kernel/sched_boost"
v_set_value "N" "/sys/module/msm_thermal/parameters/enabled"
v_set_value "0" "/sys/module/msm_thermal/core_control/enabled"
v_set_value "0" "/sys/kernel/msm_thermal/enabled"

for block_queue in /sys/block/sd*/queue; do
    v_set_value "0" "$block_queue/iostats"
    v_set_value "64" "$block_queue/nr_requests"
done

disable_thermal_services() {
    for thermal_service in $(getprop | awk -F '[][]' '/thermal/ {print $2}'); do
        service_status=$(getprop "$thermal_service")
        if [ "$service_status" = "running" ] || [ "$service_status" = "restarting" ]; then
            setprop "$thermal_service" "stopped"
        fi
    done
}

disable_thermal_services
sleep 2

# Stop thermal-related services
for thermal_service_name in $(getprop | grep thermal | cut -f1 -d']' | cut -f2 -d'[' | grep -F 'init.svc.'); do
    stop "$thermal_service_name"
done

# Set thermal-related properties to stopped
for thermal_service_name in $(getprop | grep thermal | cut -f1 -d']' | cut -f2 -d'[' | grep -F 'init.svc.'); do
    setprop "$thermal_service_name" "stopped"
done

# Clear properties for services with 'init.svc_' in their name
for thermal_service_empty in $(getprop | grep thermal | cut -f1 -d']' | cut -f2 -d'[' | grep -F 'init.svc_'); do
    setprop "$thermal_service_empty" ""
done

# Reset 'ro.*thermal' properties to 0
for thermal_property in $(getprop | grep 'ro.*thermal' | cut -d'[' -f2 | cut -d']' -f1); do
    resetprop -n "$thermal_property" 0
done

# Reset 'ro.*thermal' properties to 0 (alternative method)
for thermal_property_alternative in $(getprop | grep 'ro.*thermal' | awk -F '[][]' '{print $2}'); do
    resetprop -n "$thermal_property_alternative" 0
done

find /sys/devices/virtual/thermal -type f -exec chmod 000 {} +

v_set_value "0" "/sys/class/kgsl/kgsl-3d0/throttling"
v_set_value "1" "/sys/class/kgsl/kgsl-3d0/force_clk_on"
v_set_value "1" "/sys/class/kgsl/kgsl-3d0/force_bus_on"
v_set_value "1" "/sys/class/kgsl/kgsl-3d0/force_rail_on"
v_set_value "1" "/sys/class/kgsl/kgsl-3d0/force_no_nap"
#===== END OF DISABLE THERMAL =====#

#===== PERFORMANCE =====#
# CREDIT: SAKURABLAZE AIO ICELAVA #GORE (1733)
swapoff /dev/block/zram0
v_set_value "1" "/sys/block/zram0/reset"
v_set_value "8G" "/sys/block/zram0/disksize"
mkswap /dev/block/zram0
swapon /dev/block/zram0

v_set_value "31" "/sys/module/mtk_fpsgo/parameters/bhr_opp"
v_set_value "0" "/sys/module/mtk_fpsgo/parameters/bhr_opp_l"
v_set_value "1" "/sys/module/mtk_fpsgo/parameters/uboost_enhance_f"
v_set_value "90" "/sys/module/mtk_fpsgo/parameters/rescue_enhance_f"
v_set_value "1" "/sys/module/mtk_fpsgo/parameters/qr_mod_frame"
v_set_value "1" "/sys/module/mtk_fpsgo/parameters/fstb_separate_runtime_enable"
v_set_value "1" "/sys/module/mtk_fpsgo/parameters/fstb_consider_deq"
v_set_value "5" "/sys/pnpmgr/fpsgo_boost/fstb/fstb_tune_quantile"
v_set_value "1" "/sys/pnpmgr/fpsgo_boost/fstb/fstb_tune_error_threshold"
v_set_value "10" "/sys/pnpmgr/fpsgo_boost/fbt/bhr_opp"
v_set_value "0" "/sys/pnpmgr/fpsgo_boost/fbt/floor_opp"
v_set_value "90" "/sys/pnpmgr/fpsgo_boost/fbt/rescue_enhance_f"
v_set_value "100" "/sys/module/mtk_fpsgo/parameters/run_time_percent"
v_set_value "1" "/sys/module/mtk_fpsgo/parameters/loading_ignore_enable"
v_set_value "120" "/sys/module/mtk_fpsgo/parameters/kmin"
v_set_value "60" "/sys/pnpmgr/fpsgo_boost/fbt/rescue_opp_c"
v_set_value "80" "/sys/pnpmgr/fpsgo_boost/fbt/rescue_opp_f"
v_set_value "90" "/sys/pnpmgr/fpsgo_boost/fbt/rescue_percent"
v_set_value "1" "/sys/pnpmgr/fpsgo_boost/fbt/ultra_rescue"
v_set_value "0" "/sys/module/ged/parameters/gpu_cust_upbound_freq"
v_set_value "100" "/sys/module/ged/parameters/gpu_cust_boost_freq"
v_set_value "1" "/sys/kernel/fpsgo/fstb/boost_ta"
v_set_value "0" "/sys/kernel/fpsgo/fstb/enable_switch_sync_flag"
v_set_value "-1" "/sys/kernel/ged/hal/gpu_boost_level"
v_set_value "1" "/sys/module/ged/parameters/ged_smart_boost"
v_set_value "1" "/sys/module/ged/parameters/enable_gpu_boost"
v_set_value "1" "/sys/module/ged/parameters/ged_boost_enable"
v_set_value "1" "/sys/module/ged/parameters/boost_gpu_enable"
v_set_value "1" "/sys/module/ged/parameters/gpu_dvfs_enable"
v_set_value "1" "/sys/module/ged/parameters/gpu_idle"
v_set_value "0" "/sys/module/ged/parameters/is_GED_KPI_enabled"
v_set_value "1" "/sys/module/ged/parameters/gx_frc_mode"
v_set_value "1" "/sys/module/ged/parameters/gx_boost_on"
v_set_value "1" "/sys/module/ged/parameters/gx_game_mode"
v_set_value "1" "/sys/module/ged/parameters/gx_3D_benchmark_on"
v_set_value "1" "/sys/module/ged/parameters/cpu_boost_policy"
v_set_value "1" "/sys/module/ged/parameters/boost_extra"
v_set_value "1" "/sys/pnpmgr/fpsgo_boost/boost_mode"
v_set_value "1" "/sys/pnpmgr/install"
v_set_value "1" "/sys/pnpmgr/mwn"
v_set_value "1" "/sys/module/mtk_fpsgo/parameters/boost_affinity"
v_set_value "1" "/sys/module/mtk_fpsgo/parameters/boost_LR"
v_set_value "1" "/sys/module/mtk_fpsgo/parameters/xgf_uboost"

v_set_value "com.miHoYo.,com.HoYoverse.,UnityMain,libunity.so" "/proc/sys/kernel/sched_lib_name"
v_set_value "255" "/proc/sys/kernel/sched_lib_mask_force"

for device in /sys/block/*; do
    queue="$device/queue"
    if [ -f "$queue/scheduler" ]; then
        v_set_value "deadline" "$queue/scheduler"
    fi
done

v_set_value "N" "/sys/module/sync/parameters/fsync_enabled"

v_set_value "0 0 0 0" "/proc/sys/kernel/printk"
v_set_value "off" "/proc/sys/kernel/printk_devkmsg"
v_set_value "Y" "/sys/module/printk/parameters/console_suspend"
v_set_value "N" "/sys/module/printk/parameters/cpu"
v_set_value "0" "/sys/kernel/printk_mode/printk_mode"
v_set_value "Y" "/sys/module/printk/parameters/ignore_loglevel"

for cpu in /sys/devices/system/cpu/cpu[1-7] /sys/devices/system/cpu/cpu1[0-7]; do
    v_set_value "0" "$cpu/core_ctl/enable"
    v_set_value "0" "$cpu/core_ctl/core_ctl_boost"
done

for path in /dev/stune/*; do
    base=$(basename "$path")
    if [[ "$base" == "top-app" || "$base" == "foreground" ]]; then
        v_set_value "1" "$path/schedtune.boost"
        v_set_value "1" "$path/schedtune.sched_boost_enabled"
    else
        v_set_value "1" "$path/schedtune.boost"
        v_set_value "1" "$path/schedtune.sched_boost_enabled"
    fi
    v_set_value "1" "$path/schedtune.prefer_idle"
    v_set_value "1" "$path/schedtune.colocate"
done

v_set_value "32" "/proc/sys/kernel/sched_nr_migrate"
v_set_value "50000" "/proc/sys/kernel/sched_migration_cost_ns"
v_set_value "1000000" "/proc/sys/kernel/sched_min_granularity_ns"

v_set_value "250" "/proc/sys/vm/watermark_scale_factor"
v_set_value "250" "/proc/sys/vm/watermark_boost_factor"
v_set_value "120" "/proc/sys/vm/stat_interval"

v_set_value "cubic" "/proc/sys/net/ipv4/tcp_congestion_control"
v_set_value "1" "/proc/sys/net/ipv4/tcp_low_latency"
v_set_value "1" "/proc/sys/net/ipv4/tcp_ecn"
v_set_value "1" "/proc/sys/net/ipv4/tcp_sack"
v_set_value "3" "/proc/sys/net/ipv4/tcp_fastopen"
v_set_value "0" /proc/sys/net/ipv4/tcp_timestamps

for zone in /sys/class/thermal/thermal_zone*; do
    if [ -f "$zone/trip_point_0_temp" ]; then
        v_set_value "100" "$zone/trip_point_0_temp"
    fi
done

v_set_value "N" "/sys/module/workqueue/parameters/power_efficient"
v_set_value "N" "/sys/module/workqueue/parameters/disable_numa"

v_set_value "1" "/proc/ppm/enabled"
v_set_value "0 0" "/proc/ppm/policy_status"
v_set_value "1 0" "/proc/ppm/policy_status"
v_set_value "2 0" "/proc/ppm/policy_status"
v_set_value "3 0" "/proc/ppm/policy_status"
v_set_value "4 0" "/proc/ppm/policy_status"
v_set_value "5 0" "/proc/ppm/policy_status"
v_set_value "6 0" "/proc/ppm/policy_status"
v_set_value "7 1" "/proc/ppm/policy_status"
v_set_value "8 0" "/proc/ppm/policy_status"
v_set_value "9 0" "/proc/ppm/policy_status"

for cpu in /sys/devices/system/cpu/cpu[0-7]; do
    if [ -f "$cpu/online" ]; then
        v_set_value "1" "$cpu/online"
    fi
done

for policy in /sys/devices/system/cpu/cpufreq/policy*; do
    v_set_value "performance" "$policy/scaling_governor"
done

for device in /sys/class/devfreq/*; do
    if [ -f "$device/governor" ]; then
        v_set_value "performance" "$device/governor"
    fi
done

if [ -d /proc/gpufreq ]; then
    gpu_freq="$(awk '/freq = [0-9]+/ {print $3}' /proc/gpufreq/gpufreq_opp_dump | sort -nr | head -n 1)"
    v_set_value "$gpu_freq" "/proc/gpufreq/gpufreq_opp_freq"
elif [ -d /proc/gpufreqv2 ]; then
    v_set_value "0" "/proc/gpufreqv2/fix_target_opp_index"
fi

chmod 644 /sys/devices/system/cpu/*/cpufreq/scaling_max_freq
chmod 644 /sys/devices/system/cpu/*/cpufreq/scaling_min_freq
cluster=0
for path in /sys/devices/system/cpu/cpufreq/policy*; do
    max_freq=$(cat "$path/scaling_available_frequencies" | cut -d' ' -f1)
    min_freq=$(cat "$path/scaling_available_frequencies" | awk '{print $NF}')
    v_set_value "$max_freq" "/proc/ppm/policy/hard_userlimit_min_cpu_freq"
    v_set_value "$max_freq" "/proc/ppm/policy/hard_userlimit_max_cpu_freq"
    cluster=$(($cluster + 1))
done

for cpu in /sys/devices/system/cpu/cpu[0-7]; do
    [ ! -d "$cpu/cpufreq" ] && continue
    freqs=$(cat "$cpu/cpufreq/scaling_available_frequencies" 2>/dev/null) || continue
    max_freq=$(echo "$freqs" | cut -d' ' -f1)
    min_freq=$(echo "$freqs" | awk '{print $NF}')

    v_set_value "$max_freq" "$cpu/cpufreq/scaling_max_freq"
    v_set_value "$max_freq" "$cpu/cpufreq/scaling_min_freq"
done
chmod 444 /sys/devices/system/cpu/*/cpufreq/scaling_max_freq
chmod 444 /sys/devices/system/cpu/*/cpufreq/scaling_min_freq

v_set_value "coarse_demand" "/sys/class/misc/mali0/device/power_policy"

if [ -f "/proc/gpufreq/gpufreq_power_limited" ]; then
    v_set_value "ignore_batt_oc 1" /proc/gpufreq/gpufreq_power_limited
    v_set_value "ignore_batt_percent 1" /proc/gpufreq/gpufreq_power_limited
    v_set_value "ignore_low_batt 1" /proc/gpufreq/gpufreq_power_limited
    v_set_value "ignore_thermal_protect 1" /proc/gpufreq/gpufreq_power_limited
    v_set_value "ignore_pbm_limited 1" /proc/gpufreq/gpufreq_power_limited
fi

v_set_value "0" "/sys/devices/system/cpu/eas/enable"
v_set_value "3" "/proc/cpufreq/cpufreq_power_mode"
v_set_value "1" "/proc/cpufreq/cpufreq_cci_mode"
v_set_value "1" "/proc/cpufreq/cpufreq_sched_disable"
v_set_value "0" "/sys/kernel/eara_thermal/enable"
v_set_value "stop 1" "/proc/pbm/pbm_stop"

for cs in /dev/cpuset; do
    v_set_value "0-7" "$cs/cpus"
    v_set_value "0-5" "$cs/background/cpus"
    v_set_value "0-4" "$cs/system-background/cpus"
    v_set_value "0-7" "$cs/foreground/cpus"
    v_set_value "0-7" "$cs/top-app/cpus"
    v_set_value "0-5" "$cs/restricted/cpus"
    v_set_value "0-7" "$cs/camera-daemon/cpus"
done

for dlp in /proc/displowpower; do
    v_set_value "1" "$dlp/hrt_lp"
    v_set_value "1" "$dlp/idlevfp"
    v_set_value "100" "$dlp/idletime"
done

v_set_value "3" "/proc/sys/kernel/perf_cpu_time_max_percent"
v_set_value "1" "/proc/sys/kernel/sched_child_runs_first"
v_set_value "0" "/proc/sys/kernel/sched_energy_aware"
v_set_value "0" "/proc/sys/kernel/sched_schedstats"

for device in /sys/block/*; do
    if [ -d "$device/queue" ]; then
        v_set_value "64" "$device/queue/nr_requests"
        v_set_value "256" "$device/queue/read_ahead_kb"
    fi
done

for pl in /sys/devices/system/cpu/perf; do
    v_set_value "1" "$pl/gpu_pmu_enable"
    v_set_value "1" "$pl/fuel_gauge_enable"
    v_set_value "1" "$pl/enable"
    v_set_value "1" "$pl/charger_enable"
done

v_set_value "80" "/proc/sys/vm/vfs_cache_pressure"
v_set_value "0" "/proc/sys/vm/compaction_proactiveness"

MemTotal=$(cat /proc/meminfo | grep MemTotal)
MemTotal=${MemTotal:16:8}
if [ $MemTotal -gt 7038920 ]; then
    v_set_value "10" "/proc/sys/vm/swappiness"
fi

v_set_value "set 0xf8007 2" "/sys/dcm/dcm_state"

am kill-all

# CREDIT: ENCORE V1.8-7EB5853
v_set_value "0" "/sys/kernel/ccci/debug"

for thermal in /sys/class/thermal/thermal_zone*; do
    v_set_value "step_wise" ${thermal}/policy
done

v_set_value 0 /sys/kernel/tracing/tracing_on
v_set_value 0 /proc/sys/kernel/perf_event_paranoid
v_set_value 0 /proc/sys/kernel/debug_locks
v_set_value 0 /proc/sys/kernel/sched_autogroup_enabled
v_set_value 1500000 /proc/sys/kernel/sched_wakeup_granularity_ns

v_set_value 0 /proc/sys/vm/page-cluster

v_set_value 0 /sys/module/mmc_core/parameters/use_spi_crc

v_set_value 0 /sys/module/cpufreq_bouncing/parameters/enable
v_set_value 0 /proc/task_info/task_sched_info/task_sched_info_enable
v_set_value 0 /proc/oplus_scheduler/sched_assist/sched_assist_enabled

if grep -qo '[0-9]\+' /sys/module/battery_saver/parameters/enabled; then
    v_set_value 0 /sys/module/battery_saver/parameters/enabled
else
    v_set_value N /sys/module/battery_saver/parameters/enabled
fi

if [ -f "/sys/kernel/debug/sched_features" ]; then
    # Consider scheduling tasks that are eager to run
    v_set_value NEXT_BUDDY /sys/kernel/debug/sched_features

    # Some sources report large latency spikes during large migrations
    v_set_value NO_TTWU_QUEUE /sys/kernel/debug/sched_features
fi

# PPM throttle
if [ -f /proc/ppm/policy_status ]; then
    policy_file="/proc/ppm/policy_status"
    pwr_thro_idx=$(grep 'PPM_POLICY_PWR_THRO' $policy_file | sed 's/.*\[\(.*\)\].*/\1/')
    thermal_idx=$(grep 'PPM_POLICY_THERMAL' $policy_file | sed 's/.*\[\(.*\)\].*/\1/')

    echo "$pwr_thro_idx 0" >$policy_file
    echo "$thermal_idx 0" >$policy_file
fi

v_set_value "stop 1" /proc/mtk_batoc_throttling/battery_oc_protect_stop

v_set_value "0" /sys/devices/platform/10012000.dvfsrc/helio-dvfsrc/dvfsrc_req_ddr_opp
v_set_value "0" /sys/kernel/helio-dvfsrc/dvfsrc_force_vcore_dvfs_opp
v_set_value "performance" /sys/class/devfreq/mtk-dvfsrc-devfreq/governor
v_set_value "performance" /sys/devices/platform/soc/1c00f000.dvfsrc/mtk-dvfsrc-devfreq/devfreq/mtk-dvfsrc-devfreq/governor
#===== END OF PERFORMANCE =====#

su -lp 2000 -c "cmd notification post -S bigtext -t 'VDBay Performance' -i file:///data/local/tmp/vdbay_logo.png -I file:///data/local/tmp/vdbay_logo.png 'Tag$(date +%s)' 'Module applied successfully'" >/dev/null 2>&1 &
am start -a android.intent.action.VIEW -d https://t.me/vdbaymodule >/dev/null 2>&1 &
