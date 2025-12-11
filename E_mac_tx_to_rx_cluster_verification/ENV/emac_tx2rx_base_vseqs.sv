/******************************************************************************************************************************************
 File Name   : emac_tx2rx_base_vseqs.sv
 Author Name : Jyoti Vishwakarma
 Date        : Dec 1
 Description : These is seqs to test working of output port
 ****************************************************************************************************************************************/

`ifndef EMAC_TX2RX_BASE_VIRTUAL_SEQS
`define EMAC_TX2RX_BASE_VIRTUAL_SEQS

class emac_tx2rx_base_vseqs extends mac_to_axi_s_base_virtual_seqs;

  `uvm_object_utils(emac_tx2rx_base_vseqs)
  

   mac_tx_base_seqs emac_tx_seqs[`NO_OF_INPUT_PORT];

   rand bit [11:0]  vln_q[`NO_OF_INPUT_PORT][$];
   rand bit [4:0]   conn_id_q[`NO_OF_INPUT_PORT][$];
   rand bit [7:0]   vcid_q[`NO_OF_INPUT_PORT][$];   
   rand bit         conn_valid;
   rand bit [3:0]   outport_sel;
   rand int         no_pkt[`NO_OF_INPUT_PORT];          //It indicates port number as index and value at that index as number of packet driven at that port  
   rand int         min_pyld_size[`NO_OF_INPUT_PORT]; 
   rand int         max_pyld_size[`NO_OF_INPUT_PORT]; 
   rand int         total_num_packet; 
   function new(string name = "emac_tx2rx_base_vseqs");

      super.new(name);

      endfunction
  
  constraint priorty             {   solve no_pkt before conn_id_q;
                                     solve no_pkt before vln_q;
                                     solve no_pkt before vcid_q;
	                             solve conn_id_q[0] before conn_id_q[1];
	                             solve conn_id_q[0] before conn_id_q[2];
	                             solve conn_id_q[1] before conn_id_q[2];
				    };
  constraint ques_size            { 
	                            foreach(conn_id_q[i]) conn_id_q[i].size() == no_pkt[i];
	                            foreach(vln_q[i])        vln_q[i].size()  == no_pkt[i];
                                    foreach(vcid_q[i])      vcid_q[i].size()  == no_pkt[i];
                                  				     
				    };
  constraint payload_size         {
                                     foreach(min_pyld_size[i])     min_pyld_size[i]  inside { [0:99]}; 
                                     foreach(max_pyld_size[i])     max_pyld_size[i]  inside { [1:100]}; 
                                     foreach(min_pyld_size[i])     min_pyld_size[i] < max_pyld_size[i];
                                    //foreach(min_pyld_size[i])     min_pyld_size[i].size()  == no_pkt[i];
                                    //foreach(max_pyld_size[i])     max_pyld_size[i].size()  == no_pkt[i];
				    };


  //To make sure that connection_id and vcid for respective ports are different
  constraint connection_id        { foreach(conn_id_q[1][i]) !(conn_id_q[1][i] inside { conn_id_q[0]});
                                    foreach(conn_id_q[2][i]) !(conn_id_q[2][i] inside { conn_id_q[1]}); 
                                    foreach(conn_id_q[2][i]) !(conn_id_q[2][i] inside { conn_id_q[0]}); 
				    };
  constraint vc_id                { foreach(vcid_q[1][i]) !(vcid_q[1][i] inside { vcid_q[0] });
                                    foreach(vcid_q[2][i]) !(vcid_q[2][i] inside { vcid_q[1] }); 
				    foreach(vcid_q[2][i]) !(vcid_q[2][i] inside { vcid_q[0] });
				    };
//Incase repeatation of connection_id off constraint unique_connection_id -> this is per port
//  constraint unique_connection_id { foreach( conn_id_q[i])    unique{conn_id_q[i]};};
//  constraint unique_vc_id         { foreach( vcid_q[i]   )    unique{vcid_q[i]   };};
    constraint unique_vlan          { foreach( vln_q[i]    )    unique{vln_q[i]    };};

	

  constraint no_pkt_range         { foreach(no_pkt[i]) soft no_pkt[i] inside {1}; total_num_packet == no_pkt.sum();};
 

   function seqs_summary();
      $display("****************************************************************************");
      $display("\n                      ---  SEQUENCE SUMMARY  ---  ");
      $display("\nTOTAL NUM OF PKT : %0d \nNUM_PACKET : Port[0]: %0d Port[1] : %0d Port[2] : %0d"
      , total_num_packet ,no_pkt[0] ,no_pkt[1], no_pkt[2]);
      $display("****************************************************************************");
      $display(" | PAYLOAD_RANGE | :");
      foreach(min_pyld_size[i]) $write("Port[%0d]-> [%0d : %0d] | ", i, min_pyld_size[i], max_pyld_size[i]); 

      $display("\n****************************************************************************");

      foreach(vcid_q[i]) begin

      $display("\n   --- Port [%0d]", i);
      $display("| VCID | :"); 
      foreach(vcid_q[i][j]) $write(" [%0d]:'d%0d ",  j, vcid_q[i][j]);
      $display("\n-----------------------------------------------------");
      $display("| VLAN | :");
      foreach(vln_q[i][j]) $write(" [%0d]:'d%0d ",  j, vln_q[i][j]);
      $display("\n-----------------------------------------------------");
      $display("| CONN_ID | : ");
      foreach(vcid_q[i][j]) $write(" [%0d]:'d%0d ",  j,conn_id_q[i][j]);
      $display("\n****************************************************************************");
      end
      $display("****************************************************************************");
      endfunction


endclass

`endif

