module top_dois_canais (
    input  wire spi_sck,
    input  wire spi_cs,
    input  wire spi_mosi,
    input  wire rst_n,

    output wire led_debug1,
    output wire led_debug2

);

    wire [7:0] volume_ch1;
    wire [7:0] volume_ch2;

    spi_volume_slave receptor (
        .rst_n      (rst_n),
        .spi_sck    (spi_sck),
        .spi_cs     (spi_cs),
        .spi_mosi   (spi_mosi),
        .volume_ch1 (volume_ch1),
        .volume_ch2 (volume_ch2)
    );

    // Teste: LED acende se algum canal estiver acima ou igual a 128.
    assign led_debug1 = volume_ch1[7];
    assign led_debug2 = volume_ch2[7];

endmodule