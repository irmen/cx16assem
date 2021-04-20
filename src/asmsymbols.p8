%import textio

; SYMBOL TABLE.
; Capability: store names with their value (ubyte or uword, or temp placeholder for them).
; External API:
;   subroutines: init, numsymbols, setvalue, setvalue2, getvalue, getvalue2, dump
;   (see the default implementation below for the exact signature of these routines)
;   it uses the datatype constants defined in symbols_dt.
;
; Some calls into the symboltable are done with 0-terminated strings, in this
; case the length of the symbol is not required to be passed in.
; Some calls into the symboltable are done with strings that are NOT 0-terminated,
; because they're just a fragment inside another string. In this case the length is passed in.
; This is the reason we have getvalue+getvalue2 and setvalue+setvalue2.


symbols_dt {
    ; datatypes of the values in the symboltable
    const ubyte dt_ubyte = 1
    const ubyte dt_uword = 2
    const ubyte dt_ubyte_placeholder = 3
    const ubyte dt_uword_placeholder = 4
}


; The code below is a simplistic implementation of the symbol table API.
; Restrictions of this particular implementation:
;   max symbols: 128 symbols
;   max symbol name length: 31 characters
;     (this results in a symbol table that uses 4 Kb memory)
;   linear scan symbol lookup (slow)

symbols {
    const ubyte max_entries = 128
    const ubyte max_name_len = 31       ; excluding the terminating 0
    uword[max_entries] symbolptrs
    uword[max_entries] values
    ubyte[max_entries] datatypes
    uword namebuffer
    ubyte num_symbols


    ; SUBROUTINE: init
    ; PURPOSE: call to clear the symbol table for initial or subsequent use.
    ; ARGS: -
    ; RETURNS: -
    sub init() {
        namebuffer = memory("symbolnames", (max_name_len+1)*len(symbolptrs))
        num_symbols = 0
    }

    ; SUBROUTINE: numsymbols
    ; PURPOSE: returns the number of symbols in the symboltable
    ; ARGS: -
    ; RETURNS: uword, the number of symbols.
    inline sub numsymbols() -> uword {
        return num_symbols
    }

    ; SUBROUTINE: setvalue
    ; PURPOSE: adds a new symbol and its value to the table.
    ;          You can't overwrite an existing symbol (unless it's a placeholder).
    ; ARGS: symbol = address of the symbol name (0-terminated string),
    ;       value = byte or word value for this symbol,
    ;       datatype = symbols_dt.dt_ubyte or symbols_dt.dt_uword to specify the datatype of the value.
    ; RETURNS: success boolean.
    sub setvalue(uword symbol, uword value, ubyte datatype) -> ubyte {
        if num_symbols>=max_entries {
            txt.print("\n?symbol table full\n")
            return 0
        }
        if getvalue(symbol) {
            if lsb(cx16.r1) != symbols_dt.dt_uword_placeholder and lsb(cx16.r1) != symbols_dt.dt_ubyte_placeholder {
                txt.print("\n?symbol already defined\n")
                return 0
            }

            ; TODO overwrite the symbol in-place rather than adding a new occurrence at the end
        }
        symbolptrs[num_symbols] = namebuffer
        namebuffer += string.copy(symbol, namebuffer) + 1
        values[num_symbols] = value
        datatypes[num_symbols] = datatype
        num_symbols++
        return num_symbols
    }

    ; SUBROUTINE: setvalue2
    ; PURPOSE: adds a new symbol and its value to the table.
    ;          You can't overwrite an existing symbol (unless it's a placeholder).
    ; ARGS: symbol = address of the symbol name,
    ;       length = length of the symbol name,
    ;       value = byte or word value for this symbol,
    ;       datatype = symbols_dt.dt_ubyte or symbols_dt.dt_uword to specify the datatype of the value.
    ; RETURNS: success boolean.
    sub setvalue2(uword symbol, ubyte length, uword value, ubyte datatype) -> ubyte {
        ubyte tc = @(symbol+length)
        @(symbol+length) = 0
        ubyte result = setvalue(symbol, value, datatype)
        @(symbol+length) = tc
        return result
    }

    ; SUBROUTINE: getvalue
    ; PURPOSE: retrieve the value of a symbol. Name limited by terminating 0.
    ; ARGS: symbol = address of the symbol name (0-terminated string)
    ; RETURNS: success boolean. If successful,
    ;          the symbol's value is returned in cx16.r0, and its datatype in cx16.r1.
    sub getvalue(uword symbol) -> ubyte {
        ;    TODO more efficient lookup rather than linear scan
        if num_symbols {
            ubyte ix
            ; note: must search last-to-first to use the latest registration before earlier ones.
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

    ; SUBROUTINE: getvalue2
    ; PURPOSE: retrieve the value of a symbol. Name limited by given length.
    ; ARGS: symbol = address of the symbol name, length = length of the symbol name
    ; RETURNS: success boolean. If successful,
    ;          the symbol's value is returned in cx16.r0, and its datatype in cx16.r1.
    sub getvalue2(uword symbol, ubyte length) -> ubyte {
        ;    TODO more efficient lookup rather than linear scan
        ubyte tc = @(symbol+length)
        @(symbol+length) = 0
        ubyte result = getvalue(symbol)
        @(symbol+length) = tc
        return result
    }

    ; SUBROUTINE: dump
    ; PURPOSE: prints the known symbols and their values
    ; ARGS / RETURNS: -
    sub dump(uword num_lines) {
        txt.print("\nsymboltable contains ")
        txt.print_ub(num_symbols)
        txt.print(" entries:\n")
        if num_symbols {
            if num_lines >= num_symbols
                num_lines = num_symbols
            if num_lines != num_symbols {
                txt.print("(displaying only the last ")
                txt.print_uw(num_lines)
                txt.print(")\n")
            }
            ubyte limit = (num_symbols - num_lines) as ubyte
            ubyte ix
            for ix in num_symbols-1 downto limit {
                txt.print("  ")
                if datatypes[ix]==symbols_dt.dt_ubyte {
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
