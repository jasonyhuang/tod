module tod_core #(parameter TIME_WIDTH_SUB_NS=20, TIME_WIDTH_NS=32, TIME_WIDTH_SEC=48) (
    input clk,
    input rst_n,
    input set_init_time, // pulse sigal
    input set_offset_time, // pulse sigal
    input plus_offset_time, // level signal
    input wire [TIME_WIDTH_SUB_NS-1:0] init_time_sub_ns,
    input wire [TIME_WIDTH_NS-1:0] init_time_ns,
    input wire [TIME_WIDTH_SEC-1:0] init_time_sec,
    input wire [TIME_WIDTH_SUB_NS-1:0] offset_time_sub_ns,
    input wire [TIME_WIDTH_NS-1:0] offset_time_ns, // max: 999999999 ns
    input wire [TIME_WIDTH_SUB_NS-1:0] incr_time_sub_ns,
    input wire [TIME_WIDTH_NS-1:0] incr_time_ns,
    output reg [TIME_WIDTH_SUB_NS-1:0] time_sub_ns,
    output reg [TIME_WIDTH_NS-1:0] time_ns,
    output reg [TIME_WIDTH_SEC-1:0] time_sec
);

reg [TIME_WIDTH_SUB_NS+1:0] time_sub_ns_nxt;
reg [TIME_WIDTH_NS-1:0] time_ns_nxt;
reg [1:0] ns_adv;
reg ns_dec;
reg sec_adv;
reg sec_dec;

wire [TIME_WIDTH_SUB_NS:0] time_sub_ns_limit = (1'b1 << TIME_WIDTH_SUB_NS);
wire [TIME_WIDTH_SUB_NS+1:0] time_sub_ns_limit1 = (1'b1 << (TIME_WIDTH_SUB_NS+1));

always @(*) begin
    ns_dec = 1'b0;
    if (set_offset_time)
        if (plus_offset_time) time_sub_ns_nxt = time_sub_ns + incr_time_sub_ns + offset_time_sub_ns;
        else begin
            if ((time_sub_ns + incr_time_sub_ns) > offset_time_sub_ns) time_sub_ns_nxt = (time_sub_ns + incr_time_sub_ns) - offset_time_sub_ns;
            else begin
                time_sub_ns_nxt = ((1'b1 << TIME_WIDTH_SUB_NS) + time_sub_ns + incr_time_sub_ns) - offset_time_sub_ns;
                ns_dec = 1'b1;
            end
        end
    else
        time_sub_ns_nxt = time_sub_ns + incr_time_sub_ns;
end

always @(*) begin
    if (time_sub_ns_nxt >= time_sub_ns_limit1)
        ns_adv = 2'b10;
    else if (time_sub_ns_nxt >= time_sub_ns_limit)
        ns_adv = 2'b01;
    else
        ns_adv = 2'b00;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        time_sub_ns <= {TIME_WIDTH_SUB_NS{1'b0}};
    end
    else if (set_init_time) begin
        time_sub_ns <= init_time_sub_ns;
    end
    else begin
        time_sub_ns <= time_sub_ns_nxt[TIME_WIDTH_SUB_NS-1:0];
    end
end

always @(*) begin
    sec_dec = 1'b0;
    if (set_offset_time)
        if (plus_offset_time)
            if ((time_ns + incr_time_ns + ns_adv - ns_dec + offset_time_ns) >= 1000000000) begin
                sec_adv = 1'b1;
                time_ns_nxt = (time_ns + incr_time_ns + ns_adv - ns_dec + offset_time_ns) - 1000000000;
            end
            else begin
                sec_adv = 1'b0;
                time_ns_nxt = time_ns + incr_time_ns + ns_adv - ns_dec + offset_time_ns;
            end
        else
            if ((time_ns + incr_time_ns + ns_adv) >= (ns_dec + offset_time_ns)) begin
                if (((time_ns + incr_time_ns + ns_adv) - (ns_dec + offset_time_ns)) >= 1000000000) begin
                    sec_adv = 1'b1;
                    time_ns_nxt = time_ns + incr_time_ns + ns_adv - ns_dec - offset_time_ns - 1000000000;
                end
                else begin
                    sec_adv = 1'b0;
                    time_ns_nxt = time_ns + incr_time_ns + ns_adv - ns_dec - offset_time_ns;
                end
            end
            else begin
                sec_dec = 1'b1;
                time_ns_nxt = (1000000000 + time_ns + incr_time_ns + ns_adv) - (ns_dec + offset_time_ns);
            end
    else
        if ((time_ns + incr_time_ns + ns_adv - ns_dec) >= 1000000000) begin
            sec_adv = 1'b1;
            time_ns_nxt = time_ns + incr_time_ns + ns_adv -ns_dec - 1000000000;
        end
        else begin
            sec_adv = 1'b0;
            if (time_ns+incr_time_ns+ns_adv > ns_dec) time_ns_nxt = time_ns + incr_time_ns + ns_adv - ns_dec;
            else begin
                time_ns_nxt = 1000000000 + time_ns + incr_time_ns + ns_adv - ns_dec;
                sec_dec = 1'b1;
            end
        end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        time_ns <= {TIME_WIDTH_NS{1'b0}};
    end
    else if (set_init_time) begin
        time_ns <= init_time_ns;
    end
    else begin
        time_ns <= time_ns_nxt;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        time_sec <= {TIME_WIDTH_SEC{1'b0}};
    end
    else if (set_init_time) begin
        time_sec <= init_time_sec;
    end
    else begin
        time_sec <= time_sec + sec_adv - sec_dec;
    end
end

endmodule
