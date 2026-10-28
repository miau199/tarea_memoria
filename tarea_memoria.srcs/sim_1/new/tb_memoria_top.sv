`timescale 1ns / 1ps

module tb_memoria_top;

    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;

    logic                  clk;
    logic                  write_enable;
    logic                  read_enable;
    logic [ADDR_WIDTH-1:0] address;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;

    // Instancia del módulo top parametrizado
    memoria_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Generación de reloj (50 MHz / periodo de 20 ns)
    always #10 clk = ~clk;

    initial begin
        // Inicialización de señales
        clk          = 0;
        write_enable = 0;
        read_enable  = 0;
        address      = 0;
        data_in      = 0;

        #25;

        // 1. Escritura en la dirección 0x0 con el dato 0xAA
        address      = 4'h0;
        data_in      = 8'hAA;
        write_enable = 1;
        #20;
        write_enable = 0;

        #20;

        // 2. Escritura en la dirección 0x5 con el dato 0x3C
        address      = 4'h5;
        data_in      = 8'h3C;
        write_enable = 1;
        #20;
        write_enable = 0;

        #20;

        // 3. Escritura en la dirección 0xF (última celda) con el dato 0xFF
        address      = 4'hF;
        data_in      = 8'hFF;
        write_enable = 1;
        #20;
        write_enable = 0;

        #40;

        // 4. Lectura de la dirección 0x0
        address     = 4'h0;
        read_enable = 1;
        #20;

        // 5. Lectura de la dirección 0x5
        address     = 4'h5;
        #20;

        // 6. Lectura de la dirección 0xF
        address     = 4'hF;
        #20;

        // 7. Desactivar lectura (verificar alta impedancia 'z')
        read_enable = 0;
        #20;

        $finish;
    end

endmodule