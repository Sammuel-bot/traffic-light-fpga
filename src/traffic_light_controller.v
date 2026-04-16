module traffic_light_controller (
    input  wire clk,
    input  wire rst,
    input  wire ped_btn,
    output reg  red,
    output reg  yellow,
    output reg  green,
    output reg  ped_walk,
    output reg  [3:0] timer
);

    parameter RED_TIME    = 20;
    parameter GREEN_TIME  = 20;
    parameter YELLOW_TIME = 10;
    parameter PED_TIME    = 15;

    localparam S_RED    = 2'b00;
    localparam S_GREEN  = 2'b01;
    localparam S_YELLOW = 2'b10;
    localparam S_PED    = 2'b11;

    reg [1:0] state;
    reg [4:0] count;
    reg       ped_req;

    always @(posedge clk) begin
        if (rst) ped_req <= 0;
        else if (ped_btn) ped_req <= 1;
        else if (state == S_PED) ped_req <= 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= S_RED;
            count <= 0;
        end else begin
            count <= count + 1;
            case (state)
                S_RED:    if (count == RED_TIME-1)    begin count <= 0; state <= S_GREEN;  end
                S_GREEN:  if (count == GREEN_TIME-1)  begin count <= 0; state <= S_YELLOW; end
                S_YELLOW: if (count == YELLOW_TIME-1) begin count <= 0; state <= ped_req ? S_PED : S_RED; end
                S_PED:    if (count == PED_TIME-1)    begin count <= 0; state <= S_RED;    end
                default:  begin state <= S_RED; count <= 0; end
            endcase
        end
    end

    always @(*) begin
        red=0; yellow=0; green=0; ped_walk=0; timer=0;
        case (state)
            S_RED:    begin red=1;      timer = RED_TIME    - count; end
            S_GREEN:  begin green=1;    timer = GREEN_TIME  - count; end
            S_YELLOW: begin yellow=1;   timer = YELLOW_TIME - count; end
            S_PED:    begin red=1; ped_walk=1; timer = PED_TIME - count; end
        endcase
    end

endmodule