# Opensoc<br>
包含了SOC设计中的通用IP，如外设、总线结构、基础、验证等<br>
本项目源自于第八届全国大学生集成电路创新创业大赛ARM杯一等奖作品，欢迎大家交流学习<br>
作者邮箱：2257691535@qq.com<br>
## 已发布的IP<br>
(1)__外设与控制器__<br>
APB-GPIO<br>
APB-UART<br>
APB-I2C<br>
通用FSMC控制器<br>
APB-音频播放器<br>
通用BRAM控制器<br>
AXI-SDRAM控制器<br>
(2)__总线结构__<br>
AHB/AXI-APB桥<br>
(3)__基础__<br>
AXIS寄存器片<br>
(4)__验证__<br>
AMBA总线基本验证组件<br>
## 待整理的IP<br>
(1)__外设__<br>
APB-SPI<br>
APB-TIMER<br>
通用SDIO控制器<br>
(2)__通用__<br>
AXIS-位宽变换<br>
AXIS-FIFO<br>
(3)__DMA__<br>
AXI-通用DMA引擎<br>
AXI-帧缓存(视频专用DMA)<br>
## 文件结构<br>
XXX_IP<br>
&emsp;&emsp;[constraint]<br>
&emsp;&emsp;doc<br>
&emsp;&emsp;[firmware]<br>
&emsp;&emsp;&emsp;&emsp;-examples<br>
&emsp;&emsp;rtl<br>
&emsp;&emsp;[其他]<br>
***每个IP都有对应的文档, 位于doc文件夹内***
## 修订<br>
|版本      | 日期      | 修订人 | 
|:-------- |:----------|:--------|
|alpha0.40  |2024.09.06 |陈家耀  |
