`ifndef UVM_OUT_ODER_SCORBOARD_LIB_SV
`define UVM_OUT_ODER_SCORBOARD_LIB_SV

// Compare macro
`define compare(check_name, id, act_data, exp_data, name, pass_cnt, fail_cnt) \
   if(act_data == exp_data) begin \
      pass_cnt++; \
      `uvm_info(check_name, $sformatf("PASS! [id='h%0h] \nACT_%0s='h%0h \nEXP_%0s='h%0h", \
                                      id, name, act_data, name, exp_data), UVM_LOW); \
   end \
   else begin \
      fail_cnt++; \
      `uvm_error(check_name, $sformatf("FAIL! [id='h%0h] \nACT_%0s='h%0h \nEXP_%0s='h%0h", \
                                       id, name, act_data, name, exp_data)); \
   end

 class uvm_out_oder_scorboard_lib #(type T = int,
                                           type id_type = int) extends uvm_scoreboard;

   `uvm_component_param_utils(uvm_out_oder_scorboard_lib #(T,id_type))
     // `uvm_field_queue(exp_que, UVM_ALL_ON)
     // `uvm_field_queue(act_que, UVM_ALL_ON)
  // `uvm_component_param_utils_end

   uvm_object fld;

   // associative array (id -> transaction queue)
   T exp_que [id_type][int][$];
   T act_que [id_type][int][$];

   // counters
   int unsigned pass_cnt = 0;
   int unsigned fail_cnt = 0;

   string signal_name = "DEFAULT_NAME1";  // e.g., "READ_DATA"

   // trigger event
    id_type id;
    uvm_event ev;
	protected int exp_pkt_num;
	protected int act_pkt_num;

   function new(string name="uvm_out_oder_scorboard_lib", uvm_component parent=null);
      super.new(name,parent);
      ev = new("ev");
   endfunction

   // -----------------------------
   // method name :- set_exp_buffer
   // argument :- id, expected data
   // description :- API for pushing expected/actual data in queue array according to id
   // -----------------------------
    virtual function void set_exp_buffer(id_type id, T exp_data );
     // exp_que[id][exp_pkt_num] = exp_data;
      exp_que[id][exp_pkt_num].push_back(exp_data);
	  exp_pkt_num++;
	  $display(" SCRBRD EXPECTED");
    endfunction

   // -----------------------------
   // method name :- set_act_buffer
   // argument :- id, actual data
   // description :- API for pushing expected/actual data in queue array according to id
   // -----------------------------
   virtual function void set_act_buffer(id_type id, T act_data );
      //act_que[id][act_pkt_num] = act_data;
      act_que[id][act_pkt_num].push_back(act_data);
	  act_pkt_num++;
      this.id = id;
      ev.trigger();
   endfunction

   // -----------------------------
   //  method name :- compare
   //  arguments :- id, expected data (exp_data), actual data (act_data)
   //  description :- call compare macro and compare data according to id 
   // -----------------------------
   virtual task compare(T exp_data, T act_data, id_type id);
     // if(exp_data.get_field()) 
      `compare(signal_name,id,act_data,exp_data,signal_name,pass_cnt,fail_cnt);

   endtask

   // -----------------------------
   // method name :- run_phase
   // argument :- phase type of uvm_phase 
   // description :- call compare task and provide data to compare macro.
   //                and comapre call when id is same for actual data and expected data
   // -----------------------------
   virtual task run_phase(uvm_phase phase);
      T exp_data [$];
      T act_data [$];
	  int pkt_num;
      forever begin
          ev.wait_trigger;

         if (exp_que.exists(id) && act_que.exists(id)) begin
            if (exp_que[id].size() == 0 || act_que[id].size() == 0)
               continue;

            exp_data = exp_que[id][pkt_num];
            act_data = act_que[id][pkt_num];

            foreach(exp_data[i]) begin
			  $display("================ Comaparing packet Number : 'd%0d ================",pkt_num);
			  compare(exp_data[i], act_data[i], id);
			end
			pkt_num++;
         end
      end
   endtask

   // -----------------------------
   // method name :- check_phase
   // argument :- phase type of uvm_phase 
   // description :- check size of queue array of ecach id. if non zero then show error some data are uncheck (not compare)
   //                provide result.
   // -----------------------------
   virtual function void check_phase(uvm_phase phase);
      foreach (exp_que[i,j]) begin
         if (exp_que[i][j].size() != 0)
            `uvm_error(get_name(), $sformatf("%0d expected transactions not compared for id=%0h",
                                             exp_que[i][j].size(), i))
      end
      foreach (act_que[i,j]) begin
         if (act_que[i][j].size() != 0)
            `uvm_error(get_name(), $sformatf("%0d actual transactions not compared for id=%0h",
                                             act_que[i][j].size(), i))
      end
      `uvm_info("SCOREBOARD", $sformatf("Final Result: PASS=%0d FAIL=%0d", pass_cnt, fail_cnt), UVM_LOW);

   endfunction

endclass

`endif

