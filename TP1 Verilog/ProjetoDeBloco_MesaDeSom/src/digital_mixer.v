module digital_mixer (
    input wire clk,
    input wire rst_n,
    input wire signed [15:0] entrada_1,
    input wire signed [15:0] entrada_2,
    input wire [7:0] vol_ch1,           // Volume 0 = mudo, 128 = 1x, 255 = 2x
    input wire [7:0] vol_ch2,
    output reg signed [15:0] saida_som
);

    reg signed [24:0] mult1;
    reg signed [24:0] mult2;
    reg signed [25:0] sinal_mixado;
    
    wire signed [25:0] escala_saida;
    assign escala_saida = sinal_mixado >>> 7; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mult1        <= 25'sd0;
            mult2        <= 25'sd0;
            sinal_mixado <= 26'sd0;
            saida_som    <= 16'sd0;
        end else begin
            mult1 <= entrada_1 * $signed({1'b0, vol_ch1});
            mult2 <= entrada_2 * $signed({1'b0, vol_ch2});
            
            sinal_mixado <= mult1 + mult2;
            
            if (escala_saida > 26'sd32367)
                saida_som <= 16'sd32767;
            else if (escala_saida < -26'sd32768)
                saida_som <= -16'sd32768;
            else
                saida_som <= escala_saida[15:0];
        end
    end
endmodule