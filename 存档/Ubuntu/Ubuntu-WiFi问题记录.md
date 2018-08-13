### 问题：Ubuntu下无法检测到WiFi

+ 电脑：Lenovo
+ Subsystem: Lenovo RTL8723BE PCIe Wireless Network Adapter [17aa:b736]
+ Ubuntu 16.04LTS内核版本：4.13.0-26-generic

### 解决经历

1. 首先检测是否有阻塞

   命令：*rfkill list all*

   结果：无阻塞

   ```
   0: tpacpi_bluetooth_sw: Bluetooth
   	Soft blocked: no
   	Hard blocked: no
   3: hci0: Bluetooth
   	Soft blocked: no
   	Hard blocked: no
   4: phy0: Wireless LAN
   	Soft blocked: no
   	Hard blocked: no
   ```

   > 如果存在Soft blocked 阻塞 可使用 *rfkill unblock all* 解锁，如果存在 Hard blocked阻塞自行Google。

2. 查看网卡及内核相关信息

   命令：*lspci -vvnn |grep -A 9 Network*

   结果：

   ```
   04:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8723BE PCIe Wireless Network Adapter [10ec:b723]
   	Subsystem: Lenovo RTL8723BE PCIe Wireless Network Adapter [17aa:b736]
   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
   	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
   	Latency: 0, Cache Line Size: 32 bytes
   	Interrupt: pin A routed to IRQ 49
   	Region 0: I/O ports at 1000 [size=256]
   	Region 2: Memory at f0800000 (64-bit, non-prefetchable) [size=16K]
   	Capabilities: <access denied>
   	Kernel driver in use: rtl8723be
   	Kernel modules: rtl8723be
   ```

   重点：最后两行

3. 解决

   ```
   sudo apt-get install linux-headers-generic build-essential git  //没有有线网就算了
   git clone https://github.com/lwfinger/rtlwifi_new.git     
   cd rtlwifi_new
   sudo make install
   sudo modprobe -r rtl8723be    //<<YOUR WIRELESS DRIVER CODE>>
   sudo modprobe rtl8723be      //<<YOUR WIRELESS DRIVER CODE>>
   ```

   ​
