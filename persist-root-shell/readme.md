
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

## PLTs error, not working now
```
 5188.608302] ------------[ cut here ]------------
[ 5188.608360] WARNING: CPU: 1 PID: 10602 at kernel/module.c:1105 module_put+0x78/0x13c()
[ 5188.608373] Modules linked in: getshell(O) ...
[ 5188.609581] CPU: 1 PID: 10602 Comm: insmod Tainted: P W O 4.4.197 #1
[ 5188.609597] Hardware name: Hisilicon A9
[ 5188.609649] [<c0012d3c>] (rtos_unwind_backtrace) from [<c000e518>] (show_stack+0x10/0x14)
[ 5188.609686] [<c000e518>] (show_stack) from [<c023cd20>] (dump_stack+0x88/0xa8)
``` 

