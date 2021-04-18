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
                    sys.set_irqd()
                    cx16.vaddr(1, vram_addr, 0, true)
                    ubyte idx
                    for idx in 0 to lsb(length)-1 {
                        cx16.VERA_DATA0 = buffer[idx]       ; copy buffer to vera vram
                    }
                    sys.clear_irqd()
                    vram_addr += length
                    if vram_addr >= $f900 {
                        txt.print("file too large! >62kb\n")
                        goto error
                    }
                }
                txt.print("done!\n")

                process()
error:
                diskio.f_close()
            }
        }
    }

    sub process() {
        cx16.VERA_CTRL = 0              ; select data port 0
        cx16.VERA_ADDR_L = 0
        cx16.VERA_ADDR_M = 0
        cx16.VERA_ADDR_H = %00010001    ; $10000 with auto increment 1 byte

        str buffer = "?" * 255
        uword buffer_ptr = &buffer
        repeat 200 {
            ubyte chr = cx16.VERA_DATA0
            @(buffer_ptr) = chr
            buffer_ptr++
        }
        @(buffer_ptr) = 0

        txt.print(buffer)
        txt.nl()
    }

}

