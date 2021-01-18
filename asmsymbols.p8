%import textio

; humble beginnings of dealing with the symbol table
; restrictions for now:
; max 128 symbols
; max symbol name length 15 characters
; (resulting in a symbol table of 2 Kb for now, but 16 kb when we want to allow 1000 symbols)
; datatype unsigned byte 0-255 or unsigned word 0-65535
; braindead symbol lookup (linear scan)

symbols {
    uword[128] symbolptrs = 0
    uword[128] values
    ubyte[128] datatypes = 0
    uword namebuffer
    ubyte num_symbols

    const ubyte dt_ubyte = 1
    const ubyte dt_uword = 2

    sub init() {
        namebuffer = memory("symbolnames", 16*len(symbolptrs))
        num_symbols = 0
    }

    sub setvalue(uword symbolname_ptr, uword value, ubyte datatype) -> ubyte {
        if num_symbols>=128 {
            txt.print("\n?symbol table full\n")
            return 0
        }
        symbolptrs[num_symbols] = namebuffer
        namebuffer += string.copy(symbolname_ptr, namebuffer) + 1
        values[num_symbols] = value
        datatypes[num_symbols] = datatype
        num_symbols++
        return num_symbols
    }

    sub getvalue(uword symbolname_ptr) -> ubyte {
        ; -- returns success. The value will be in cx16.r0, the datatype in cx16.r1
        ;    TODO more efficient lookup
        ubyte ix
        for ix in 0 to num_symbols-1 {
            if string.compare(symbolname_ptr, symbolptrs[ix]) == 0 {
                cx16.r0 = values[ix]
                cx16.r1 = datatypes[ix]
                return true
            }
        }
        return false
    }

    sub dump() {
        txt.print("\nsymboltable contains ")
        txt.print_ub(num_symbols)
        txt.print(" entries:\n")
        if num_symbols {
            ubyte ix
            for ix in 0 to num_symbols-1 {
                txt.print("  ")
                txt.print(symbolptrs[ix])
                txt.chrout('=')
                if datatypes[ix]==dt_ubyte
                    txt.print_ubhex(lsb(values[ix]), true)
                else
                    txt.print_uwhex(values[ix], true)
                txt.chrout('\n')
            }
        }
    }
}
