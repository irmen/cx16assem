; experimental file loading into VERA bank 1 memory
; $10000 - $1f900  (about 62 kb contiguous memory)

%import textio
%import diskio
%zeropage basicsafe
%option no_sysinit

main {
    sub start() {
        str filename = "??????????????????????????????"

        txt.print("filename> ")
        if txt.input_chars(filename) {
            txt.nl()
            if reader.read_file(filename) {
                process()
            } else {
                txt.print("?load error\n")
            }
        }
    }


    sub process() {
        str buffer = "?" * 160
        reader.start_get_lines()
        while reader.next_line(buffer) {
            txt.print(buffer)
            txt.nl()
        }
    }

}

reader {
    uword line_ptr

    sub read_file(uword filename) -> ubyte {
        ubyte success = false
        if diskio.f_open(8, filename) {
            const ubyte buffer_length = 255     ; less than 256
            ubyte[buffer_length] buffer
            uword vram_addr = $0000
            str anim = "││╱╱──╲╲"
            ubyte anim_counter = 0

            txt.print("loading ")
            repeat {
                uword length = diskio.f_read(&buffer, buffer_length)
                if length==0
                    break
                txt.chrout(anim[anim_counter])
                txt.chrout(157)     ; cursor left
                anim_counter = (anim_counter+1) & 7
                ; now copy buffer to vera Vram
                cx16.vaddr(1, vram_addr, 0, true)
                ubyte idx
                for idx in 0 to lsb(length)-1 {
                    cx16.VERA_DATA0 = buffer[idx]
                }
                vram_addr += length
                if msb(vram_addr) >= $f9 {
                    txt.print("\n?file too large >62kb\n")
                    goto error
                }
                if c64.STOP2() {
                    txt.print("\n?break\n")
                    goto error
                }
            }
            txt.print("\x9d done ")
            txt.print_uw(vram_addr)
            txt.print(" bytes\n")

            ; tag the end of the file as a $00,$ff byte sequence
            cx16.vpoke(1, vram_addr, 0)
            cx16.vpoke(1, vram_addr+1, 255)
            success = true
error:
            diskio.f_close()
        }
        return success
    }

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
            when chr {
                0, $a, $d -> {
                    buffer[length] = 0
                    length++
                    break
                }
                else -> {
                    buffer[length] = chr
                    length++
                }
            }
        }
        line_ptr += length
        return chr!=0
    }
}
