
## download toolchain for linux-4.4
```
cd /mnt
wget -c https://releases.linaro.org/components/toolchain/binaries/latest-4/arm-eabi/gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi.tar.xz
xz -d gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi.tar.xz
tar -xvf gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi.tar
```
## download official kernel-4.4.197 source code and copy config to .config
```
wget -c https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.197.tar.gz 
tar -xzvf linux-4.4.197.tar.gz 
cd linux-4.4.197 
cp /mnt/config .config
```

## modify SECTIONS in arch/arm/kernel/module.lds 
```
     .plt : { BYTE(0) }
     .init.plt : { BYTE(0) }

```
```
## compile kernel
make ARCH=arm CROSS_COMPILE=/mnt/gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi/bin/arm-eabi- oldconfig
make ARCH=arm CROSS_COMPILE=/mnt/gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi/bin/arm-eabi-
```
## compile getshell.c
```
make ARCH=arm KERNEL=/mnt/linux-4.4.197 CROSS_COMPILE=/mnt/gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi/bin/arm-eabi-
```

## error, not working now
```
[  196.377553] ------------[ cut here ]------------
[  196.377602] WARNING: CPU: 1 PID: 3665 at kernel/module.c:1105 module_put+0x78/0x13c()
[  196.377615] Modules linked in: getshell bridge stp llc wifi_debug(O) hi1152_wifi(O) hi1152_plat(O) nf_nat_rtsp_alg(PO) nf_conntrack_rtsp_alg(PO) nf_nat_pptp(O) nf_nat_proto_gre nf_conntrack_pptp(O) nf_conntrack_proto_gre(O) nf_nat_h323(O) nf_conntrack_h323(O) xt_TCPMSS xt_nat acc(PO) ipt_MASQUERADE(O) nf_nat_masquerade_ipv4(O) datapath_v6ext(PO) datapath_v4ext(PO) datapath(PO) hw_module_drv_event(O) wifi_fwd(PO) xt_comment xt_recent skpool(PO) mac_filter(PO) hw_module_xt_capture(O) hw_module_xt_http(O) hw_module_template(O) hw_module_nf_ext_connmark(O) l2tp_ppp(O) l2tp_netlink l2tp_core(O) ip6_udp_tunnel udp_tunnel unicast_diag_adpt(PO) video_emdi_diag_adpt(PO) video_diag_adpt(PO) video_diag(PO) bbsp_l3_adpt(PO) wap_ipv6(PO) sit tunnel4 ip6_tunnel(O) tunnel6 ip6table_nat nf_nat_ipv6(O) ip6t_REJECT nf_reject_ipv6 ip6table_mangle ip6table_filter ip6_tables ip6t_rt nf_conntrack_ipv6(O) nf_defrag_ipv6(O) nf_log_ipv6(O) smartont_bbsp(PO) napt(PO) ffwd_adpt(PO) hw_module_conenat(O) l3ext(PO) ip_gre(O) gre ip_tunnel(O) hw_module_dsp(PO) hw_module_dsp_sdk(PO) hw_module_dopra(PO) l3base(PO) hw_module_trigger(PO) hw_wifi_diagnose_ct(PO) hw_module_acs(PO) hw_module_wifi_log(PO) hw_module_wifi_drv(PO) hw_module_wifi_bsd(PO) hw_module_wifi_sniffer(PO) hw_ssp_gpl_ext_add(O) hw_ssp_gpl_ext(O) xt_DSCP qos_adpt(O) l2ext(PO) xt_conntrack bbsp_l2_adpt(PO) hal_adpt_hisi(PO) cpu(PO) acl(PO) l2base(PO) hw_ptp(PO) btvfw(PO) l2ffwd(PO) sfwd(PO) commondata(PO) pppoe(O) pppox(O) ppp_generic(O) slhc hw_amp(PO) smp_usb(PO) hw_module_usb(PO) input_core(O) ftdi_sio(O) ch341(O) cp210x(O) pl2303(O) cdc_acm(O) usblp(O) usbserial(O) usb_storage(O) xhci_plat_hcd(O) xhci_hcd(O) ohci_hcd(O) ehci_pci(O) ehci_hcd(O) hiusb_sd511x(PO) usbcore(O) usb_common(O) sd_mod(O) scsi_mod(O) hw_ker_codec_pef31002(PO) hw_module_codec(PO) hw_module_spi(PO) hw_module_highway(PO) hi_hw(PO) hw_module_mpcp(PO) hw_module_emac(PO) hw_module_l2qos(PO) hw_module_amp(PO) hw_module_acp(O) pcie(O) configs overlay exportfs rtos_snapshot(O) hw_module_feature(PO) hw_dm_pdt(PO) hw_ker_optic_ux5176(PO) hw_ker_optic_chip_511x_epon(PO) hw_module_optic(PO) hw_module_dev(PO) hw_module_bus(PO) hw_module_common(PO) hi_oam(PO) hi_l3(PO) hi_pie(O) hi_epon(PO) hi_emac(PO) hi_ponlp(PO) hi_bridge(PO) hi_pcs(PO) hi_gemac(PO) hi_crg(PO) hi_uart(PO) hi_ponlink(PO) hi_timer(PO) hi_i2c(PO) hi_dma(PO) hi_gpio(PO) hi_mdio(PO) hi_spi(PO) hi_sysctl(O) hw_module_efuse(PO) loop ipv6 hw_ssp_basic(PO) ksecurec(PO) hw_ssp_gpl(O) xt_LOG(O) ipt_ah ipt_ECN ipt_REJECT nf_reject_ipv4 iptable_nat nf_nat_ipv4(O) iptable_raw arpt_mangle iptable_mangle iptable_filter ip_tables arptable_filter arp_tables xt_multiport xt_iprange xt_HL nfnetlink_queue nfnetlink_log nfnetlink nf_conntrack_ipv4(O) nf_defrag_ipv4(O) xt_REDIRECT nf_nat_redirect nf_nat(O) xt_tcpmss xt_state xt_limit xt_connmark xt_mark nf_conntrack(O) rng_core hi_drv_wdt(O) hw_drv_core(O) uart_suspend(O)
[  196.378513] CPU: 1 PID: 3665 Comm: insmod Tainted: P        W  O    4.4.197 #1
[  196.378527] Hardware name: Hisilicon A9
[  196.378575] [<c0012d3c>] (rtos_unwind_backtrace) from [<c000e518>] (show_stack+0x10/0x14)
[  196.378611] [<c000e518>] (show_stack) from [<c023cd20>] (dump_stack+0x88/0xa8)
[  196.378651] [<c023cd20>] (dump_stack) from [<c001fa6c>] (warn_slowpath_common+0x84/0xb0)
[  196.378678] [<c001fa6c>] (warn_slowpath_common) from [<c001fb80>] (warn_slowpath_null+0x18/0x20)
[  196.378703] [<c001fb80>] (warn_slowpath_null) from [<c0094140>] (module_put+0x78/0x13c)
[  196.378730] [<c0094140>] (module_put) from [<c00d5ae4>] (do_init_module+0xd0/0x1e4)
[  196.378752] [<c00d5ae4>] (do_init_module) from [<c0097648>] (load_module+0x1bc8/0x1c78)
[  196.378773] [<c0097648>] (load_module) from [<c00978f0>] (SyS_finit_module+0x70/0x94)
[  196.378794] [<c00978f0>] (SyS_finit_module) from [<c000abc0>] (ret_fast_syscall+0x0/0x40)
[  196.378811] ---[ end trace d531998291dcf678 ]---

``` 
## License
[MIT](https://opensource.org/licenses/MIT)
