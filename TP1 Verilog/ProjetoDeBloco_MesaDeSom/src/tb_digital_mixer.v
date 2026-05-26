`timescale 1ns / 1ps

module tb_digital_mixer;

    reg clk;
    reg rst_n;
    reg signed [15:0] entrada_1;
    reg signed [15:0] entrada_2;
    reg [7:0] vol_ch1;
    reg [7:0] vol_ch2;
    wire signed [15:0] saida_som;

    digital_mixer uut (
        .clk(clk),
        .rst_n(rst_n),
        .entrada_1(entrada_1),
        .entrada_2(entrada_2),
        .vol_ch1(vol_ch1),
        .vol_ch2(vol_ch2),
        .saida_som(saida_som)
    );

    // Geração do Clock: Período de 20ns (Equivale a 50 MHz)
    always #10 clk = ~clk;

    initial
    begin
        $dumpfile("testbench_digital.vcd");
        $dumpvars(0, tb_digital_mixer);
        
        clk = 0;
        rst_n = 0;
        entrada_1 = 16'sd0;
        entrada_2 = 16'sd0;
        vol_ch1 = 8'd0;
        vol_ch2 = 8'd0;
        $display("Tempo=%0t | CENARIO 3 | entrada_1 = %d | entrada_2 = %d | vol_ch1 = %d | vol_ch2 = %d | saida_som = %d", $time, entrada_1, entrada_2, vol_ch1, vol_ch2, saida_som);

        //Libera o sistema do reset
        repeat(2) @(posedge clk);
        #2; 
        rst_n = 1;

        //CENARIO 1: Canal 1 com ganho 1.0 (128) e canal 2 Mutado
        entrada_1 = 16'sd5000;  
        entrada_2 = 16'sd12000;
        vol_ch1 = 8'd128;       
        vol_ch2 = 8'd0;         
        //Saída esperada 5000
        repeat(3) @(posedge clk); // Espera a conta ser feita
        #2;
        // Printa manualmente o resultado após o cálculo:
        $display("Tempo=%0t | CENARIO 1 | entrada_1 = %d | entrada_2 = %d | vol_ch1 = %d | vol_ch2 = %d | saida_som = %d", $time, entrada_1, entrada_2, vol_ch1, vol_ch2, saida_som);


        //CENARIO 2: Ambos os canais somados normalmente
        entrada_1 = 16'sd4000;
        entrada_2 = 16'sd6000;
        vol_ch1 = 8'd128;       
        vol_ch2 = 8'd128;       
        //Saída esperada 1000
        repeat(3) @(posedge clk);
        #2;
        $display("Tempo=%0t | CENARIO 2 | entrada_1 = %d | entrada_2 = %d | vol_ch1 = %d | vol_ch2 = %d | saida_som = %d", $time, entrada_1, entrada_2, vol_ch1, vol_ch2, saida_som);


        //CENARIO 3: Teste de Estouro
        entrada_1 = 16'sd30000;
        entrada_2 = 16'sd25000;
        vol_ch1 = 8'd255;       
        vol_ch2 = 8'd255;
        //Saída esperada 32767
        repeat(3) @(posedge clk);
        #2;
        $display("Tempo=%0t | CENARIO 3 | entrada_1 = %d | entrada_2 = %d | vol_ch1 = %d | vol_ch2 = %d | saida_som = %d", $time, entrada_1, entrada_2, vol_ch1, vol_ch2, saida_som);
        
        #100;
        $finish;
    end
endmodule