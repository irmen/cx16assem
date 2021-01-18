%import textio

; humble beginnings of dealing with the symbol table

symbols {
    sub setvalue(uword symbolname_ptr, uword value) {
        txt.print("symbol: ")
        txt.print(symbolname_ptr)
        txt.chrout('=')
        txt.print_uwhex(value, true)
        txt.nl()
    }
}
