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
                cx16.vaddr(1, vram_addr, 0, true)
                ubyte idx
                for idx in 0 to lsb(length)-1 {
                    cx16.VERA_DATA0 = buffer[idx]
                }
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

    sub next_line(uword buffer) -> ubyte {
        ; Copy the next line of text from vram to the system ram buffer.
        ; Returns false when no more lines available.
        ubyte chr
        ubyte length=0
        cx16.vaddr(1, line_ptr, 0, true)
        repeat {
            chr = cx16.VERA_DATA0
            if_z {
                buffer[length] = 0
                return false        ; eof
            }
            when chr {
                $a, $d -> {
                    buffer[length] = 0
                    length++
                    line_ptr += length
                    return true     ; eol
                }
                else -> {
                    buffer[length] = chr
                    length++
                }
            }
        }

        return false    ; not reached
    }
}
