module vga_text_display (
    input clk,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input valid_pixel,
    input [127:0] display_text,  // 16 characters (4 characters x 4 lines)
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);

// Display layout: 4x4 text (80x30 characters)
// Character size: 8x8 pixels
// Display area: 640x480 pixels

wire [6:0] char_x = pixel_x[9:3];  // 0-79
wire [6:0] char_y = pixel_y[8:3];  // 0-59
wire [2:0] pixel_in_char_x = pixel_x[2:0];  // 0-7
wire [2:0] pixel_in_char_y = pixel_y[2:0];  // 0-7

// Extract character index (only show first 16 chars in 4x4 grid)
wire [3:0] char_index;
assign char_index = ((char_y < 4) && (char_x[3:0] < 4)) ? ((char_y * 4) + char_x[3:0]) : 4'h0;

// Extract current character to display
reg [7:0] current_char;  // Changed from wire to reg

always @(*) begin
    case(char_index)
        4'd0: current_char = display_text[7:0];
        4'd1: current_char = display_text[15:8];
        4'd2: current_char = display_text[23:16];
        4'd3: current_char = display_text[31:24];
        4'd4: current_char = display_text[39:32];
        4'd5: current_char = display_text[47:40];
        4'd6: current_char = display_text[55:48];
        4'd7: current_char = display_text[63:56];
        4'd8: current_char = display_text[71:64];
        4'd9: current_char = display_text[79:72];
        4'd10: current_char = display_text[87:80];
        4'd11: current_char = display_text[95:88];
        4'd12: current_char = display_text[103:96];
        4'd13: current_char = display_text[111:104];
        4'd14: current_char = display_text[119:112];
        4'd15: current_char = display_text[127:120];
        default: current_char = 8'h00;
    endcase
end

// Get bitmap row for current character
wire [7:0] bitmap_row;
char_rom rom_inst (
    .char_addr(current_char[5:0]),
    .row(pixel_in_char_y),
    .char_bitmap(bitmap_row)
);

// Determine if pixel is on
wire pixel_on = bitmap_row[7 - pixel_in_char_x];

always @(*) begin
    if (valid_pixel) begin
        if (pixel_on) begin
            // White text on black background
            red = 4'hF;
            green = 4'hF;
            blue = 4'hF;
        end
        else begin
            red = 4'h0;
            green = 4'h0;
            blue = 4'h0;
        end
    end
    else begin
        red = 4'h0;
        green = 4'h0;
        blue = 4'h0;
    end
end

endmodule
