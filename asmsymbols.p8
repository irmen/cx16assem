%import textio

; humble beginnings of dealing with the symbol table
; restrictions for now:
; max 128 symbols
; max symbol name length 31 characters
; (resulting in a symbol table of 4 Kb for now)
; datatype unsigned byte 0-255 or unsigned word 0-65535
; braindead symbol lookup (linear scan)

symbols {
    const ubyte max_entries = 128
    const ubyte max_name_len = 31       ; excluding the terminating 0

    uword[max_entries] symbolptrs
    uword[max_entries] values
    ubyte[max_entries] datatypes
    uword namebuffer
    ubyte num_symbols

    const ubyte dt_ubyte = 1
    const ubyte dt_uword = 2

    ; SUBROUTINE: init
    ; ARGS: -
    ; RETURNS: -
    ; PURPOSE: call to clear the symbol table for initial use.
    sub init() {
        namebuffer = memory("symbolnames", (max_name_len+1)*len(symbolptrs))
        num_symbols = 0
    }

    ; SUBROUTINE: setvalue
    ; ARGS: symbol = address of the symbol name,
    ;       value = byte or word value for this symbol,
    ;       datatype = dt_ubyte or dt_uword to specify the datatype of the value.
    ; RETURNS: success boolean.
    ; PURPOSE: adds a new symbol and its value to the table. You can't overwrite an existing symbol.
    sub setvalue(uword symbol, uword value, ubyte datatype) -> ubyte {
        if num_symbols>=max_entries {
            txt.print("\n?symbol table full\n")
            return 0
        }
        if getvalue(symbol) {
            txt.print("\n?symbol already defined\n")
            return 0
        }
        symbolptrs[num_symbols] = namebuffer
        namebuffer += string.copy(symbol, namebuffer) + 1
        values[num_symbols] = value
        datatypes[num_symbols] = datatype
        num_symbols++
        return num_symbols
    }

    ; SUBROUTINE: getvalue
    ; ARGS: symbol = address of the symbol name,
    ; RETURNS: success boolean. If successful,
    ;          the symbol's value is returned in cx16.r0, and its datatype in cx16.r1.
    ; PURPOSE: retrieve the value of a symbol.
    sub getvalue(uword symbol) -> ubyte {
        ; -- returns success. The value will be in cx16.r0, the datatype in cx16.r1
        ;    TODO more efficient lookup rather than linear scan
        if num_symbols {
            ubyte ix
            for ix in num_symbols-1 downto 0 {
                if string.compare(symbol, symbolptrs[ix]) == 0 {
                    cx16.r0 = values[ix]
                    cx16.r1 = datatypes[ix]
                    return true
                }
            }
        }
        return false
    }

    ; SUBROUTINE: dump
    ; ARGS / RETURNS: -
    ; PURPOSE: prints all known symbols and their values.
    sub dump() {
        txt.print("\nsymboltable contains ")
        txt.print_ub(num_symbols)
        txt.print(" entries:\n")
        if num_symbols {
            ubyte ix
            for ix in num_symbols-1 downto 0 {
                txt.print("  ")
                if datatypes[ix]==dt_ubyte {
                    txt.print("  ")
                    txt.print_ubhex(lsb(values[ix]), true)
                }
                else
                    txt.print_uwhex(values[ix], true)
                txt.print(" = ")
                txt.print(symbolptrs[ix])
                txt.nl()
            }
        }
    }
}
