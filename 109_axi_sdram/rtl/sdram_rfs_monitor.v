`timescale 1ns / 1ps
/********************************************************************
本模块: sdram刷新监测器

描述:
检查是否在规定的时间间隔内刷新sdram

注意：
无

协议:
无

作者: 陈家耀
日期: 2024/04/17
********************************************************************/


module sdram_rfs_monitor #(
    parameter real clk_period = 7.0, // 时钟周期
    parameter real max_refresh_itv = 64.0 * 1000.0 * 1000.0 / 4096.0, // 最大刷新间隔(以ns计)
    parameter en_expt_tip = "false" // 是否使能异常指示
)(
    // 时钟和复位
    input wire clk,
    input wire rst_n,
    
    // 自动刷新定时开始(指示)
    output wire start_rfs_timing,
    
    // sdram命令线监测
    input wire sdram_cs_n,
    input wire sdram_ras_n,
    input wire sdram_cas_n,
    input wire sdram_we_n,
    
    // 异常指示
    output wire rfs_timeout // 刷新超时
);
    
    // 计算log2(bit_depth)
    function integer clogb2 (input integer bit_depth);
        integer temp;
    begin
        temp = bit_depth;
        for(clogb2 = -1;temp > 0;clogb2 = clogb2 + 1)
            temp = temp >> 1;
    end
    endfunction
    
    /** 常量 **/
    localparam integer max_refresh_itv_p = $floor(max_refresh_itv / clk_period); // 最大刷新间隔周期数
    // 命令的物理编码(CS_N, RAS_N, CAS_N, WE_N)
    localparam CMD_PHY_AUTO_REFRESH = 4'b0001; // 命令:自动刷新
    
    /** 自动刷新定时开始(指示) **/
    reg[2:0] init_rfs_cnt; // 初始化时刷新计数器
    reg start_rfs_timing_reg; // 自动刷新定时开始(指示)
    reg monitor_en; // 监测使能
    
    assign start_rfs_timing = start_rfs_timing_reg;
    
    // 初始化时刷新计数器
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            init_rfs_cnt <= 3'b001;
        else if(({sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n} == CMD_PHY_AUTO_REFRESH) & (~init_rfs_cnt[2]))
            init_rfs_cnt <= {init_rfs_cnt[1:0], init_rfs_cnt[2]};
    end
    // 自动刷新定时开始(指示)
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            start_rfs_timing_reg <= 1'b0;
        else
            start_rfs_timing_reg <= ({sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n} == CMD_PHY_AUTO_REFRESH) & init_rfs_cnt[1];
    end
    
    // 监测使能
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            monitor_en <= 1'b0;
        else if(~monitor_en)
            monitor_en <= start_rfs_timing;
    end
    
    /** 刷新超时监测 **/
    reg[clogb2(max_refresh_itv_p-1):0] rfs_timeout_cnt; // 刷新超时计数器
    reg rfs_timeout_cnt_suspend; // 刷新超时计数器挂起
    reg rfs_timeout_reg; // 刷新超时
    
    assign rfs_timeout = (en_expt_tip == "true") ? rfs_timeout_reg:1'b0;
    
    // 刷新超时计数器
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            rfs_timeout_cnt <= 0;
        else if({sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n} == CMD_PHY_AUTO_REFRESH)
            rfs_timeout_cnt <= 0;
        else if(monitor_en & (~rfs_timeout_cnt_suspend))
            rfs_timeout_cnt <= rfs_timeout_cnt + 1;
    end
    // 刷新超时计数器挂起
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            rfs_timeout_cnt_suspend <= 1'b0;
        else if({sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n} == CMD_PHY_AUTO_REFRESH)
            rfs_timeout_cnt_suspend <= 1'b0;
        else if(~rfs_timeout_cnt_suspend)
            rfs_timeout_cnt_suspend <= rfs_timeout_cnt == max_refresh_itv_p - 1;
    end
    // 刷新超时
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            rfs_timeout_reg <= 1'b0;
        else
            rfs_timeout_reg <= rfs_timeout_cnt == max_refresh_itv_p - 1;
    end

endmodule
