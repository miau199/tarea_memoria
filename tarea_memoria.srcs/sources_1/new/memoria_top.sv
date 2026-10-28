`timescale 1ns / 1ps

module memoria_top #(
    parameter int DATA_WIDTH = 8,  // Ancho de palabra (bits por dirección)
    parameter int ADDR_WIDTH = 4   // Ancho del bus de direcciones (2^ADDR_WIDTH posiciones)
)(
    input  logic                   clk,           // Reloj del sistema
    input  logic                   write_enable,  // Habilitador de escritura (we)
    input  logic                   read_enable,   // Habilitador de lectura (re)
    input  logic [ADDR_WIDTH-1:0]  address,       // Bus de direcciones
    input  logic [DATA_WIDTH-1:0]  data_in,       // Bus de entrada de datos
    output logic [DATA_WIDTH-1:0]  data_out       // Bus de salida de datos
);

    // Cantidad total de palabras de memoria: 2^ADDR_WIDTH
    localparam int MEM_DEPTH = 1 << ADDR_WIDTH;

    // Matriz de almacenamiento interna (banco de registros/celdas)
    logic [DATA_WIDTH-1:0] memory_array [0:MEM_DEPTH-1];

    // Operación de Escritura (Sincrónica con el flanco positivo de reloj)
    always_ff @(posedge clk) begin
        if (write_enable) begin
            memory_array[address] <= data_in;
        end
    end

    // Operación de Lectura (Habilitada por read_enable según la arquitectura del video)
    always_comb begin
        if (read_enable) begin
            data_out = memory_array[address];
        end else begin
            data_out = 'z; // Alta impedancia cuando read_enable está inactivo
        end
    end

endmodule