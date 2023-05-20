initial
begin
    clk = 1'b0;
    forever
        clk = #8 ~ clk;
end

initial
begin
    rst_n = 1'b0;
    repeat(10) @ (posedge clk) rst_n <= 1'b0;
    @ (posedge clk) rst_n <= 1'b1;
end

initial
begin
    set_init_time = 1'b0;
    @ (posedge clk) set_init_time <= 1'b0;
end

initial
begin
    set_offset_time = 1'b0;
    forever @ (posedge clk) std::randomize(set_offset_time) with { set_offset_time dist { 0 := 9, 1 := 1 }; };
end

initial
begin
    plus_offset_time = 1'b0;
    repeat(100) @ (posedge clk) plus_offset_time <= 1'b1;
    forever @ (posedge clk) plus_offset_time <= $random;
end

initial
begin
    init_time_sub_ns = {TIME_WIDTH_SUB_NS{1'b0}};
    @ (posedge clk) init_time_sub_ns <= {TIME_WIDTH_SUB_NS{1'b0}};
end

initial
begin
    init_time_ns = {TIME_WIDTH_NS{1'b0}};
    @ (posedge clk) init_time_ns <= {TIME_WIDTH_NS{1'b0}};
end

initial
begin
    init_time_sec = {TIME_WIDTH_SEC{1'b0}};
    @ (posedge clk) init_time_sec <= {TIME_WIDTH_SEC{1'b0}};
end

initial
begin
    offset_time_sub_ns = {TIME_WIDTH_SUB_NS{1'b0}};
//    @ (posedge clk) offset_time_sub_ns <= {TIME_WIDTH_SUB_NS{1'b0}};
    @ (posedge clk) offset_time_sub_ns <= (1'b1<<19);
end

initial
begin
    offset_time_ns = {TIME_WIDTH_NS{1'b0}};
    @ (posedge clk) offset_time_ns <= 500000000;
end

initial
begin
    incr_time_sub_ns = 0;
    @ (posedge clk) incr_time_sub_ns <= (1'b1 << 19);
end

initial
begin
    incr_time_ns = 16;
    @ (posedge clk) incr_time_ns <= 16;
end

