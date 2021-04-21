%target cx16
%import textio
%import diskio
%import string
%import asmsymbols
%import filereader
%zeropage basicsafe
%option no_sysinit

main {

    sub start() {
        str filename = "?" * 20

        symbols.init()

        txt.print("\ncommander-x16 65c02 file based assembler. \x12work in progress\x92\nsource code: https://github.com/irmen/cx16assem\n\n")
        txt.print("enter filename to assemble, $ for list of *.asm files,\n!filename to display file, q to quit: ")
        repeat {
            txt.print("\n> ")
            if txt.input_chars(filename) {
                txt.print("\n\n")
                when filename[0] {
                    '$' -> list_asm_files()
                    '!' -> {
                        if filename[1]
                            display_file(&filename+1)
                    }
                    '*', ':' -> {
                        ; avoid loading the first file on the disk
                    }
                    'q' -> return
                    else -> {
                        file_input(filename)
                        break
                    }
                }
            }
        }
    }

    sub list_asm_files() {
        if diskio.lf_start_list(8, "*.asm") {
            while diskio.lf_next_entry() {
                txt.spc()
                txt.print_uw(diskio.list_blocks)
                txt.print(" blks")
                txt.column(11)
                txt.print(": ")
                txt.print(diskio.list_filename)
                txt.nl()
            }
            diskio.lf_end_list()
            return
        }
        txt.nl()
        txt.print(diskio.status(8))
    }

    sub display_file(uword filename) {
        txt.print("displaying ")
        txt.print(filename)
        txt.nl()
        cx16.rombank(0)     ; switch to kernal rom for faster file i/o
        ubyte success = false
        if diskio.f_open(8, filename) {
            uword line = 0
            repeat {
                void diskio.f_readline(parser.input_line)
                line++
                txt.print_uw(line)
                txt.column(5)
                txt.print(": ")
                txt.print(parser.input_line)
                txt.nl()
                if c64.READST() {
                    success = c64.READST()&64==64       ; end of file?
                    break
                }
                if c64.STOP2() {
                    txt.print("?break\n")
                    break
                }
            }
            diskio.f_close()
        } else {
            txt.print(diskio.status(8))
        }
        cx16.rombank(4)     ; switch back to basic rom
    }

    uword time_load
    uword time_phase1
    uword time_phase2

    sub file_input(uword filename) {

        txt.print("assembling ")
        txt.print(filename)
        txt.nl()
        cx16.rombank(0)     ; switch to kernal rom for faster file i/o
        c64.SETTIM(0,0,0)
        parser.start_phase(1)
        ubyte success = parse_file(filename)
        if success {
            time_phase1 = c64.RDTIM16()
            txt.print(" (")
            txt.print_uw(symbols.numsymbols())
            txt.print(" symbols)\n")

            ; TODO weg zodra phase1 hashtable volledig werkt incl updaten (dus geen dubbelen meer):
            symbols.dump(20)
            sys.exit(1)

            parser.start_phase(2)
            success = parse_file(filename)
        }
        parser.done()
        time_phase2 = c64.RDTIM16()
        txt.nl()
        symbols.dump(15)

        if success {
            print_summary(cx16.r15, parser.pc_min, parser.pc_max)
            save_program(parser.pc_min, parser.pc_max)
        }

        cx16.rombank(4)     ; switch back to basic rom
    }

    sub parse_file(uword filename) -> ubyte {
        ; returns success status, and last processed line number in cx16.r15

        if parser.phase==1 {
            if not filereader.read_file(filename) {
                txt.nl()
                txt.print(diskio.status(8))
                return false
            }
            time_load = c64.RDTIM16()
        }

        cx16.r15 = 0
        txt.print("parsing")
        filereader.start_get_lines()
        uword line = 0
        while filereader.next_line(parser.input_line) {
            line++
            if not lsb(line)
                txt.chrout('.')
            if not parser.process_line() {
                txt.print("\n\n\x12error.\x92\n last line #")
                txt.print_uw(line)
                txt.print(": ")
                txt.print(parser.word_addrs[0])
                if parser.word_addrs[1] {
                    txt.spc()
                    txt.print(parser.word_addrs[1])
                }
                if parser.word_addrs[2] {
                    txt.spc()
                    txt.print(parser.word_addrs[2])
                }
                txt.print("\n pc: ")
                txt.print_uwhex(parser.program_counter, true)
                txt.nl()
                return false
            }
        }
        return true
    }

    sub print_summary(uword lines, uword start_address, uword end_address) {
        txt.print("\n\n\x12complete.\x92\n\nstart address: ")
        txt.print_uwhex(start_address, 1)
        txt.print("\n  end address: ")
        txt.print_uwhex(end_address, 1)
        txt.print(" (")
        txt.print_uw(end_address-start_address)
        txt.print(" bytes)\n source lines: ")
        txt.print_uw(lines)

        txt.print("\n    load time: ")
        txt.print_uw(time_load)
        txt.print(" jf.\n phase 1 time: ")
        txt.print_uw(time_phase1-time_load)
        txt.print(" jf.\n phase 2 time: ")
        txt.print_uw(time_phase2-time_phase1)
        txt.print(" jf.\n   total time: ")
        txt.print_uw(time_phase2)
        txt.print(" jf.\n")
    }

    sub save_program(uword start_address, uword end_address) {
        txt.print("\nenter filename to save as (without .prg) > ")
        if txt.input_chars(main.start.filename) {
            txt.print("\nsaving...")
            diskio.delete(8, main.start.filename)
            if not diskio.save(8, main.start.filename, start_address, end_address-start_address) {
                txt.print(diskio.status(8))
            }
        }
    }
}

parser {
    ; byte counts per address mode id:
    ubyte[17] operand_size = [$ff, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 2, 1, 2]
    const ubyte max_line_length = 160

    str input_line = "?" * max_line_length
    uword[3] word_addrs
    uword program_counter = $ffff
    uword pc_min = $ffff
    uword pc_max = $0000
    ubyte phase             ; 1 = scan symbols, 2 = generate machine code

    sub start_phase(ubyte ph) {
        phase = ph
        input_line[0] = 0
        txt.print("phase ")
        txt.print_ub(phase)
        txt.spc()
    }

    sub process_line() -> ubyte {
        ; string.lower(input_line)
        preprocess_assignment_spacing()
        split_input()

        if word_addrs[1] and @(word_addrs[1])=='='
            return do_assign()
        else if @(word_addrs[0])=='.'
            return process_assembler_directive(word_addrs[0], word_addrs[1])
        else
            return do_label_instr()

        return false
    }

    sub done() {
        if program_counter>pc_max
            pc_max = program_counter
    }

    sub do_assign() -> ubyte {
        ; target is in word_addrs[0], value is in word_addrs[2]   ('=' is in word_addrs[1])
        if not word_addrs[2] {
            txt.print("?syntax error\n")
            return false
        }

        void string.lower(word_addrs[0])
        void string.lower(word_addrs[2])

        ubyte valid_operand=false
        if @(word_addrs[2])=='*' {
            cx16.r15 = program_counter
            valid_operand = true
        } else {
            ubyte nlen = conv.any2uword(word_addrs[2])
            valid_operand = nlen!=0 and @(word_addrs[2]+nlen)==0
        }

        if valid_operand {
            if str_is1(word_addrs[0], '*') {
                program_counter = cx16.r15
                if program_counter<pc_min
                    pc_min = program_counter
                if program_counter>pc_max
                    pc_max = program_counter
            } else if phase==1 {
                ubyte dt = symbols_dt.dt_ubyte
                if msb(cx16.r15)
                    dt = symbols_dt.dt_uword
                ubyte symbol_idx = symbols.setvalue(word_addrs[0], cx16.r15, dt)
                if not symbol_idx
                    return false
            }
            return true
        }
        txt.print("?invalid operand in assign\n")
        return false
    }

    sub do_label_instr() -> ubyte {
        uword label_ptr = 0
        uword instr_ptr = 0
        uword operand_ptr = 0
        ubyte starts_with_whitespace = input_line[0]==' ' or input_line[0]==9 or input_line[0]==160

        void string.lower(word_addrs[0])
        void string.lower(word_addrs[1])
        void string.lower(word_addrs[2])

        if word_addrs[2] {
            label_ptr = word_addrs[0]
            instr_ptr = word_addrs[1]
            operand_ptr = word_addrs[2]
        } else if word_addrs[1] {
            if starts_with_whitespace {
                instr_ptr = word_addrs[0]
                operand_ptr = word_addrs[1]
            } else {
                label_ptr = word_addrs[0]
                instr_ptr = word_addrs[1]
            }
        } else if word_addrs[0] {
            if starts_with_whitespace
                instr_ptr = word_addrs[0]
            else
                label_ptr = word_addrs[0]
        }

        if label_ptr {
            uword lastlabelchar = label_ptr + string.length(label_ptr)-1
            if @(lastlabelchar) == ':'
                @(lastlabelchar) = 0
            if instructions.match(label_ptr) {
                txt.print("?label cannot be a mnemonic\n")
                return false
            }
            if phase==1 {
                ubyte symbol_idx = symbols.setvalue(label_ptr, program_counter, symbols_dt.dt_uword)
                if not symbol_idx
                    return false
            }
        }
        if instr_ptr
            return assemble_instruction(instr_ptr, operand_ptr)

        return true     ; empty line
    }

    sub assemble_instruction(uword instr_ptr, uword operand_ptr) -> ubyte {
        uword instruction_info_ptr = instructions.match(instr_ptr)
        if instruction_info_ptr {
            ; we got a mnemonic match, now process the operand (and its value, if applicable, into cx16.r15)
            ubyte addr_mode = parse_operand(operand_ptr)

            ; TODO don't push it to find the correct opcode and branch Rel opcode if phase==1.

            if addr_mode {
                ubyte opcode = instructions.opcode(instruction_info_ptr, addr_mode)
                if_cc {
                    ; most likely an invalid instruction BUT could also be a branching instruction
                    ; that needs its "absolute" operand recalculated as relative.
                    ubyte retry = false
                    when addr_mode {
                        instructions.am_Abs -> {
                            if @(instr_ptr)=='b' {
                                addr_mode = instructions.am_Rel
                                if not calc_relative_branch_into_r14()
                                    return false
                                cx16.r15 = cx16.r14
                                retry = true
                            }
                        }
                        instructions.am_Imp -> {
                            addr_mode = instructions.am_Acc
                            retry = true
                        }
                        instructions.am_Izp -> {
                            addr_mode = instructions.am_Ind
                            retry = true
                        }
                        instructions.am_Zp -> {
                            addr_mode = instructions.am_Abs
                            retry = true
                        }
                    }

                    if retry
                        opcode = instructions.opcode(instruction_info_ptr, addr_mode)

                    if not opcode {
                        txt.print("?invalid instruction\n")
                        return false
                    }
                }

                if addr_mode==instructions.am_Zpr {
                    ; instructions like BBR4 $zp,$aaaa   (dual-operand)
                    uword comma = string.find(operand_ptr,',')
                    if comma {
                        comma++
                        cx16.r13 = cx16.r15
                        if parse_operand(comma) {
                            program_counter++
                            if not calc_relative_branch_into_r14()
                                return false
                            program_counter--
                            cx16.r15 = (cx16.r14 << 8) | lsb(cx16.r13)
                        } else {
                            txt.print("?invalid operand for zpr\n")
                            return false
                        }
                    } else {
                        txt.print("?invalid operand for zpr\n")
                        return false
                    }
                }

                ubyte num_operand_bytes = operand_size[addr_mode]
                when phase {
                    1 -> {
                        program_counter++
                        program_counter += num_operand_bytes
                    }
                    2 -> {
                        emit(opcode)
                        if num_operand_bytes==1 {
                            emit(lsb(cx16.r15))
                        } else if num_operand_bytes == 2 {
                            emit(lsb(cx16.r15))
                            emit(msb(cx16.r15))
                        }
                    }
                }
                return true
            }
            txt.print("?invalid operand\n")
            return false
        }
        txt.print("?invalid instruction\n")
        return false
    }

    sub calc_relative_branch_into_r14() -> ubyte {
        cx16.r14 = cx16.r15 - program_counter - 2
        if msb(cx16.r14)  {
            if cx16.r14 < $ff80 {
                txt.print("?branch out of range\n")
                return false
            }
        } else if cx16.r14 > $007f {
            txt.print("?branch out of range\n")
            return false
        }
        return true
    }

    sub parse_operand(uword operand_ptr) -> ubyte {
        ; parses the operand. Returns 2 things:
        ; - addressing mode id as result value or 0 (am_Invalid) when error
        ; - operand numeric value in cx16.r15 (if applicable)

        if operand_ptr==0
            return instructions.am_Imp

        uword sym_ptr
        ubyte @zp firstchr = @(operand_ptr)
        ubyte parsed_len
        when firstchr {
            0 -> return instructions.am_Imp
            '#' -> {
                ; lda #$99   Immediate
                operand_ptr++
                ubyte lsbmsb = @(operand_ptr)
                if lsbmsb=='<' or lsbmsb=='>' {
                    operand_ptr++
                } else {
                    lsbmsb = 0
                }
                parsed_len = conv.any2uword(operand_ptr)
                if parsed_len {
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
                            err_undefined_symbol(operand_ptr)
                            return instructions.am_Invalid
                        }
                    }
                    return instructions.am_Imm
                }
                return instructions.am_Invalid
            }
            'a' -> {
                if not @(operand_ptr+1)
                    return instructions.am_Acc      ; Accumulator - no value.
                sym_ptr = operand_ptr
                ; fall through to deal with a symbol as an operand (absolute address)
            }
            '(' -> {
                ; various forms of indirect
                operand_ptr++
                parsed_len = conv.any2uword(operand_ptr)
                if parsed_len {
                    return operand_determine_indirect_addrmode(operand_ptr + parsed_len)
                } else {
                    sym_ptr = operand_ptr
                    parsed_len = 0
                    while is_symbol_char(@(operand_ptr)) {
                        operand_ptr++
                        parsed_len++
                    }
                    if symbols.getvalue2(sym_ptr, parsed_len) {
                        cx16.r15 = cx16.r0
                        return operand_determine_indirect_addrmode(operand_ptr)
                    } else {
                        err_undefined_symbol(sym_ptr)
                    }
                }
                return instructions.am_Invalid
            }
            '$', '%', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' -> {
                ; address optionally followed by ,x or ,y or ,address
                parsed_len = conv.any2uword(operand_ptr)
                if parsed_len
                    return operand_determine_abs_or_zp_addrmode(operand_ptr + parsed_len)
                return instructions.am_Invalid
            }
            else -> sym_ptr = operand_ptr
        }

        ; if we end up here, it wasn't a recognisable numeric operand.
        ; so it must be a symbol, and the addressing mode is Abs, AbsX, AbsY (for words), Zp, ZpX, ZpY (for bytes).

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
                    cx16.r15 = program_counter  ; to avoid branch Rel errors
                    ubyte symbol_idx = symbols.setvalue2(sym_ptr, parsed_len, cx16.r15, symbols_dt.dt_uword_placeholder)
                    if not symbol_idx
                        return instructions.am_Invalid
                    return operand_determine_abs_or_zp_addrmode(operand_ptr)
                }
                if phase==2 {
                    err_undefined_symbol(sym_ptr)
                    return instructions.am_Invalid
                }
            }
            return instructions.am_Invalid
        }

        return instructions.am_Invalid
    }

    sub operand_determine_abs_or_zp_addrmode(uword scan_ptr) -> ubyte {
        if msb(cx16.r15) {
            ; word value, so absolute or abs indexed
            if @(scan_ptr)==0
                return instructions.am_Abs
            if str_is2(scan_ptr, ",x")
                return instructions.am_AbsX
            if str_is2(scan_ptr, ",y")
                return instructions.am_AbsY
        } else {
            ; byte value, so zero page or zp indexed
            if @(scan_ptr)==0
                return instructions.am_Zp
            if str_is2(scan_ptr, ",x")
                return instructions.am_ZpX
            if str_is2(scan_ptr, ",y")
                return instructions.am_ZpY
            if @(scan_ptr)==',' {
                ; assume BBR $zp,$aaaa or BBS $zp,$aaaa
                return instructions.am_Zpr
            }
        }
        return instructions.am_Invalid
    }

    sub operand_determine_indirect_addrmode(uword scan_ptr) -> ubyte {
        if msb(cx16.r15) {
            ; absolute indirects
            if str_is1(scan_ptr, ')')
                return instructions.am_Ind
            if str_is3(scan_ptr, ",x)")
                return instructions.am_IaX
        } else {
            ; zero page indirects
            if str_is1(scan_ptr, ')')
                return instructions.am_Izp
            if str_is3(scan_ptr, ",x)")
                return instructions.am_IzX
            if str_is3(scan_ptr, "),y")
                return instructions.am_IzY
        }

        return instructions.am_Invalid
    }

    sub err_undefined_symbol(uword symbol) {
        txt.print("\n?undefined symbol: ")
        txt.print(symbol)
        txt.nl()
    }

; this is rewritten in assembly because of inner loop optimizations
;    sub is_symbol_start_char(ubyte chr) -> ubyte {
;        ; note: chr is already lowercased
;        if chr>='a' and chr <= 'z'
;            return true
;        return chr=='.' or chr=='@'
;    }

    asmsub is_symbol_start_char(ubyte chr @A) -> ubyte @A {
        ; note: chr is already lowercased
        %asm {{
            cmp  #'.'
            beq  _yes
            cmp  #'@'
            beq  _yes
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

; this is rewritten in assembly because of inner loop optimizations
;    sub is_symbol_char(ubyte chr) -> ubyte {
;        if chr>='0' and chr <= '9'
;            return true
;        return is_symbol_start_char(chr)
;    }

    asmsub is_symbol_char(ubyte chr @A) -> ubyte @A {
        %asm {{
            cmp  #'0'
            bcc  is_symbol_start_char
            cmp  #'9'+1
            bcs  is_symbol_start_char
            lda  #1
            rts
        }}
    }

    sub process_assembler_directive(uword directive, uword operand) -> ubyte {
        ; we only recognise .byte and .str right now
        void string.lower(directive)
        if string.compare(directive, ".byte")==0 {
            if operand {
                ubyte length = conv.any2uword(operand)
                if length {
                    if msb(cx16.r15) {
                        txt.print("?byte value too large\n")
                        return false
                    }
                    if phase==2
                        emit(lsb(cx16.r15))
                    else
                        program_counter++
                    operand += length
                    operand = str_trimleft(operand)
                    while @(operand)==',' {
                        operand++
                        operand = str_trimleft(operand)
                        length = conv.any2uword(operand)
                        if not length
                            break
                        if msb(cx16.r15) {
                            txt.print("?byte value too large\n")
                            return false
                        }
                        if phase==2
                            emit(lsb(cx16.r15))
                        else
                            program_counter++
                        operand += length
                    }
                    return true
                }
            }
        }
        else if string.compare(directive, ".str")==0 {
            if operand and operand[0]=='\"' {
                operand++
                ubyte char_idx=0
                repeat {
                    ubyte char = @(operand+char_idx)
                    when char {
                        '\"', 0 -> return true
                        else -> {
                            if phase==2
                                emit(char)
                            else
                                program_counter++
                        }
                    }
                    char_idx++
                }
            }
        }

        txt.print("?syntax error\n")
        return false
    }

    asmsub str_is1(uword st @R0, ubyte char @A) clobbers(Y) -> ubyte @A {
        %asm {{
            cmp  (cx16.r0)
            bne  +
            ldy  #1
            lda  (cx16.r0),y
            bne  +
            lda  #1
            rts
+           lda  #0
            rts
        }}
    }

    asmsub str_is2(uword st @R0, uword compare @AY) clobbers(Y) -> ubyte @A {
        %asm {{
            sta  P8ZP_SCRATCH_W1
            sty  P8ZP_SCRATCH_W1+1
            ldy  #0
            jmp  str_is3._is_2_entry
        }}
    }

    asmsub str_is3(uword st @R0, uword compare @AY) clobbers(Y) -> ubyte @A {
        %asm {{
            sta  P8ZP_SCRATCH_W1
            sty  P8ZP_SCRATCH_W1+1
            lda  (cx16.r0)
            cmp  (P8ZP_SCRATCH_W1)
            bne  +
            ldy  #1
_is_2_entry
            lda  (cx16.r0),y
            cmp  (P8ZP_SCRATCH_W1),y
            bne  +
            iny
            lda  (cx16.r0),y
            cmp  (P8ZP_SCRATCH_W1),y
            bne  +
            iny
            lda  (cx16.r0),y
            bne  +
            lda  #1
            rts
+           lda  #0
            rts
        }}
    }

    sub str_trimleft(uword st) -> uword {
        repeat {
            when @(st) {
                ' ', 9, 160 -> st++
                else -> return st
            }
        }
        return 0
    }

    sub emit(ubyte value) {
        @(program_counter) = value
        program_counter++
    }

    sub split_input() {
        ubyte word_count = 0
        ubyte @zp char_idx = 0
        word_addrs[0] = 0
        word_addrs[1] = 0
        word_addrs[2] = 0

        uword trimmed = str_trimleft(input_line)
        if @(trimmed) == '.' {
            ; line is directive
            word_addrs[0] = trimmed
            word_count=2
            repeat {
                when trimmed[char_idx] {
                    ' ', 0, 9, 160 -> {
                        trimmed += char_idx
                        @(trimmed) = 0
                        trimmed++
                        word_addrs[1] = str_trimleft(trimmed)
                        return
                    }
                    else -> {
                        char_idx++
                    }
                }
            }
        }

        ubyte copying_word = false
        char_idx = 0
        ubyte @zp char
        repeat {
            char = trimmed[char_idx]
            when char {
                ' ', 9, 160 -> {
                    if copying_word
                        trimmed[char_idx] = 0; terminate word
                    copying_word = false
                }
                ';', 0 -> {
                    ; terminate line on comment char or end-of-string
                    break
                }
                else -> {
                    if not copying_word {
                        if word_count==3
                            break
                        word_addrs[word_count] = trimmed + char_idx
                        word_count++
                    }
                    copying_word = true
                }
            }
            char_idx++
        }

        char = trimmed[char_idx]
        if char==' ' or char==9 or char==160 or char==';'
            trimmed[char_idx] = 0
    }

    sub debug_print_words() {        ; TODO remove
        txt.print("(debug:) words: ")
        uword word_ptr
        for word_ptr in word_addrs {
            txt.chrout('[')
            txt.print(word_ptr)
            txt.print("] ")
        }
        txt.nl()
    }

    sub preprocess_assignment_spacing() {
        if not string.find(input_line, '=')
            return

        ; split the line around the '='
        str input_line2 = "?" * max_line_length
        uword src = &input_line
        uword dest = &input_line2
        ubyte @zp cc
        for cc in input_line {
            if cc=='=' {
                @(dest) = ' '
                dest++
                @(dest) = '='
                dest++
                cc = ' '
            }
            @(dest) = cc
            dest++
        }
        @(dest)=0
        void string.copy(input_line2, src)
    }
}


instructions {
    const ubyte am_Invalid = 0
    const ubyte am_Imp = 1
    const ubyte am_Acc = 2
    const ubyte am_Imm = 3
    const ubyte am_Zp = 4
    const ubyte am_ZpX = 5
    const ubyte am_ZpY = 6
    const ubyte am_Rel = 7
    const ubyte am_Abs = 8
    const ubyte am_AbsX = 9
    const ubyte am_AbsY = 10
    const ubyte am_Ind = 11
    const ubyte am_IzX = 12
    const ubyte am_IzY = 13
    const ubyte am_Zpr = 14
    const ubyte am_Izp = 15
    const ubyte am_IaX = 16

    ; TODO: explore (benchmark) hash based matchers.   Faster? (although the bulk of the time is not in the mnemonic matching)? Less memory/smaller program?

    asmsub  match(uword mnemonic_ptr @AY) -> uword @AY {
        ; -- input: mnemonic_ptr in AY,   output:  pointer to instruction info structure or $0000 in AY
        %asm {{
            phx
            sta  P8ZP_SCRATCH_W1
            sty  P8ZP_SCRATCH_W1+1
            ldy  #1
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            tax             ; second letter in X
            iny
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            pha             ; save 3rd letter
            iny
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            sta  cx16.r4    ; fourth letter in R4 (only exists for the few 4-letter mnemonics)
            iny
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            sta  cx16.r5    ; fifth letter in R5 (should always be zero or whitespace for a valid mnemonic)
            ply             ; third letter in Y
            lda  (P8ZP_SCRATCH_W1)
            and  #$7f       ; lowercase, first letter in A
            jsr  get_opcode_info
            plx
            rts
        }}
    }

    asmsub  opcode(uword instr_info_ptr @AY, ubyte addr_mode @X) clobbers(X) -> ubyte @A, ubyte @Pc {
        ; -- input: instruction info struct ptr @AY,  desired addr_mode @X
        ;    output: opcode @A,   valid @carrybit
        %asm {{
            cpy  #0
            beq  _not_found
            sta  P8ZP_SCRATCH_W2
            sty  P8ZP_SCRATCH_W2+1
            stx  cx16.r5

            ; debug result address
            ;sec
            ;jsr  txt.print_uwhex
            ;lda  #13
            ;jsr  c64.CHROUT

            lda  (P8ZP_SCRATCH_W2)
            beq  _multi_addrmodes
            ldy  #1
            lda  (P8ZP_SCRATCH_W2),y
            cmp  cx16.r5               ; check single possible addr.mode
            bne  _not_found
            iny
            lda  (P8ZP_SCRATCH_W2),y    ; get opcode
            sec
            rts

_not_found  lda  #0
            clc
            rts

_multi_addrmodes
            ldy  cx16.r5
            lda  (P8ZP_SCRATCH_W2),y    ; check opcode for addr.mode
            bne  _valid
            ; opcode $00 usually means 'invalid' but for "brk" it is actually valid so check for "brk"
            lda  (P8ZP_SCRATCH_W1)
            and  #$7f       ; lowercase
            cmp  #'b'
            bne  _not_found
            ldy  #1
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            cmp  #'r'
            bne  _not_found
            iny
            lda  (P8ZP_SCRATCH_W1),y
            and  #$7f       ; lowercase
            cmp  #'k'
            bne  _not_found
            lda  #0
_valid      sec
            rts
        }}
    }

    ; The actual mnemonic matching routine is automatically generated
    ; from a table of mnemonics.
    ; Currently this is a prefix-tree matching routine that expects
    ; the three letters of the mnemonic to be in registers A,X,Y
    ; which covers most of the instructions (only a few have 4 letters)
    %asminclude "opcodes.asm", ""
}
