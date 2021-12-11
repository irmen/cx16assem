%import textio
%import cx16diskio
%import string
%import errors

; Routines to load source files into memory,
; and to provide an iteration mechanism to retrieve the lines in sequential order
; (by copying them to a given line buffer in system memory).
;
; Files are stored in HIRAM (the banked memory) starting in bank 1.
; (bank 0 is used by basic and kernal).
;
; NOTE: this requires ZeroByte's patched Kernal LOAD routine to deal with the HIRAM banks correctly.
;       using the default unpatched V39 kernal Rom WILL crash the cx16 and can CORRUPT your sd-card image!
;       https://www.commanderx16.com/forum/index.php?/topic/2064-r39-patched-kernal-to-fix-load-into-hiram-functionality


filereader {
    sub init() {
        fileregistry.init()
        file_stack_ptr = 0
    }

    sub read_file(ubyte drivenumber, uword filename) -> ubyte {
        ubyte success = false
        ubyte bank = fileregistry.get_load_bank()
        uword address = fileregistry.get_load_address()
        txt.print("loading ")
        txt.print(filename)
        uword size = cx16diskio.load_raw(drivenumber, filename, bank, address)
        bank = cx16.getrambank()     ; store output bank
        if size==0 {
            err.print("load error")
            return false
        } else {
            txt.spc()
            txt.print_uw(size)
            txt.print(" bytes.\n")
            return fileregistry.add(filename, size, bank)
        }
    }

    uword[fileregistry.max_num_files] line_ptrs
    ubyte[fileregistry.max_num_files] line_banks
    uword[fileregistry.max_num_files] end_ptrs
    ubyte[fileregistry.max_num_files] end_banks
    uword[fileregistry.max_num_files] current_lines
    ubyte file_stack_ptr

    sub get_line_nr() -> uword {
        return current_lines[file_stack_ptr]
    }

    sub file_size(str filename) -> uword {
        ubyte index = fileregistry.search(filename)
        if index==$ff
            return 0
        uword startaddr = fileregistry.file_start_addresses[index]
        uword startbank = fileregistry.file_start_banks[index]
        uword endaddr = fileregistry.file_end_addresses[index]
        uword endbank = fileregistry.file_end_banks[index]
        return $2000*(endbank-startbank) + endaddr - startaddr
    }

    ; returns true if the file's lines can be accessed via next_line(), false otherwise
    sub start_get_lines(str filename) -> ubyte {
        ubyte index = fileregistry.search(filename)
        if index==$ff
            return false
        line_ptrs[file_stack_ptr] = fileregistry.file_start_addresses[index]
        line_banks[file_stack_ptr] = fileregistry.file_start_banks[index]
        end_ptrs[file_stack_ptr] = fileregistry.file_end_addresses[index]
        end_banks[file_stack_ptr] = fileregistry.file_end_banks[index]
        current_lines[file_stack_ptr] = 0
        return true
    }

    sub next_line(uword buffer) -> ubyte {
        ; copies the next line from line_ptr into buffer
        ; stops at 0 (EOF), or 10/13 (EOL).
        ; returns true if success, false if EOF was reached.
        cx16.r0 = line_ptrs[file_stack_ptr]
        cx16.rambank(line_banks[file_stack_ptr])   ; set RAM bank, have to do this every time because kernal keeps resetting it
        %asm {{
            phx
            lda  buffer
            ldy  buffer+1
            sta  P8ZP_SCRATCH_W2
            sty  P8ZP_SCRATCH_W2+1
            ldy  #0             ; y = index into output buffer
_charloop
            lda  (cx16.r0)
            tax
            inc  cx16.r0L
            bne  +
            inc  cx16.r0H
+           lda  cx16.r0H
            cmp  #$c0
            bne  _processchar
            ; bank overflow, switch to next bank
            phy
            ldy  file_stack_ptr
            lda  line_banks,y
            ina
            sta  line_banks,y
            sta  $00        ; set new RAM bank
            ply
            stz  cx16.r0L
            lda  #$a0
            sta  cx16.r0H   ; at $a000 again
_processchar
            txa
            bne  +
            ; end of file
            sta  (P8ZP_SCRATCH_W2),y
            bra  _return
+           cmp  #10
            beq  _eol
            cmp  #13
            beq  _eol
            sta  (P8ZP_SCRATCH_W2),y
            iny
            bra  _charloop
_eol        lda  #0
            sta  (P8ZP_SCRATCH_W2),y
            ina
_return     ; remember the line pointer for next call
            sta  cx16.r1L       ; return value t/f
            plx
        }}
        line_ptrs[file_stack_ptr] = cx16.r0
        current_lines[file_stack_ptr]++
        return cx16.r1L
    }

    ; returns true if the file's bytes can be accessed via next_byte(), false otherwise
    sub start_get_bytes(str filename) -> ubyte {
        if start_get_lines(filename) {
            incbin_bank = line_banks[file_stack_ptr]
            incbin_addr = line_ptrs[file_stack_ptr]
            incbin_end_bank = end_banks[file_stack_ptr]
            incbin_end_addr = end_ptrs[file_stack_ptr]
            return true
        }
        return false
    }

    ubyte @shared incbin_bank
    uword @shared incbin_addr
    ubyte @shared incbin_end_bank
    uword @shared incbin_end_addr

    asmsub next_byte() -> ubyte @A, ubyte @Pc {
        %asm {{
            lda  incbin_bank
            cmp  incbin_end_bank
            bne  _more
            lda  incbin_addr
            cmp  incbin_end_addr
            bne  _more
            lda  incbin_addr+1
            cmp  incbin_end_addr+1
            bne  _more
            lda  #0
            sec                 ; end of file
            rts
_more       lda  incbin_bank
            sta  $0             ; make sure to set the ram bank again because other code changes it
            lda  incbin_addr
            sta  P8ZP_SCRATCH_W1
            lda  incbin_addr+1
            sta  P8ZP_SCRATCH_W1+1
            lda  (P8ZP_SCRATCH_W1)
            pha
            inc  incbin_addr
            bne  +
            inc  incbin_addr+1
+           lda  incbin_addr+1
            cmp  #$c0
            bne  +
            ; bank overflow, skip to next bank
            inc  incbin_bank
            lda  #$a0
            sta  incbin_addr+1
+           pla
            clc             ; there's more
            rts
        }}
    }

    sub push_file() {
        file_stack_ptr++
    }

    sub pop_file() {
        file_stack_ptr--
    }
}


fileregistry {
    const ubyte max_num_files = 15
    uword names = memory("names", 256)
    uword names_ptr
    str[max_num_files] file_name_ptrs
    ubyte[max_num_files] file_start_banks
    uword[max_num_files] file_start_addresses
    ubyte[max_num_files] file_end_banks
    uword[max_num_files] file_end_addresses
    uword next_load_address
    ubyte next_load_bank
    ubyte num_files

    sub init() {
        num_files = 0
        next_load_bank = 1              ; bank 0 is used by the kernal
        next_load_address = $a000
        names_ptr = names
    }

    sub get_load_address() -> uword {
        return next_load_address
    }

    sub get_load_bank() -> ubyte {
        return next_load_bank
    }

    ; registers a file in the database, return true on success or false otherwise
    sub add(str filename, uword size, ubyte last_bank) -> ubyte {
        if num_files >= max_num_files {
            err.print("too many files")
            return false
        }
        if last_bank >= cx16.numbanks()-8 {
            err.print("out of memory for files")
            return false
        }

        file_name_ptrs[num_files] = names_ptr
        names_ptr += string.copy(filename, names_ptr) + 1
        file_start_addresses[num_files] = next_load_address
        file_start_banks[num_files] = next_load_bank
        next_load_bank = last_bank
        next_load_address += (size & $1fff)
        if msb(next_load_address) >= $c0
            next_load_address -= $2000  ; correct bank overflow

        @(next_load_address) = 0  ; add $00 end of file marker
        next_load_address++
        if msb(next_load_address) == $c0 {
            next_load_bank++
            next_load_address = $a000
        }

        if next_load_address==$a000 {
            file_end_banks[num_files] = next_load_bank-1
            file_end_addresses[num_files] = $bfff
        } else {
            file_end_banks[num_files] = next_load_bank
            file_end_addresses[num_files] = next_load_address - 1
        }
        num_files++

        return true
    }

    ; search the given file in the database
    ; returns the index of this file, or $ff if it wasn't found.
    ; (you can use the index to get the address and size from addresses[] and sizes[])
    sub search(str filename) -> ubyte {
        if num_files==0
            return $ff
        ubyte i
        for i in 0 to num_files-1 {
            if string.compare(filename, file_name_ptrs[i])==0
                return i
        }
        return $ff
    }

    sub dump() {
        if num_files==0 {
            txt.print("\nno files.\n")
            return
        }
        txt.print("\nthere are ")
        txt.print_ub(num_files)
        txt.print(" files:\n")
        ubyte i
        for i in 0 to num_files-1 {
            txt.print_ubhex(file_start_banks[i], false)
            txt.chrout(':')
            txt.print_uwhex(file_start_addresses[i], false)
            txt.print(" - ")
            txt.print_ubhex(file_end_banks[i], false)
            txt.chrout(':')
            txt.print_uwhex(file_end_addresses[i], false)
            txt.print(" = ")
            txt.print(file_name_ptrs[i])
            txt.nl()
        }
    }
}
