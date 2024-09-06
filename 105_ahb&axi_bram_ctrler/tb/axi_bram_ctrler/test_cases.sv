`timescale 1ns / 1ps

`ifndef __CASE_H

`define __CASE_H

`include "transactions.sv"
`include "envs.sv"

class AXIBramCtrlerCase0MAHBSeq extends uvm_sequence #(AXITrans #(.addr_width(32), .data_width(32), 
	.bresp_width(2), .rresp_width(2)));
	
	local AXITrans #(.addr_width(32), .data_width(32), 
		.bresp_width(2), .rresp_width(2)) m_axi_trans; // AXI主机事务
	
	// 注册object
	`uvm_object_utils(AXIBramCtrlerCase0MAHBSeq)
	
	function new(string name = "AXIBramCtrlerCase0MAHBSeq");
		super.new(name);
	endfunction
	
	virtual task body();
		if(this.starting_phase != null) 
			this.starting_phase.raise_objection(this);
		
		`uvm_create(this.m_axi_trans)
		this.m_axi_trans.is_rd_trans = 1'b0;
		this.m_axi_trans.data_n = 5;
		this.m_axi_trans.addr = 0;
		this.m_axi_trans.burst = 2'b01;
		this.m_axi_trans.len = 8'd4;
		this.m_axi_trans.size = 3'b010;
		this.m_axi_trans.addr_wait_period_n = 0;
		this.m_axi_trans.wdata.push_back(1);
		this.m_axi_trans.wlast.push_back(1'b0);
		this.m_axi_trans.wstrb.push_back(4'b1111);
		this.m_axi_trans.wdata.push_back(2);
		this.m_axi_trans.wlast.push_back(1'b0);
		this.m_axi_trans.wstrb.push_back(4'b1110);
		this.m_axi_trans.wdata.push_back(3);
		this.m_axi_trans.wlast.push_back(1'b0);
		this.m_axi_trans.wstrb.push_back(4'b1101);
		this.m_axi_trans.wdata.push_back(4);
		this.m_axi_trans.wlast.push_back(1'b0);
		this.m_axi_trans.wstrb.push_back(4'b1011);
		this.m_axi_trans.wdata.push_back(5);
		this.m_axi_trans.wlast.push_back(1'b1);
		this.m_axi_trans.wstrb.push_back(4'b0111);
		this.m_axi_trans.wdata_wait_period_n = new[5];
		this.m_axi_trans.wdata_wait_period_n[0] = 1;
		this.m_axi_trans.wdata_wait_period_n[1] = 0;
		this.m_axi_trans.wdata_wait_period_n[2] = 1;
		this.m_axi_trans.wdata_wait_period_n[3] = 2;
		this.m_axi_trans.wdata_wait_period_n[4] = 0;
		`uvm_send(this.m_axi_trans)
		
		`uvm_create(this.m_axi_trans)
		this.m_axi_trans.is_rd_trans = 1'b1;
		this.m_axi_trans.data_n = 4;
		this.m_axi_trans.addr = 100;
		this.m_axi_trans.burst = 2'b01;
		this.m_axi_trans.len = 8'd3;
		this.m_axi_trans.size = 3'b010;
		this.m_axi_trans.addr_wait_period_n = 2;
		`uvm_send(this.m_axi_trans)
		
		`uvm_create(this.m_axi_trans)
		this.m_axi_trans.is_rd_trans = 1'b0;
		this.m_axi_trans.data_n = 3;
		this.m_axi_trans.addr = 200;
		this.m_axi_trans.burst = 2'b01;
		this.m_axi_trans.len = 8'd2;
		this.m_axi_trans.size = 3'b010;
		this.m_axi_trans.addr_wait_period_n = 6;
		this.m_axi_trans.wdata.push_back(6);
		this.m_axi_trans.wlast.push_back(1'b0);
		this.m_axi_trans.wstrb.push_back(4'b1111);
		this.m_axi_trans.wdata.push_back(7);
		this.m_axi_trans.wlast.push_back(1'b0);
		this.m_axi_trans.wstrb.push_back(4'b1110);
		this.m_axi_trans.wdata.push_back(8);
		this.m_axi_trans.wlast.push_back(1'b1);
		this.m_axi_trans.wstrb.push_back(4'b1101);
		this.m_axi_trans.wdata_wait_period_n = new[3];
		this.m_axi_trans.wdata_wait_period_n[0] = 0;
		this.m_axi_trans.wdata_wait_period_n[1] = 1;
		this.m_axi_trans.wdata_wait_period_n[2] = 2;
		`uvm_send(this.m_axi_trans)
		
		// 继续运行100us
		# (10 ** 5);
		
		if(this.starting_phase != null) 
			this.starting_phase.drop_objection(this);
	endtask
	
endclass

class AXIBramCtrlerCase0Test extends uvm_test;
	
	local AXIBramCtrlerEnv env; // AHB-APB桥测试环境
	
	// 注册component
	`uvm_component_utils(AXIBramCtrlerCase0Test)
	
	function new(string name = "AXIBramCtrlerCase0Test", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		this.env = AXIBramCtrlerEnv::type_id::create("env", this); // 创建env
		
		// 设置sequence
		uvm_config_db #(uvm_object_wrapper)::set(
			this, 
			"env.agt.sqr.main_phase", 
			"default_sequence", 
			AXIBramCtrlerCase0MAHBSeq::type_id::get());
	endfunction
	
	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		
		`uvm_info("AXIBramCtrlerCase0Test", "test finished!", UVM_LOW)
	endfunction
	
endclass

`endif
