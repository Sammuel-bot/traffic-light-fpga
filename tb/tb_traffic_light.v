`timescale 1ns/1ps

module tb_traffic_light;

    reg        clk, rst, ped_btn;
    wire       red, yellow, green, ped_walk;
    wire [3:0] timer;

    traffic_light_controller #(
        .RED_TIME(10), .GREEN_TIME(10),
        .YELLOW_TIME(5), .PED_TIME(8)
    ) dut (
        .clk(clk), .rst(rst), .ped_btn(ped_btn),
        .red(red), .yellow(yellow), .green(green),
        .ped_walk(ped_walk), .timer(timer)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/traffic_light.vcd");
        $dumpvars(0, tb_traffic_light);
    end

    initial begin
        $display("=== TRAFFIC LIGHT SIMULATION ===");
        rst=1; ped_btn=0;
        #30 rst=0;
        $display("Reset released - entering RED phase");
        #100;
        $display("Testing pedestrian button press");
        ped_btn=1; #10; ped_btn=0;
        #200;
        $display("Simulation complete");
        $finish;
    end

    initial begin
        $monitor("T=%0t | RED=%b YEL=%b GRN=%b PED=%b | TIMER=%0d",
                 $time, red, yellow, green, ped_walk, timer);
    end

endmodule