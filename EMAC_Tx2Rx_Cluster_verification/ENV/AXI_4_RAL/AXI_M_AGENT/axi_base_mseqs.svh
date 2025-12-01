/////////////////////////////////////////////////////
//
//  // HEADER //
//
//  FILE NAME = axi_base_mseqs.svh
//  ENGINEER  = Muskan
//  VERSION   = 1.0 
//  DESCRIPTION =  
//
/////////////////////////////////////////////////////

`ifndef AXI_BASE_MSEQS
`define AXI_BASE_MSEQS

class axi_base_mseqs #(int DATA_WIDTH = 32 , ADD_WIDTH = 32)  extends uvm_sequence #(axi_mseq_item #(DATA_WIDTH, ADD_WIDTH));
   
  `uvm_object_param_utils(axi_base_mseqs#(DATA_WIDTH, ADD_WIDTH))
  
  axi_mseq_item #(DATA_WIDTH,ADD_WIDTH) mseq_item1;
  axi_mseq_item #(DATA_WIDTH,ADD_WIDTH) mseq_item2;
  
  axi_mseq_item #(DATA_WIDTH,ADD_WIDTH) rsp;
  
  function new (string name = "axi_base_mseqs");
      super.new(name);
   endfunction
  
/*  task body();
    
    repeat (1)begin

    mseq_item1 = axi_mseq_item #(DATA_WIDTH,ADD_WIDTH)::type_id::create("mseq_item1");
      if(!mseq_item1.randomize with { operation == WRITE ; awlen == 3 ; awsize == 2; awaddr==52 ; awburst==INCR; } )
       `uvm_fatal(get_name(),"Randomization failed !!! ")
    
      $cast(mseq_item2, mseq_item1.clone());

       $display($time," === Sequence Data === ") ;
 //      mseq_item2.print();

       `uvm_send(mseq_item2)
       end

       get_response(rsp);
       $display($time," MASTER Sequence get WRITE Response ");
       rsp.print();

    repeat (1)begin

    mseq_item1 = axi_mseq_item #(DATA_WIDTH,ADD_WIDTH)::type_id::create("mseq_item1");
      if(!mseq_item1.randomize with { operation == READ ; arlen == 3; arsize == 2 ; araddr == 52;  arburst == INCR; } )
       `uvm_fatal(get_name(),"Randomization failed !!! ")
    
      $cast(mseq_item2, mseq_item1.clone());

       $display($time," === Sequence Data === ") ;
 //      mseq_item2.print();
       `uvm_send(mseq_item2)

    end
       
       get_response(rsp);
       $display($time," MASTER Sequence get READ Response ");
       //rsp.print();

endtask   */

   
endclass 

`endif

