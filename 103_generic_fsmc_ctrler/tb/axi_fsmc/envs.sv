`timescale 1ns / 1ps

`ifndef __ENV_H

`define __ENV_H

`include "transactions.sv"
`include "agents.sv"

/** 环境:AXI-FSMC **/
class AXIFsmcEnv extends uvm_env;
	
	// 组件
	local AXIMasterAgent #(.out_drive_t(1), .addr_width(32), .data_width(32), 
		.bresp_width(2), .rresp_width(2)) m_axi_agt; // AXI主机代理
	
	// 通信fifo
	local uvm_tlm_analysis_fifo #(AXITrans #(.addr_width(32), .data_width(32), 
		.bresp_width(2), .rresp_width(2))) m_axi_agt_rd_trans_fifo;
	local uvm_tlm_analysis_fifo #(AXITrans #(.addr_width(32), .data_width(32), 
		.bresp_width(2), .rresp_width(2))) m_axi_agt_wt_trans_fifo;
	
	// 通信端口
	local uvm_blocking_get_port #(AXITrans #(.addr_width(32), .data_width(32), 
		.bresp_width(2), .rresp_width(2))) m_axi_agt_rd_trans_port;
	local uvm_blocking_get_port #(AXITrans #(.addr_width(32), .data_width(32), 
		.bresp_width(2), .rresp_width(2))) m_axi_agt_wt_trans_port;
	
	// 事务
	local AXITrans #(.addr_width(32), .data_width(32), 
		.bresp_width(2), .rresp_width(2)) m_axi_agt_rd_trans;
	local AXITrans #(.addr_width(32), .data_width(32), 
		.bresp_width(2), .rresp_width(2)) m_axi_agt_wt_trans;
	
	// 注册component
	`uvm_component_utils(AXIFsmcEnv)
	
	function new(string name = "AXIFsmcEnv", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// 创建agent
		this.m_axi_agt = AXIMasterAgent #(.out_drive_t(1), .addr_width(32), .data_width(32), 
			.bresp_width(2), .rresp_width(2))::type_id::create("agt", this);
		this.m_axi_agt.is_active = UVM_ACTIVE;
		
		// 创建通信fifo
		this.m_axi_agt_rd_trans_fifo = new("m_axi_agt_rd_trans_fifo", this);
		this.m_axi_agt_wt_trans_fifo = new("m_axi_agt_wt_trans_fifo", this);
		
		// 创建通信端口
		this.m_axi_agt_rd_trans_port = new("m_axi_agt_rd_trans", this);
		this.m_axi_agt_wt_trans_port = new("m_axi_agt_wt_trans", this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// 连接agent的通信端口
		this.m_axi_agt.rd_trans_analysis_port.connect(this.m_axi_agt_rd_trans_fifo.analysis_export);
		this.m_axi_agt.wt_trans_analysis_port.connect(this.m_axi_agt_wt_trans_fifo.analysis_export);
		
		this.m_axi_agt_rd_trans_port.connect(this.m_axi_agt_rd_trans_fifo.blocking_get_export);
		this.m_axi_agt_wt_trans_port.connect(this.m_axi_agt_wt_trans_fifo.blocking_get_export);
	endfunction
	
	virtual task main_phase(uvm_phase phase);
		super.main_phase(phase);
		
		fork
			forever
			begin
				this.m_axi_agt_rd_trans_port.get(this.m_axi_agt_rd_trans);
				this.m_axi_agt_rd_trans.print(); // 打印事务
			end
			forever
			begin
				this.m_axi_agt_wt_trans_port.get(this.m_axi_agt_wt_trans);
				this.m_axi_agt_wt_trans.print(); // 打印事务
			end
		join_none
	endtask
	
endclass
	
`endif
