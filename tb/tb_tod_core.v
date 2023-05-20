module tb_tod_core ();

parameter TIME_WIDTH_SUB_NS=20, TIME_WIDTH_NS=32, TIME_WIDTH_SEC=48;

reg  clk;
reg  rst_n;
reg  set_init_time;
reg  set_offset_time;
reg  plus_offset_time;
reg [TIME_WIDTH_SUB_NS-1:0] init_time_sub_ns;
reg [TIME_WIDTH_NS-1:0] init_time_ns;
reg [TIME_WIDTH_SEC-1:0] init_time_sec;
reg [TIME_WIDTH_SUB_NS-1:0] offset_time_sub_ns;
reg [TIME_WIDTH_NS-1:0] offset_time_ns;
reg [TIME_WIDTH_SUB_NS-1:0] incr_time_sub_ns;
reg [TIME_WIDTH_NS-1:0] incr_time_ns;

////////////////////////////////////////////////////////////////////////////////
// Wire decleration
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// DUT
////////////////////////////////////////////////////////////////////////////////
tod_core tod_core (
    .clk (clk), // input
    .rst_n (rst_n), // input
    .set_init_time (set_init_time), // input
    .set_offset_time (set_offset_time), // input
    .plus_offset_time (plus_offset_time), // input
    .init_time_sub_ns (init_time_sub_ns[TIME_WIDTH_SUB_NS-1:0]), // input
    .init_time_ns (init_time_ns[TIME_WIDTH_NS-1:0]), // input
    .init_time_sec (init_time_sec[TIME_WIDTH_SEC-1:0]), // input
    .offset_time_sub_ns (offset_time_sub_ns[TIME_WIDTH_SUB_NS-1:0]), // input
    .offset_time_ns (offset_time_ns[TIME_WIDTH_NS-1:0]), // input
    .incr_time_sub_ns (incr_time_sub_ns[TIME_WIDTH_SUB_NS-1:0]), // input
    .incr_time_ns (incr_time_ns[TIME_WIDTH_NS-1:0]) // input
);

////////////////////////////////////////////////////////////////////////////////
// Stimulus
////////////////////////////////////////////////////////////////////////////////
`include "tb_tod_core.inc"

initial
begin
    #100000;
    $finish;
end

initial
begin
`ifdef DUMP_VPD
    $vcdplusfile("tb_tod_core.vpd");
    $vcdpluson;
    $vcdplusmemon;
`else
    $fsdbDumpfile("tb_tod_core.fsdb");
    $fsdbDumpvars(0,tb_tod_core,"+mda");
`endif
end

endmodule
