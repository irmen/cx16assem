%import textio
%import diskio
%import string
%import asmsymbols
%import asmoutput
%import filereader
%import instructions
%import errors
%zeropage basicsafe

main {

    ubyte drivenumber = 8
    ubyte text_color = 1
    ubyte background_color = 11

    sub start() {
        str commandline = "?" * 20
        print_intro()
        diskio.filename[0] = 0
        repeat {
            if background_color==13
                txt.color(0)
            else
                txt.color(13)
            txt.print("\n> ")
            txt.color(text_color)
            if txt.input_chars(commandline) {
                txt.print("\n\n")
                uword argptr = 0
                if commandline[1]
                    argptr = &commandline+1
                if commandline[1]==' ' and commandline[2]
                    argptr = &commandline+2
                when commandline[0] {
                    '$' -> list_asm_files()
                    'd' -> {
                        if argptr
                            display_file(argptr)
                    }
                    'e' -> {
                        if argptr
                            edit_file(argptr)
                        else
                            edit_file(0)
                        print_intro()
                    }
                    'a' -> {
                        if argptr {
                            symbols.init()
                            filereader.init()
                            diskio.filename[0] = 0
                            file_input(argptr)
                        }
                    }
                    '#' -> {
                        if argptr {
                            set_drivenumber(argptr[0]-'0')
                        } else {
                            txt.print("current disk drive is ")
                            txt.print_ub(drivenumber)
                            txt.nl()
                        }
                    }
                    't' -> {
                        text_color++
                        if text_color==background_color
                            text_color++
                        text_color &= 15
                    }
                    'b' -> {
                        background_color++
                        if text_color==background_color
                            background_color++
                        background_color &= 15
                        print_intro()
                    }
                    'r' -> {
                        if argptr
                            string.copy(argptr, diskio.filename)
                        if diskio.filename[0]
                            run_file(diskio.filename)
                        else
                            err.print("no previous filename")
                    }
                    '?', 'h' -> print_intro()
                    'q', 'x' -> return
                    else -> err.print("invalid command")
                }
            }
        }
    }

    sub print_intro() {
        txt.color2(text_color, background_color)
        txt.clear_screen()
        txt.lowercase()
        if background_color==13
            txt.color(0)
        else
            txt.color(13)

        txt.print("\n\x12Commander-x16 65c02 file based assembler\x92\n https://github.com/irmen/cx16assem\n\n")
        txt.color(text_color)
        txt.print("Available commands:\n\n" +
        "  $            - lists *.asm files on disk\n" +
        "  a <filename> - assemble file\n" +
        "  d <filename> - display contents of file\n" +
        "  e <filename> - start x16edit in rom bank 7 on file\n")
        txt.print("  r <filename> - load and run file, use previously saved file if unspecified\n" +
        "  # <number>   - select disk device number (8 or 9, default=8)\n" +
        "  t            - cycle text color\n" +
        "  b            - cycle background color\n")
        txt.print("  ? or h       - print this help.\n" +
        "  q or x       - quit to basic.\n")
    }

    sub run_file(str filename) {
        txt.print("loading: ")
        txt.print(filename)
        txt.print(".prg ")
        ; TODO check if program would overwrite the assembler if loaded.
        ;      but we currently only have the progend() which includes all bss allocated memory...
        if diskio.f_open(drivenumber, filename) {
            uword load_address
            void diskio.f_read(&load_address, 2)
            diskio.f_close()
            txt.print_uwhex(load_address, true)
            txt.chrout('-')
            uword end_address = diskio.load(drivenumber, filename, 0)
            if end_address {
                txt.print_uwhex(end_address, true)
                txt.nl()
                txt.nl()
                %asm {{
                    lda  #<_continue-1
                    pha
                    lda  #>_continue-1
                    pha
                    jmp  (load_address)
_continue
                }}
            }
        } else {
            txt.print(diskio.status(drivenumber))
        }

        txt.nl()
    }

    sub set_drivenumber(ubyte nr) {
        if nr==8 or nr==9 {
            drivenumber = nr
            txt.print("selected disk drive ")
            txt.print_ub(drivenumber)
            txt.nl()
        }
        else {
            err.print("invalid drive number")
        }
    }

    sub edit_file(uword filename) {
        ; activate x16edit, assumed to be in rom bank 7,
        ;   see https://github.com/stefan-b-jakobsson/x16-edit/tree/master/docs
        cx16.rombank(7)
        cx16.r1H = %00000001        ; enable auto-indent
        cx16.r2L = 4
        cx16.r2H = 80
        cx16.r3L = drivenumber
        cx16.r3H = background_color<<4 | text_color
        cx16.r4 = 0                 ; choose default colors for status bar and headers
        if filename {
            cx16.r0 = filename
            cx16.r1L = string.length(filename)
            %asm {{
                phx
                ldx  #1
                ldy  #255
                jsr  $c006
                plx
            }}
        } else {
            cx16.r1L = 0
            %asm {{
                phx
                ldx  #1
                ldy  #255
                jsr  $c006
                plx
            }}
        }
        cx16.rombank(4)
    }

    sub list_asm_files() {
        if diskio.lf_start_list(drivenumber, "*.asm") {
            txt.print("*.asm files on drive ")
            txt.print_ub(drivenumber)
            txt.print(":\n\n")
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
        txt.print(diskio.status(drivenumber))
    }

    sub display_file(uword filename) {
        txt.print("displaying ")
        txt.print(filename)
        txt.nl()
        cx16.rombank(0)     ; switch to kernal rom for faster file i/o
        ubyte success = false
        if diskio.f_open(drivenumber, filename) {
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
                    err.print("break")
                    break
                }
            }
            diskio.f_close()
        } else {
            txt.print(diskio.status(drivenumber))
        }
        cx16.rombank(4)     ; switch back to basic rom
    }

    uword time_load
    uword time_phase1
    uword time_phase2

    sub file_input(uword filename) {

        txt.print("\x12assembling ")
        txt.print(filename)
        txt.print("\x92\n")
        cx16.rombank(0)     ; switch to kernal rom for faster file i/o
        c64.SETTIM(0,0,0)
        parser.start_phase(1)
        ubyte success = parse_file(filename)
        if success {
            time_phase1 = c64.RDTIM16()
            txt.print(" (")
            txt.print_uw(symbols.numsymbols())
            txt.print(" symbols)\n")

            ; print some debug info from phase 1
            symbols.dump(15)
            fileregistry.dump()
            txt.nl()

            parser.start_phase(2)
            success = parse_file(filename)
        }
        parser.done()
        time_phase2 = c64.RDTIM16()

        if success {
            print_summary(cx16.r15, output.pc_min, output.pc_max)
            save_program(output.pc_min, output.pc_max)
            txt.nl()
        }

        cx16.rombank(4)     ; switch back to basic rom
    }

    sub parse_file(uword filename) -> ubyte {
        ; returns success status, and last processed line number in cx16.r15

        if parser.phase==1 {
            if not filereader.read_file(drivenumber, filename) {
                txt.nl()
                txt.print(diskio.status(drivenumber))
                return false
            }
            time_load = c64.RDTIM16()
        }

        cx16.r15 = 0
        txt.print("parsing...")
        if not filereader.start_get_lines(filename) {
            err.print("can't read lines")
            return false
        }

        while filereader.next_line(parser.input_line) {
            if not parser.process_line() {
                txt.print("\n\n\x12error.\x92\n last line #")
                txt.print_uw(filereader.get_line_nr())
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
                txt.print_uwhex(output.program_counter, true)
                txt.nl()
                return false
            }
        }
        if filereader.get_line_nr()==0 {
            err.print("no lines in file")
            return false
        }

        cx16.r15 = filereader.get_line_nr()
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
        txt.print(" jf = ")
        time_phase2 /= 6
        uword seconds = time_phase2 / 10
        time_phase2 -= seconds*10
        txt.print_uw(seconds)
        txt.chrout('.')
        txt.print_uw(time_phase2)
        txt.print(" seconds.\n")
    }

    sub save_program(uword start_address, uword end_address) {

        txt.print("\nenter filename to save as (without .prg) > ")
        if txt.input_chars(main.start.commandline) {
            txt.print("\nsaving...")
            diskio.delete(drivenumber, main.start.commandline)

            if diskio.f_open_w(drivenumber, main.start.commandline) {
                ubyte[2] prgheader
                prgheader[0] = lsb(start_address)
                prgheader[1] = msb(start_address)
                if not diskio.f_write(&prgheader, len(prgheader))
                    goto io_error

                uword remaining = end_address-start_address
                ubyte bnk
                for bnk in output.start_output_bank to output.next_output_bank-1 {
                    cx16.rambank(bnk)
                    uword savesize = remaining
                    if savesize > 8192
                        savesize = 8192
                    if not diskio.f_write($a000, savesize)
                        goto io_error
                    remaining -= savesize
                    if remaining==0
                        break
                    ; note: we cannot print characters to the screen here (without switching i/o channels)
                }

                diskio.f_close_w()
                diskio.filename = main.start.commandline      ; keep the filename we just saved to
                return
            }

io_error:
            txt.print(diskio.status(drivenumber))

;            if not diskio.save(drivenumber, main.start.filename, start_address, end_address-start_address) {
;                txt.print(diskio.status(drivenumber))
;            }
        }
    }
}

parser {
    ; byte counts per address mode id:
    ubyte[17] operand_size = [$ff, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 2, 1, 2]
    const ubyte max_line_length = 80

    str input_line = "?" * max_line_length
    uword[3] word_addrs
    ubyte phase             ; 1 = scan symbols, 2 = generate machine code

    sub start_phase(ubyte ph) {
        phase = ph
        input_line[0] = 0
        txt.print("phase ")
        txt.print_ub(phase)
        txt.spc()

        output.init(ph)
    }

    sub process_line() -> ubyte {
        preprocess_assignment_spacing()
        split_input()

        if @(word_addrs[0])=='.'
            return process_assembler_directive(word_addrs[0], word_addrs[1])
        if not word_addrs[1]
            return do_label_instr()
        if @(word_addrs[1])=='='
            return do_assign()
        return do_label_instr()
    }

    sub done() {
        output.done()
    }

    sub do_assign() -> ubyte {
        ; target is in word_addrs[0], value is in word_addrs[2]   ('=' is in word_addrs[1])
        if not word_addrs[2] {
            err.print("syntax error")
            return false
        }

        ;void string.lower(word_addrs[0])
        ;void string.lower(word_addrs[2])

        ubyte valid_operand=false
        if @(word_addrs[2])=='*' {
            cx16.r15 = output.program_counter
            valid_operand = true
        } else {
            ubyte nlen = conv.any2uword(word_addrs[2])
            valid_operand = nlen!=0 and @(word_addrs[2]+nlen)==0
        }

        if valid_operand {
            if str_is1(word_addrs[0], '*') {
                output.set_pc(cx16.r15)
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
        err.print("invalid operand in assign")
        return false
    }

    sub do_label_instr() -> ubyte {
        uword label_ptr = 0
        uword instr_ptr = 0
        uword operand_ptr = 0
        ubyte starts_with_whitespace = input_line[0]==' ' or input_line[0]==9 or input_line[0]==160

;        void string.lower(word_addrs[0])
;        void string.lower(word_addrs[1])
;        void string.lower(word_addrs[2])

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
                err.print("label cannot be an instruction")
                return false
            }
            if phase==1 {
                ubyte symbol_idx = symbols.setvalue(label_ptr, output.program_counter, symbols_dt.dt_uword)
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
                                retry = true
                                if phase==2 {
                                    if not calc_relative_branch_into_r14()
                                        return false
                                    cx16.r15 = cx16.r14
                                }
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
                        err.print("invalid instruction")
                        return false
                    }
                }

                if phase==2 {
                    if addr_mode==instructions.am_Zpr {
                        ; instructions like BBR4 $zp,$aaaa   (dual-operand)
                        uword comma = string.find(operand_ptr,',')
                        if comma {
                            comma++
                            cx16.r13 = cx16.r15
                            if parse_operand(comma) {
                                output.program_counter++
                                if not calc_relative_branch_into_r14()
                                    return false
                                output.program_counter--
                                cx16.r15 = (cx16.r14 << 8) | lsb(cx16.r13)
                            } else {
                                err.print("invalid operand for zpr")
                                return false
                            }
                        } else {
                            err.print("invalid operand for zpr")
                            return false
                        }
                    }
                }

                ubyte num_operand_bytes = operand_size[addr_mode]
                when phase {
                    1 -> {
                        output.inc_pc(num_operand_bytes)
                    }
                    2 -> {
                        output.emit(opcode)
                        if num_operand_bytes==1 {
                            output.emit(lsb(cx16.r15))
                        } else if num_operand_bytes == 2 {
                            output.emit(lsb(cx16.r15))
                            output.emit(msb(cx16.r15))
                        }
                    }
                }
                return true
            }
            err.print("invalid operand")
            return false
        }
        err.print("invalid instruction")
        return false
    }

    sub calc_relative_branch_into_r14() -> ubyte {
        cx16.r14 = cx16.r15 - output.program_counter - 2
        if msb(cx16.r14)  {
            if cx16.r14 < $ff80 {
                err.print("branch out of range")
                return false
            }
        } else if cx16.r14 > $007f {
            err.print("branch out of range")
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
                            err.print2("undefined symbol:", operand_ptr)
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
                        err.print2("undefined symbol:", sym_ptr)
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
                    cx16.r15 = output.program_counter  ; to avoid branch Rel errors
                    ; we know the symbol isn't defined yet so just set a new one (without check)
                    ubyte symbol_idx = symbols.setvalue2_new(sym_ptr, parsed_len, cx16.r15, symbols_dt.dt_uword_placeholder)
                    if not symbol_idx
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

; this is rewritten in assembly because of inner loop optimizations
;    sub is_symbol_start_char(ubyte chr) -> ubyte {
;        ; note: chr is not lowercased yet
;        chr &= $7f
;        if chr>='a' and chr <= 'z'
;            return true
;        return chr=='.' or chr=='@'
;    }

    asmsub is_symbol_start_char(ubyte chr @A) -> ubyte @A {
        %asm {{
            cmp  #'.'
            beq  _yes
            cmp  #'@'
            beq  _yes
            and  #$7f       ; make lowercase
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
        ; we recognise .byte, .word and .str right now
        ; void string.lower(directive)
        if operand {
            if string.compare(directive, ".byte")==0
                return proces_directive_byte(operand)
            else if string.compare(directive, ".word")==0
                return proces_directive_word(operand)
            else if string.compare(directive, ".str")==0
                return proces_directive_str(operand)
            else if string.compare(directive, ".include")==0
                return process_directive_include(operand, false)
            else if string.compare(directive, ".incbin")==0
                return process_directive_include(operand, true)
        }

        err.print("syntax error")
        return false
    }

    sub proces_directive_byte(uword operand) -> ubyte {
        ubyte length = conv.any2uword(operand)
        if length {
            if msb(cx16.r15) {
                err.print("value too large")
                return false
            }
            if phase==2
                output.emit(lsb(cx16.r15))
            else
                output.inc_pc(0)
            operand += length
            operand = str_trimleft(operand)
            while @(operand)==',' {
                operand++
                operand = str_trimleft(operand)
                length = conv.any2uword(operand)
                if not length
                    break
                if msb(cx16.r15) {
                    err.print("value too large")
                    return false
                }
                if phase==2
                    output.emit(lsb(cx16.r15))
                else
                    output.inc_pc(0)
                operand += length
            }
            return true
        }

        err.print("syntax error")
        return false
    }

    sub proces_directive_word(uword operand) -> ubyte {
        ubyte length = conv.any2uword(operand)
        if length {
            if phase==2 {
                output.emit(lsb(cx16.r15))
                output.emit(msb(cx16.r15))
            }
            else
                output.inc_pc(1)        ; increase pc by 2 effectively (a word)
            operand += length
            operand = str_trimleft(operand)
            while @(operand)==',' {
                operand++
                operand = str_trimleft(operand)
                length = conv.any2uword(operand)
                if not length
                    break
                if phase==2 {
                    output.emit(lsb(cx16.r15))
                    output.emit(msb(cx16.r15))
                }
                else
                    output.inc_pc(1)    ; increase pc by 2 effectively (a word)
                operand += length
            }
            return true
        }

        err.print("syntax error")
        return false
    }

    sub proces_directive_str(uword operand) -> ubyte {
        if operand[0]=='\"' {
            operand++
            ubyte char_idx=0
            repeat {
                ubyte char = @(operand+char_idx)
                when char {
                    '\"', 0 -> return true
                    else -> {
                        if phase==2
                            output.emit(char)
                        else
                            output.inc_pc(0)
                    }
                }
                char_idx++
            }
        }

        err.print("syntax error")
        return false
    }

    sub process_directive_include(uword operand, ubyte is_incbin) -> ubyte {
        if operand[0]=='\"'
            operand++
        uword filename = operand
        while @(operand) {
            if @(operand)=='\"' or @(operand)=='\n' {
                @(operand) = 0
                break
            }
            operand++
        }

        when phase {
            1 -> {
                if not filereader.read_file(main.drivenumber, filename) {
                    txt.nl()
                    txt.print(diskio.status(main.drivenumber))
                    return false
                }
                output.add_pc(filereader.file_size(filename))
                return true
            }
            2 -> {
                if is_incbin {
                    ; include binary data in the output
                    filereader.push_file()
                    if not filereader.start_get_bytes(filename) {
                        err.print("can't read file data")
                        filereader.pop_file()
                        return false
                    }
                    repeat {
                        cx16.r0L = filereader.next_byte()
                        if_cs {
                            filereader.pop_file()
                            return true
                        }
                        output.emit(cx16.r0L)
                    }
                } else {
                    ; TODO actually process the included source file
                    ;      push current file on stack, pop afterwards
                    err.print("include not yet implemented")
                    return false
                }
            }
        }
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
        cx16.r0 = st
        repeat {
            when @(cx16.r0) {
                ' ', 9, 160 -> cx16.r0++
                else -> return cx16.r0
            }
        }
        return 0
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
