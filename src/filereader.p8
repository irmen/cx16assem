%target cx16
%import textio
%import diskio

; routines to load a source file into memory (all at once),
; and to provide an iteration mechanism to retrieve the lines in sequential order
; (by copying them to a given line buffer in system memory).
;
; For simplicity (not having to deal with ram-banking), the file is currently
; read into the free area of VERA's upper vram bank  ($10000 - $1f900, about 62 kb contiguous memory)
; This memory is unused in the default text screen mode.
;
; It does mean that the source files are currently limited to 62 kilobyte.
; Maybe in the future this could be changed to use regular (banked) system RAM instead,
; which would allow for much bigger files to be processed.

filereader {
    sub read_file(uword filename) -> ubyte {
        ubyte success = false
        if diskio.f_open(8, filename) {
            ubyte[255] buffer           ; less than 256
            uword vram_addr = $0000
            str anim = "││╱╱──╲╲"
            ubyte anim_counter = 0

            txt.print("loading ")
            repeat {
                if c64.STOP2() {
                    txt.print("\n?break\n")
                    goto error
                }
                ; read a chunk into ram...
                uword length = diskio.f_read(&buffer, len(buffer))
                if length==0
                    break
                if msb(vram_addr+length) >= $f9 {
                    txt.print("\n?file too large >62kb\n")
                    goto error
                }
                txt.chrout(anim[anim_counter])
                txt.chrout(157)     ; cursor left
                anim_counter = (anim_counter+1) & 7
                ; ... now copy that ram buffer to VERA vram
                %asm {{
                    stz  cx16.VERA_CTRL
                    lda  vram_addr
                    sta  cx16.VERA_ADDR_L
                    lda  vram_addr+1
                    sta  cx16.VERA_ADDR_M
                    lda  #%00010001
                    sta  cx16.VERA_ADDR_H
                    lda  #<buffer
                    sta  P8ZP_SCRATCH_W1
                    lda  #>buffer
                    sta  P8ZP_SCRATCH_W1+1
                    ldy  #0
_copyloop           lda  (P8ZP_SCRATCH_W1),y
                    sta  cx16.VERA_DATA0
                    iny
                    cpy  length
                    bne  _copyloop
                }}
                vram_addr += length
            }
            txt.print("\x9d ")
            txt.print_uw(vram_addr)
            txt.print(" bytes. ")

            ; tag the end of the file as a $00,$ff byte sequence
            cx16.vpoke(1, vram_addr, 0)
            cx16.vpoke(1, vram_addr+1, 255)
            success = true
error:
            diskio.f_close()
        }
        return success
    }

    uword line_ptr

    inline sub start_get_lines() {
        line_ptr = $0000
    }

    asmsub next_line(uword buffer @AY) -> ubyte @A {
        ; Optimized routine to copy the next line of text from vram to the system ram buffer.
        ; Returns true when a line is available, false when EOF was reached.
        %asm {{
            sta  P8ZP_SCRATCH_W1
            sty  P8ZP_SCRATCH_W1+1
            stz  cx16.VERA_CTRL
            lda  line_ptr
            sta  cx16.VERA_ADDR_L
            lda  line_ptr+1
            sta  cx16.VERA_ADDR_M
            lda  #%00010001
            sta  cx16.VERA_ADDR_H
            ldy  #0

_lineloop   lda  cx16.VERA_DATA0
            beq  _eof
            cmp  #$0a
            beq  _eol
            cmp  #$0d
            beq  _eol
            sta  (P8ZP_SCRATCH_W1),y
            iny
            bra  _lineloop

_eol        lda  #0
            sta  (P8ZP_SCRATCH_W1),y
            tya
            sec
            adc  line_ptr
            sta  line_ptr
            bcc  +
            inc  line_ptr+1
+           lda  #1
            rts

_eof        sta  (P8ZP_SCRATCH_W1),y
            rts
        }}
    }
}
