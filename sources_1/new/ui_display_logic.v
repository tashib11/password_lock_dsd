module ui_display_logic (
    input [3:0] user_id,
    input [3:0] stored_password,
    input [3:0] entered_password,
    input [2:0] state,
    input [3:0] failed_attempts,
    input unlock_led,
    input lockout_led,
    input [3:0] alu_result,
    input zero_flag,
    output reg [127:0] display_text
);

always @(*) begin
    
    if (lockout_led) begin
        // ===== SYSTEM LOCKED OUT - PROFESSIONAL ALERT =====
        // Row 0: "LOCK" status
        display_text[127:120] = 8'd13;  // 'D' (L)
        display_text[119:112] = 8'd0;   // '0' (O)
        display_text[111:104] = 8'd12;  // 'C' (C)
        display_text[103:96]  = 8'd16;  // ' ' (K)
        
        // Row 1: "DISABLED" status
        display_text[95:88]   = 8'd13;  // 'D' (D)
        display_text[87:80]   = 8'd9;   // '9' (I)
        display_text[79:72]   = 8'd15;  // 'F' (S)
        display_text[71:64]   = 8'd13;  // 'D' (D)
        
        // Row 2: "ATTEMPTS: X"
        display_text[63:56]   = 8'd10;  // 'A' (A)
        display_text[55:48]   = 8'd2;   // '2' (T)
        display_text[47:40]   = 8'd2;   // '2' (T)
        display_text[39:32]   = failed_attempts;  // Attempt count
        
        // Row 3: "RESET: 0"
        display_text[31:24]   = 8'd15;  // 'F' (R)
        display_text[23:16]   = 8'd14;  // 'E' (E)
        display_text[15:8]    = 8'd15;  // 'F' (S)
        display_text[7:0]     = 8'd0;   // '0' (0)
        
    end
    else if (unlock_led && zero_flag) begin
        // ===== ACCESS GRANTED - PROFESSIONAL SUCCESS =====
        // Row 0: "GRANTED"
        display_text[127:120] = 8'd12;  // 'C' (G)
        display_text[119:112] = 8'd15;  // 'F' (R)
        display_text[111:104] = 8'd10;  // 'A' (A)
        display_text[103:96]  = 8'd14;  // 'E' (N)
        
        // Row 1: "PASSWORD OK"  
        display_text[95:88]   = 8'd15;  // 'F' (P)
        display_text[87:80]   = 8'd10;  // 'A' (A)
        display_text[79:72]   = 8'd15;  // 'F' (S)
        display_text[71:64]   = 8'd15;  // 'F' (S)
        
        // Row 2: "USER: XY"
        display_text[63:56]   = 8'd9;   // '9' (U)
        display_text[55:48]   = user_id; // User ID
        display_text[47:40]   = stored_password;  // Password value
        display_text[39:32]   = 8'd20;  // '*' (Verified marker)
        
        // Row 3: "OPEN - SUCCESS"
        display_text[31:24]   = 8'd0;   // '0' (O)
        display_text[23:16]   = 8'd15;  // 'F' (P)
        display_text[15:8]    = 8'd14;  // 'E' (E)
        display_text[7:0]     = 8'd14;  // 'E' (N)
        
    end
    else if (!unlock_led && !zero_flag && failed_attempts > 0) begin
        // ===== PASSWORD DENIED - PROFESSIONAL ERROR =====
        // Row 0: "DENIED"
        display_text[127:120] = 8'd13;  // 'D' (D)
        display_text[119:112] = 8'd14;  // 'E' (E)
        display_text[111:104] = 8'd14;  // 'E' (N)
        display_text[103:96]  = 8'd9;   // '9' (I)
        
        // Row 1: "PASSWORD - INVALID"
        display_text[95:88]   = 8'd15;  // 'F' (P)
        display_text[87:80]   = 8'd10;  // 'A' (A)
        display_text[79:72]   = 8'd15;  // 'F' (S)
        display_text[71:64]   = 8'd17;  // '-' (dash - error marker)
        
        // Row 2: "STORED: X"
        display_text[63:56]   = 8'd15;  // 'F' (S)
        display_text[55:48]   = 8'd2;   // '2' (T)
        display_text[47:40]   = stored_password;  // Value
        display_text[39:32]   = 8'd16;  // ' ' (space)
        
        // Row 3: "ENTERED: Y"
        display_text[31:24]   = 8'd14;  // 'E' (E)
        display_text[23:16]   = 8'd14;  // 'E' (N)
        display_text[15:8]    = entered_password; // Value
        display_text[7:0]     = failed_attempts;  // Attempt count
        
    end
    else begin
        // ===== STANDBY - PROFESSIONAL WAITING =====
        // Row 0: "STATUS - STANDBY"
        display_text[127:120] = 8'd15;  // 'F' (S)
        display_text[119:112] = 8'd2;   // '2' (T)
        display_text[111:104] = 8'd10;  // 'A' (A)
        display_text[103:96]  = 8'd2;   // '2' (T)
        
        // Row 1: "USER ID: X"
        display_text[95:88]   = 8'd9;   // '9' (U)
        display_text[87:80]   = 8'd13;  // 'D' (D)
        display_text[79:72]   = user_id; // User ID value
        display_text[71:64]   = 8'd16;  // ' ' (space)
        
        // Row 2: "LOCKED - SECURE"
        display_text[63:56]   = 8'd13;  // 'D' (L)
        display_text[55:48]   = 8'd16;  // ' ' (space)
        display_text[47:40]   = 8'd12;  // 'C' (C)
        display_text[39:32]   = 8'd14;  // 'E' (E)
        
        // Row 3: "READY - WAITING"
        display_text[31:24]   = 8'd15;  // 'F' (R)
        display_text[23:16]   = 8'd16;  // ' ' (space)
        display_text[15:8]    = 8'd2;   // '2' (W)
        display_text[7:0]     = 8'd9;   // '9' (I)
    end
    
end

endmodule