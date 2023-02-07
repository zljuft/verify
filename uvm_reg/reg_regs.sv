`ifndef REG_REGS__SV
`define REG_REGS__SV

class reg_ctl extends uvm_reg;
    rand uvm_reg_field mod_en;
    rand uvm_reg_field bl_yellow;
    rand uvm_reg_field bl_red;
    rand uvm_reg_field profile;

    `uvm_object_utils(reg_ctl)

    function new(string name = "reg_ctl");
        super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
    endfunction

    virtual function void build();
        this.mod_en     = uvm_reg_field::type_id::create("mod_en", , get_full_name());
        this.bl_yellow  = uvm_reg_field::type_id::create("bl_yellow", , get_full_name());
        this.bl_red     = uvm_reg_field::type_id::create("bl_red", , get_full_name());
        this.profile    = uvm_reg_field::type_id::create("profile", , get_full_name());
        
        this.mod_en.configure(this, 1, 0, "RW", 0, 0, 1, 0, 0);   
        this.bl_yellow.configure(this, 1, 1, "RW", 0, 0, 1, 0, 0);
        this.bl_red.configure(this, 1, 2, "RW", 0, 0 , 1, 0, 0); 
        this.profile.configure(this, 1, 3, "RW", 0, 0, 1, 0, 0);
    endfunction
endclass

class reg_stat extends uvm_reg;

    uvm_reg_field state;
    `uvm_object_utils(reg_stat)

    function new(string name = "reg_stat");
        super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
    endfunction //new()

    virtual function void build();
        this.state = uvm_reg_field::type_id::create("state", , get_full_name());

        this.state.configure(this, 2, 0, "RO", 0, 0, 0, 0, 0);
    endfunction
endclass //reg_stat

class reg_timer extends uvm_reg;

    uvm_reg_field timer;

    `uvm_object_utils(reg_timer)
    function new(string name = "reg_timer");
        super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
    endfunction //new()

    virtual function void build();
        this.timer = uvm_reg_field::type_id::create("timer", , get_full_name());

        this.timer.configure(this, 32, 0, "RW", 0, 32'hcafe1234, 1, 0, 1);
        this.timer.set_reset(0, "SOFT");
    endfunction
endclass //reg_timer

class reg_traffic_block extends uvm_reg_block;
    rand reg_ctl ctrl;
    rand reg_timer timer[2];
         reg_stat stat;
    
    `uvm_object_utils(reg_traffic_block)

    function new(string name = "reg_traffic_block");
        super.new(name, build_coverage(UVM_NO_COVERAGE));        
    endfunction

    virtual function void build();
        this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
        this.ctrl = reg_ctl::type_id::create("ctrl", ,get_full_name());
        this.ctrl.configure(this, null, "");
        this.ctrl.build();
        this.default_map.add_reg(this.ctrl, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);

        this.timer[0] = reg_timer::type_id::create("timer[0]", , get_full_name());
        this.timer[0].configure(this, null, "");
        this.timer[0].build();
        this.default_map.add_reg(this.timer[0], `UVM_REG_ADDR_WIDTH'h4, "RW", 0);

        this.timer[1] = reg_timer::type_id::create("timer[1]", , get_full_name());
        this.timer[1].configure(this, null, "");
        this.timer[1].build();
        this.default_map.add_reg(this.timer[1], `UVM_REG_ADDR_WIDTH'h8, "RW", 0);

        this.stat = reg_stat::type_id::create("stat", , get_full_name());
        this.stat.configure(this, null, "");
        this.stat.build();
        this.default_map.add_reg(this.stat, `UVM_REG_ADDR_WIDTH'hc, "RO", 0);
    endfunction
endclass

class reg_sys_block extends uvm_reg_block;
    rand reg_traffic_block traffic;

    `uvm_object_utils(reg_sys_block)

    function new(string name = "reg_sys_block");
        super.new(name);
    endfunction

    virtual function void build();
        this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
        this.traffic = reg_traffic_block::type_id::create("traffic",,get_full_name());
        this.traffic.configure(this, "top.pB0");
        this.traffic.build();
        this.default_map.add_submap(this.traffic.default_map, `UVM_REG_ADDR_WIDTH'h0);
    endfunction
endclass

`endif