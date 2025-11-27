`ifndef MAC_RX_MONITOR
`define MAC_RX_MONITOR

class mac_rx_monitor extends uvm_monitor;
    `uvm_component_utils(mac_rx_monitor)
     bit [31:0] mac_rx_tdata_q [$];
     bit [3:0]  mac_rx_tkeep_q [$];
     mac_rx_sequence_item mac_rx_pkt;
     mac_rx_sequence_item temp_rx_pkt;
     axi_str_slv_seq_item#(32,32) axis_slv_item;
     uvm_tlm_analysis_fifo#(axi_str_slv_seq_item #(32,32)) mac_rx_mon_get_fifo;
     uvm_analysis_port #(mac_rx_sequence_item) mac_rx_item_collected_port;


    //TO REMOVE
    int vcid_q_act[$];



     function new (string name="",uvm_component parent);
        super.new(name,parent);
       mac_rx_mon_get_fifo=new("mac_rx_mon_get_fifo",this); 
       mac_rx_item_collected_port = new("mac_rx_item_collected_port",this);
     endfunction
    
     function void build_phase(uvm_phase phase);
         axis_slv_item=axi_str_slv_seq_item#(32,32)::type_id::create("axis_slv_item");
         mac_rx_pkt=mac_rx_sequence_item::type_id::create("mac_rx_pkt");
     endfunction

    task run_phase (uvm_phase phase);
       super.run_phase (phase);
       forever begin
          mac_rx_mon_get_fifo.get(axis_slv_item);
         // $display("INSIDE RX MON");
         // axis_slv_item.print();
          foreach(axis_slv_item.tdata_q[i])begin
            mac_rx_tdata_q.push_back(axis_slv_item.tdata_q[i]);
            mac_rx_tkeep_q.push_back(axis_slv_item.tkeep_q[i]);
          end
          mac_rx_pkt = axis_rx_to_mac(mac_rx_tdata_q,mac_rx_tkeep_q);
         `uvm_info("RX_MON", $sformatf("Converting MAC frame: %s", 
                         mac_rx_pkt.convert2string()), UVM_LOW)
          

	  vcid_q_act.push_back(mac_rx_pkt.rx_vcid);
          mac_rx_item_collected_port.write(mac_rx_pkt);
          
         
       end
    endtask
    function mac_rx_sequence_item axis_rx_to_mac(ref bit [31:0] mac_rx_tdata_q[$],
                                                 ref bit [3:0]  mac_rx_tkeep_q[$] );
               bit [7:0] rx_byte_stream[$];
               int tlast;
               int valid_byte = 4;
               int excess;
           temp_rx_pkt=mac_rx_sequence_item::type_id::create("temp_rx_pkt");

                  { >> { rx_byte_stream }} = { >> { mac_rx_tdata_q }};
                   tlast = mac_rx_tdata_q.size() -1;

                 case(mac_rx_tkeep_q[tlast])
                    4'h1 : valid_byte = 1;
                    4'h3 : valid_byte = 2;
                    4'h7 : valid_byte = 3;
                    4'hF : valid_byte = 4;
                    default : valid_byte = 4;
                 endcase

  					  excess = 4 - valid_byte;
  					  for (int i = 0; i < excess; i++)
   			     rx_byte_stream.pop_back();
                     { >> {
                           temp_rx_pkt.rx_DA,
                           temp_rx_pkt.rx_SA, 
                           temp_rx_pkt.rx_vcid,
                           temp_rx_pkt.rx_EType,
                           temp_rx_pkt.rx_payload
                          }} = rx_byte_stream;
                  return temp_rx_pkt;
 

    endfunction
    
    
    function void report_phase(uvm_phase phase);
       super.report_phase(phase);
       $display("ACTUAL VCID_Q : %p",vcid_q_act);
       endfunction 

endclass
`endif 
