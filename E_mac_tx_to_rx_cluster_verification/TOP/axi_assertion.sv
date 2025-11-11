
module axi_assertion #(int DATA_WIDTH = 16, ADD_WIDTH = 8, ID_WIDTH = 8 ) ( input logic aclk, areset, axi_minf inf);


////=============  RESET ===========================================================================================================//// 
     
/// =============================== During Reset all valid signal must be driven low ===================================================================                          ///
      sequence reset_seqs1;
      ( (inf.awvalid !== 1) && (inf.arvalid !== 1) && (inf.wvalid !== 1) && (inf.rvalid !== 1) && (inf.bvalid !== 1) );
      endsequence
    
/// ============================== Earliest point after reset master is permitted to drive valid data is at a rising aclk after reset is high ========================            ///
      sequence reset_seqs2;
      ( $rose(inf.awvalid) || $rose(inf.arvalid) || $rose(inf.wvalid) || $rose(inf.rvalid) || $rose(inf.bvalid) );
      endsequence

      property reset_prop;
      @(posedge aclk)
      ( ( areset === 1'b0 ) |-> reset_seqs1 ) and ( $fell(areset) |=> ##[0:$] reset_seqs2 );
      endproperty

      Reset_property_check : assert property(reset_prop)
                             $info($time," RESET ASSERTION PASSED !!! ");
                             else $error($time," RESET ASSERTION FAILED !!!");

////=============  WRITE ADDR HANDSHAKING ===============================================================================================//// 
      
/// ============================================= Data should remain stable if ready is low ==================================================================                     /// 
      sequence stable_awdata_seqs;
        ( $stable(inf.awaddr) && $stable(inf.awlen) && $stable(inf.awsize) && $stable(inf.awid) ) ;
        //( $stable(inf.awaddr) && $stable(inf.awlen) && $stable(inf.awsize) && $stable(inf.awid) ) throughout (inf.awready !== 1'b1 );
      endsequence
      
/// ======================================== If valid is high the data should not be unknown ===============================================================                       ///
      sequence not_unknown_awdata_seqs;
        ( !$isunknown(inf.awaddr) && !$isunknown(inf.awlen) && !$isunknown(inf.awsize) && !$isunknown(inf.awid) ) ;
      endsequence

      property awready_prop1;
      @(posedge aclk )
      inf.awvalid |-> if (inf.awready !== 1'b1) ##1 stable_awdata_seqs;
      endproperty
      
      property awready_prop2;
      @(posedge aclk )
      inf.awvalid |-> not_unknown_awdata_seqs ;
      endproperty

      AWValid_stable_data_at_awready_low : assert property(awready_prop1)
                                   else $error($time," WADDR CHANNEL DATA IS NOT STABLE WHILE AWREADY IS LOW !!! ");
      
      AWValid_not_unknown_data : assert property(awready_prop2)
                                   else $error($time," WADDR CHANNEL DATA UNKNOWN WHILE AWVALID IS HIGH !!! ");

////=============  READ ADDR HANDSHAKING ===============================================================================================//// 
      
/// ============================================ Data should remain stable if ready is low ==================================================================                    /// 
      sequence stable_ardata_seqs;
       (  $stable(inf.araddr) && $stable(inf.arlen) && $stable(inf.arsize) && $stable(inf.arid) ) ;
       //(  $stable(inf.araddr) && $stable(inf.arlen) && $stable(inf.arsize) && $stable(inf.arid) ) throughout (inf.arready !== 1'b1 );
      endsequence
      
/// =========================================== If valid is high the data should not be unknown ==============================================================                   ///
      sequence not_unknown_ardata_seqs;
       ( (!$isunknown(inf.araddr)) &&  (!$isunknown(inf.arlen))  &&  (!$isunknown(inf.arsize))  &&  (!$isunknown(inf.arid)) ) ;
      endsequence

      property arready_prop;
      @(posedge aclk )
      inf.arvalid |-> if (inf.arready !== 1'b1) ##1 stable_ardata_seqs; 
      endproperty
      
      property arready_prop1;
      @(posedge aclk )
      inf.arvalid |-> not_unknown_ardata_seqs ;
      endproperty

      ARValid_stable_data_at_arready_low : assert property(arready_prop)
                                   else $error($time," RADDR CHANNEL DATA NOT STABLE WHILE ARREADY IS LOW !!! ");
      
      ARValid_not_unknown_data : assert property(arready_prop1)
                                   else $error($time," RADDR CHANNEL DATA IS UNKNOWN WHILE ARVALID IS HIGH !!! ");
      
////=============  WRITE DATA HANDSHAKING ===============================================================================================

/// ================================================ Data should remain stable if ready is low ===============================================================                  /// 
      sequence stable_wdata_seqs;
        //( $stable(inf.wdata) && $stable(inf.wstrb) && $stable(inf.wid) ) throughout (inf.wready !== 1'b1 );
        ( $stable(inf.wdata) && $stable(inf.wstrb) && $stable(inf.wlast) && $stable(inf.wid) ) ;
      endsequence
      
/// ============================================= If valid is high the data should not be unknown ============================================================                  ///
      sequence not_unknown_wdata_seqs;
       ( (!$isunknown(inf.wdata)) &&  (!$isunknown(inf.wstrb))  &&  (!$isunknown(inf.wlast))  &&  (!$isunknown(inf.wid)) ) ;
      endsequence
      
      property wready_prop;
      @(posedge aclk )
      (inf.wvalid) |->  if (inf.wready !== 1'b1) ##1 stable_wdata_seqs; 
      endproperty
      
      property wready_prop1;
      @(posedge aclk )
      (inf.wvalid) |-> not_unknown_wdata_seqs; 
      endproperty

      WValid_stable_data_at_wready_low : assert property(wready_prop)
                                         else $error($time," WDATA CHANNEL DATA IS NOT STABLE DURING WREADY LOW !!! ");
      
      WValid_not_unknown_data : assert property(wready_prop1)
                                   else $error($time," WDATA CHANNEL DATA IS UNKNOWN WHILE WVALID IS HIGH !!! ");
      
////=============  RVALID HANDSHAKING ===============================================================================================//// 
      
/// ============================================ Data should remain stable if ready is low ===================================================================                   /// 
      sequence stable_rresp_seqs;
        ( $stable(inf.rresp) && $stable(inf.rid) && $stable(inf.rdata) && $stable(inf.rlast) ) ;
      endsequence
      
/// ============================================ If valid is high the data should not be unknown ===============================================================                  ///
      sequence not_unknown_rresp_seqs;
       ( (!$isunknown(inf.rresp)) &&  (!$isunknown(inf.rid)) && (!$isunknown(inf.rdata)) ) ;
      endsequence
     
      property rready_check_prop;
      @(posedge aclk )
      (inf.rvalid) |->  if (inf.rready !== 1'b1) ##1 stable_rresp_seqs; 
      endproperty
      
      property rready_prop1;
      @(posedge aclk )
      (inf.rvalid) |-> not_unknown_rresp_seqs; 
      endproperty

      RValid_stable_data_at_rread_low : assert property(rready_check_prop)
                                 else $error($time," RREADY IS LOW BUT DATA IS NOT STABLE !!! ");
      
      RValid_Not_unknown_data : assert property(rready_prop1)
                                else $error($time," RVALID IS HIGH BUT INFO IS STILL UNKNOWN !!! ");

/// =========================================== Slave must wait for arvalid and arready before asserting rvalid ================================================                  ///
     sequence rvalid_seqs;
        $past( inf.arvalid , , inf.arvalid && inf.arready, );     //// 2nd argument still needs to finalize  
     endsequence 
      
     property rvalid_prop;
      @(posedge aclk )
      (inf.rvalid) |-> rvalid_seqs; 
     endproperty
      
     Rvalid_Ready_must_wait_for_arvalid_and_arready : assert property(rvalid_prop)
                                   else $error($time," RVALID CAME BEFORE ARVALID & ARREADY !!! ");
      
     property rvalid_prop2;
      @(posedge aclk)
      ( inf.arvalid && inf.arready ) |-> ##[0:$] (inf.rvalid) ; 
     endproperty
     
     Rvalid_came_after_arvalid_and_arready : assert property(rvalid_prop2)
                                    else $error($time," RVALID FAILED TO COME AFTER ARVALID & ARREADY !!! ");

////============= WVALID HANDSHAKING ===============================================================================================//// 

/// ============================================ Data should remain stable if ready is low =========================================================================               /// 
      sequence stable_bresp_seqs;
        ( $stable(inf.bresp) && $stable(inf.bid) ) ;
      endsequence
      
/// ============================================== If valid is high the data should not be unknown ==================================================================              ///
      sequence not_unknown_bresp_seqs;
       ( (!$isunknown(inf.bresp)) &&  (!$isunknown(inf.bid)) ) ;
      endsequence
      
      property bready_prop;
      @(posedge aclk )
      (inf.bvalid) |->  if (inf.bready !== 1'b1) ##1 stable_wdata_seqs; 
      endproperty
      
      property bready_prop1;
      @(posedge aclk )
      (inf.bvalid) |-> not_unknown_bresp_seqs; 
      endproperty

      BValid_Ready_stable_data_at_bready_low : assert property(bready_prop)
                                 else $error($time," BREADY IS LOW BUT DATA IS NOT STABLE !!! ");
      
      BValid_Not_unknown_data : assert property(bready_prop1)
                                else $error($time," BVALID IS HIGH BUT INFO IS STILL UNKNOWN !!! ");

/// ======================================== Slave must wait for wvalid and wready before asserting bvalid =============================================================            ///
     sequence bvalid_seqs;
        $past( inf.wvalid , , inf.wvalid && inf.wready, );     //// 2nd argument still needs to finalize  
     endsequence 
      
     property bvalid_prop1;
      @(posedge aclk )
      (inf.bvalid) |-> bvalid_seqs; 
     endproperty
      
     BValid_Ready_must_come_after_wvalid_and_wready : assert property(bvalid_prop1)
                                                     else $error($time," BVALID CAME BEFORE WVALID & WREADY !!! ");
      
     property bvalid_prop2;
      @(posedge aclk)
      ( inf.wvalid && inf.wready && inf.wlast ) |-> ##[0:$] (inf.bvalid) ; 
     endproperty
     
     BValid_after_wvalid_and_wready : assert property(bvalid_prop2)
                                      else $error($time," BVALID CAME BEFORE WVALID or WREADY or WLAST !!! ");
     
///      ========================================== Slave must wait for awvalid and awready before asserting bvalid ==============================================                ///
     sequence bvalid_seqs1;
        $past( inf.awvalid , , inf.awvalid && inf.awready, );     //// 2nd argument still needs to finalize  
     endsequence 
     
     property bvalid_prop3;
      @(posedge aclk )
      (inf.bvalid) |-> bvalid_seqs1; 
     endproperty
     
     BValid_Ready_must_come_after_awvalid_and_awready : assert property(bvalid_prop3)
                                                        else $error($time," BVALID CAME BEFORE AWVALID & AWREADY !!! ");
     
     property bvalid_prop4;
      @(posedge aclk)
      ( inf.awvalid && inf.awready ) |-> ##[0:$] (inf.bvalid) ; 
     endproperty
     
     BValid_after_awvalid_and_awready : assert property(bvalid_prop4)
                                      else $error($time," BVALID CAME AFTER AWVALID and AWREADY !!! ");



endmodule 
