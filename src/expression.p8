%import conv
%import asmoutput
%import instructions

expression {

    sub parse_operand(str operand, ubyte phase) -> ubyte {
        ; parses the operand. Returns 2 things:
        ; - addressing mode id as result value or 0 (am_Invalid) when error
        ; - operand numeric value in cx16.r15 (if applicable)

        if operand==0
            return instructions.am_Imp
            
        uword @requirezp operand_ptr = operand
        uword @requirezp sym_ptr
        ubyte @zp firstchr = @(operand_ptr)
        ubyte @zp parsed_len
        when firstchr {
            0 -> return instructions.am_Imp
            '#' -> {
                ; lda #$99   Immediate
                operand_ptr++
                ubyte lsbmsb = @(operand_ptr)
                when lsbmsb {
                    '<', '>' -> operand_ptr++
                    else -> lsbmsb = 0
                }
                ; TODO parse rest of operand as an *expression* (in phase 2, should look up any symbols used)
                parsed_len = conv.any2uword(operand_ptr)
                if parsed_len!=0 {
                    operand_ptr += parsed_len
                    if @(operand_ptr)==0 {
                        if lsbmsb=='>'
                            cx16.r15 = msb(cx16.r15)
                        return instructions.am_Imm
                    }
                } else {
                    if phase==2 {
                        ; retrieve symbol value
                        if symbols.getvalue(operand_ptr) {
                            cx16.r1 = symbols_dt.dt_ubyte
                            if lsbmsb=='>'
                                cx16.r15 = msb(cx16.r0)
                            else
                                cx16.r15 = lsb(cx16.r0)
                        } else {
                            err.print2("undefined symbol:", operand_ptr)
                            return instructions.am_Invalid
                        }
                    }
                    return instructions.am_Imm
                }
                return instructions.am_Invalid
            }
            'a','A' -> {
                if @(operand_ptr+1)==0
                    return instructions.am_Acc      ; Accumulator - no value.
                sym_ptr = operand_ptr
                ; continue after this to deal with a symbol as an operand (absolute address)
            }
            '(' -> {
                ; various forms of indirect
                operand_ptr++
                ; TODO parse rest of operand as an *expression* with closing parenthesis at the end (in phase 2, should look up any symbols used)
                parsed_len = conv.any2uword(operand_ptr)
                if parsed_len!=0
                    return operand_determine_indirect_addrmode(operand_ptr + parsed_len)

                sym_ptr = operand_ptr
                parsed_len = 0
                while is_symbol_char(@(operand_ptr)) {
                    operand_ptr++
                    parsed_len++
                }
                if symbols.getvalue2(sym_ptr, parsed_len) {
                    cx16.r15 = cx16.r0
                    return operand_determine_indirect_addrmode(operand_ptr)
                }
                err.print2("undefined symbol:", sym_ptr)
                return instructions.am_Invalid
            }
            '$', '%', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' -> {
                ; address optionally followed by ,x or ,y or ,address
                ; TODO parse rest of operand as an *expression*, optionally followed by that suffix (in phase 2, should look up any symbols used)
                parsed_len = conv.any2uword(operand_ptr)
                if parsed_len!=0
                    return operand_determine_abs_or_zp_addrmode(operand_ptr + parsed_len)
                return instructions.am_Invalid
            }
            '*' -> {
                ; current program counter as absolute address
                cx16.r15 = output.program_counter
                return instructions.am_Abs
            }
            else -> sym_ptr = operand_ptr
        }

        ; if we end up here, it wasn't a recognisable numeric operand.
        ; so it must be a symbol, and the addressing mode is Abs, AbsX, AbsY (for words), Zp, ZpX, ZpY (for bytes).
        ; TODO treat it as an *expression* (in phase 2, should look up any symbols used)

        operand_ptr = sym_ptr
        if is_symbol_start_char(firstchr) {
            operand_ptr++
            parsed_len = 1
            while is_symbol_char(@(operand_ptr)) {
                operand_ptr++
                parsed_len++
            }

            ; Process symbol.
            ;  if it's defined: substitute the value
            ;  if it's not defined: error (if in phase 2) or skip (if in phase 1)
            if symbols.getvalue2(sym_ptr, parsed_len) {
                cx16.r15 = cx16.r0
                return operand_determine_abs_or_zp_addrmode(operand_ptr)
            } else {
                if phase==1 {
                    ; the symbol is undefined in phase 1.
                    ; enter it in the symbol table preliminary, and assume it is a word datatype.
                    ; (if that is not correct, the symbol should be defined before use to correct this...)
                    cx16.r15 = output.program_counter  ; to avoid branch Rel errors
                    bool success = symbols.setvalue2(sym_ptr, parsed_len, cx16.r15, symbols_dt.dt_uword_placeholder)
                    if not success
                        return instructions.am_Invalid
                    return operand_determine_abs_or_zp_addrmode(operand_ptr)
                }
                if phase==2 {
                    err.print2("undefined symbol:", sym_ptr)
                    return instructions.am_Invalid
                }
            }
            return instructions.am_Invalid
        }

        return instructions.am_Invalid
    }

    sub parse_expression(str expr, ubyte phase) -> bool {
        ; TODO parse a simple expression:
        ;   value   (can be number or symbol)
        ;   value <oper> value  (operator +/-/*/<</>>)
        ; returns success and value in cx16.r15
        uword @requirezp expr_ptr = expr

        sub parse_single_value() -> ubyte {
            ; this parses a single number or symbol into cx16.r15, returns 0 if fail or else number of consumed characters
            when(@(expr_ptr)) {
                '$', '%', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' -> {
                    ; hex bin or decimal number
                    return conv.any2uword(expr_ptr)
                }
                '*' -> {
                    ; current program counter value
                    cx16.r15 = output.program_counter
                    return 1
                }
                else -> {
                    ; TODO check for symbol, phase 1/2 difference
                    err.print2("invalid expression:", expr_ptr)
                    return 0
                }
            }
        }
    }

    sub operand_determine_indirect_addrmode(uword scan_ptr) -> ubyte {
        if msb(cx16.r15)!=0 {
            ; absolute indirects
            if parser.str_is1(scan_ptr, ')')
                return instructions.am_Ind
            if parser.str_is3(scan_ptr, ",x)")
                return instructions.am_IaX
        } else {
            ; zero page indirects
            if parser.str_is1(scan_ptr, ')')
                return instructions.am_Izp
            if parser.str_is3(scan_ptr, ",x)")
                return instructions.am_IzX
            if parser.str_is3(scan_ptr, "),y")
                return instructions.am_IzY
        }

        return instructions.am_Invalid
    }

    sub operand_determine_abs_or_zp_addrmode(uword scan_ptr) -> ubyte {
        if msb(cx16.r15)!=0 {
            ; word value, so absolute or abs indexed
            if @(scan_ptr)==0
                return instructions.am_Abs
            if parser.str_is2(scan_ptr, ",x")
                return instructions.am_AbsX
            if parser.str_is2(scan_ptr, ",y")
                return instructions.am_AbsY
        } else {
            ; byte value, so zero page or zp indexed
            if @(scan_ptr)==0
                return instructions.am_Zp
            if parser.str_is2(scan_ptr, ",x")
                return instructions.am_ZpX
            if parser.str_is2(scan_ptr, ",y")
                return instructions.am_ZpY
            if @(scan_ptr)==',' {
                ; assume BBR $zp,$aaaa or BBS $zp,$aaaa
                return instructions.am_Zpr
            }
        }
        return instructions.am_Invalid
    }

; this is rewritten in assembly because of inner loop optimizations
;    sub is_symbol_char(ubyte chr) -> ubyte {
;        if chr>='0' and chr <= '9'
;            return true
;        return is_symbol_start_char(chr)
;    }
    asmsub is_symbol_char(ubyte chr @A) -> bool @A {
        %asm {{
            cmp  #'0'
            bcc  p8s_is_symbol_start_char
            cmp  #'9'+1
            bcs  p8s_is_symbol_start_char
            lda  #1
            rts
        }}
    }

; this is rewritten in assembly because of inner loop optimizations
;    sub is_symbol_start_char(ubyte chr) -> ubyte {
;        ; note: chr is not lowercased yet
;        chr &= $7f
;        if chr>='a' and chr <= 'z'
;            return true
;        return chr=='.' or chr=='@'
;    }
    asmsub is_symbol_start_char(ubyte chr @A) -> bool @A {
        %asm {{
            cmp  #'.'
            beq  _yes
            cmp  #'@'
            beq  _yes
            jsr  string.lowerchar
            cmp  #'a'
            bcc  _no
            cmp  #'z'+1
            bcc  _yes
_no         lda  #0
            rts
_yes        lda  #1
            rts
        }}
    }
}
