module ForwardUnit
(input[4:0]WsEX, WsMEM, WsWB, rs, rt,
input WeEX, WeMEM, WeWB, re1, re2,
output reg[1:0] SelectorA, SelectorB
);

always @(*) begin
    if ((rs==WsEX) && re1 && WeEX) begin
        SelectorA = 1;
    end else if((rs==WsMEM) && re1 && WeMEM) begin
        SelectorA = 2;
    end else if((rs==WsWB) && re1 && WeWB)begin
      SelectorA = 3;
    end else begin
      SelectorA = 0;
    end

    if ((rt==WsEX) && re2 && WeEX) begin
        SelectorB = 1;
    end else if((rt==WsMEM) && re2 && WeMEM) begin
        SelectorB = 2;
    end else if((rt==WsWB) && re2 && WeWB)begin
      SelectorB = 3;
    end else begin
      SelectorB = 0;
    end

    $display("ForwardUnit %b , %b", SelectorA, SelectorB);
end


endmodule