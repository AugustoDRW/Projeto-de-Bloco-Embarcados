module spi_volume_slave (
    input  wire       rst_n,
    input  wire       spi_sck,
    input  wire       spi_cs,
    input  wire       spi_mosi,

    output reg  [7:0] volume_ch1,
    output reg  [7:0] volume_ch2
);

    reg [7:0] rx_shift;
    reg [2:0] bit_count;
    reg       byte_count;

    always @(posedge spi_sck or negedge rst_n)
    begin
        if (!rst_n)
        begin
            rx_shift   <= 8'd0;
            bit_count  <= 3'd0;
            byte_count <= 1'd0;
            volume_ch1 <= 8'd128;
            volume_ch2 <= 8'd128;
        end
        else if (spi_cs)
        begin
            //Nova transação SPI
            rx_shift   <= 8'd0;
            bit_count  <= 3'd0;
            byte_count <= 1'd0;
        end
        else
        begin
            //Recepção MSB first
            rx_shift <= {rx_shift[6:0], spi_mosi};

            if (bit_count == 3'd7)
            begin
                if (byte_count == 1'd0)
                begin
                    //Canal 1
                    volume_ch1 <= {rx_shift[6:0], spi_mosi};
                    byte_count <= 1'd1;
                end
                else
                begin
                    //Canal 2
                    volume_ch2 <= {rx_shift[6:0], spi_mosi};
                    byte_count <= 1'd0;
                end

                bit_count <= 3'd0;
            end
            else
            begin
                bit_count <= bit_count + 3'd1;
            end
        end
    end

endmodule