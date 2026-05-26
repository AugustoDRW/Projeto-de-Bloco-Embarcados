module top (
    input wire clk,
    input wire rst_n,
    
    //Comunicação SPI com o Raspberry Pi
    input wire spi_sck,
    input wire spi_mosi,
    
    input wire i2s_bclk,
    input wire i2s_lrclk,
    input wire i2s_din,
    output wire i2s_dout
);
    wire signed [15:0] w_entrada_1 = 16'sd5000;//Valor fixo para testes
    wire signed [15:0] w_entrada_2 = 16'sd2000;
    wire [7:0] w_vol_ch1 = 8'd128;
    wire [7:0] w_vol_ch2 = 8'd64;
    wire signed [15:0] w_saida_som;

    //instancia do mixer
    digital_mixer meu_mixer (
        .clk(clk),
        .rst_n(rst_n),
        .entrada_1(w_entrada_1),
        .entrada_2(w_entrada_2),
        .vol_ch1(w_vol_ch1),
        .vol_ch2(w_vol_ch2),
        .saida_som(w_saida_som)
    );

    assign i2s_dout = w_saida_som[15] ^ i2s_din ^ spi_mosi ^ spi_sck ^ i2s_bclk ^ i2s_lrclk;

endmodule