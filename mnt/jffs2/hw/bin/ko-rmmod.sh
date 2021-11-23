# 
#rmmod /lib/modules/linux/kernel/net/netfilter/xt_DSCP.ko
#rmmod /lib/modules/wap/bbsp_l3_adpt.ko
#rmmod /lib/modules/wap/hw_wifi_diagnose_ct.ko
#rmmod /lib/modules/wap/unicast_diag_adpt.ko

# video
#rmmod /lib/modules/wap/video_diag_adpt.ko
#rmmod /lib/modules/wap/video_diag.ko
#rmmod /lib/modules/wap/video_emdi_diag_adpt.ko

#l2tp
rmmod /lib/modules/linux/kernel/net/l2tp/l2tp_ppp.ko
rmmod /lib/modules/linux/kernel/net/l2tp/l2tp_netlink.ko
rmmod /lib/modules/linux/kernel/net/l2tp/l2tp_core.ko
rmmod /lib/modules/linux/kernel/net/ipv6/ip6_udp_tunnel.ko
rmmod /lib/modules/linux/kernel/net/ipv4/udp_tunnel.ko

#qos
rmmod /lib/modules/wap/qos_adpt.ko
rmmod /lib/modules/wap/hw_module_template.ko
rmmod /lib/modules/wap/hw_module_xt_capture.ko
rmmod /lib/modules/wap/hw_module_xt_http.ko

#usb ko
rmmod /lib/modules/linux/extra/drivers/usb/class/usblp.ko
rmmod /lib/modules/linux/extra/drivers/usb/class/cdc-acm.ko
rmmod /lib/modules/linux/extra/drivers/usb/serial/pl2303.ko
rmmod /lib/modules/linux/extra/drivers/usb/serial/cp210x.ko
rmmod /lib/modules/linux/extra/drivers/usb/serial/ch341.ko
rmmod /lib/modules/linux/extra/drivers/usb/serial/ftdi_sio.ko
rmmod /lib/modules/linux/extra/drivers/input/input-core.ko	
rmmod /lib/modules/wap/hw_module_usb.ko
rmmod /lib/modules/wap/smp_usb.ko
rmmod /lib/modules/linux/extra/drivers/usb/serial/usbserial.ko
rmmod /lib/modules/linux/extra/drivers/usb/storage/usb-storage.ko
rmmod /lib/modules/linux/extra/drivers/usb/host/ohci-hcd.ko
rmmod /lib/modules/linux/extra/drivers/usb/host/ehci-pci.ko
rmmod /lib/modules/linux/extra/drivers/usb/host/ehci-hcd.ko
rmmod /lib/modules/linux/extra/drivers/scsi/sd_mod.ko
rmmod /lib/modules/linux/extra/drivers/scsi/scsi_mod.ko

