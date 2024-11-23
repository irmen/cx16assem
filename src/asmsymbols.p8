%import strings
%import textio
%import errors

; SYMBOL TABLE.
; Capability: store names with their value (ubyte or uword, or temp placeholder for them).
; External API:
;   subroutines:
;       init
;       numsymbols
;       setvalue  +  setvalue2
;       setvalue_new  +  setvalue2_new
;       getvalue  +  getvalue2
;       dump
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
    const ubyte max_name_len = 31               ; excluding the terminating 0.
    const ubyte num_buckets = 128               ; pretty much fixed because of the chosen hash algorithm
    const ubyte max_entries_per_bucket = 16     ; can be adjusted if bucket full errors occur too often
    const uword entrybuffer_size = $3d00        ; can be almost as large as free ram allows (which runs up to $9f00)
    ubyte[num_buckets] bucket_entry_counts
    uword bucket_entry_pointers = memory("entrypointers", num_buckets*max_entries_per_bucket*2, 0)
    uword num_entries
    uword entrybuffer = memory("entrybuffer", entrybuffer_size, 0)
        ; the entry buffer is a large block of memory in which the entries are stored.
        ; an entry consists of:
        ;  *     1 BYTE: datatype
        ;  *    2 BYTES: value
        ;  * 2-32 BYTES: symbolname (variable length, max 31 bytes, terminated with 0)
    uword entrybufferptr


    ; SUBROUTINE: init
    ; PURPOSE: call to clear the symbol table for initial or subsequent use.
    ; ARGS: -
    ; RETURNS: -
    sub init() {
        entrybufferptr = entrybuffer
        sys.memset(&bucket_entry_counts, num_buckets, 0)
        num_entries = 0

;        txt.print("progend=")
;        txt.print_uwhex(sys.progend(), true)
;        txt.nl()

        if sys.progend() >= $9f00-max_name_len*2 {
            txt.print("\n\nerror: symbol table size exceeds free system ram: ")
            txt.print_uwhex(sys.progend(), true)
            txt.nl()
            sys.exit(1)
        }
;        else {
;            txt.print("\ndebug: progend=")
;            txt.print_uwhex(sys.progend(), true)
;            txt.nl()
;        }
    }

    ; SUBROUTINE: numsymbols
    ; PURPOSE: returns the number of symbols in the symboltable
    ; ARGS: -
    ; RETURNS: uword, the number of symbols.
    sub numsymbols() -> uword {
        return num_entries
    }

    ; SUBROUTINE: setvalue
    ; PURPOSE: adds a symbol + value to the table, or updates existing (only if it's still a placeholder value)
    ; ARGS: symbol = address of the symbol (0-terminated string),
    ;       value = byte or word value for this symbol,
    ;       datatype = one of the datatype constants for this value.
    ; RETURNS: success boolean.
    sub setvalue(uword symbol, uword value, ubyte datatype) -> bool {
        if strings.length(symbol) > max_name_len {
            err.print("hash error name too long")
            return false
        }

        ubyte hash = strings.hash(symbol) & 127
        uword existing_entry_ptr = ht_find_entry_in_bucket(hash, symbol)
        if existing_entry_ptr!=0 {
            when @(existing_entry_ptr) {
                symbols_dt.dt_uword_placeholder, symbols_dt.dt_ubyte_placeholder -> {
                    ; update the existing entry
                    @(existing_entry_ptr) = datatype
                    pokew(existing_entry_ptr+1, value)
                    return true
                }
                else -> {
                    err.print("symbol already defined")
                    txt.spc()
                    txt.print(symbol)
                    if @(existing_entry_ptr) == symbols_dt.dt_ubyte
                        txt.print(" ubyte")
                    else
                        txt.print(" uword")
                    txt.print(" value ")
                    txt.print_uwhex(peekw(existing_entry_ptr+1), true)
                    txt.nl()
                    return false
                }
            }
        }

        return ht_add_entry(hash, symbol, value, datatype)
    }

    ; SUBROUTINE: setvalue_new
    ; PURPOSE: adds a new symbol + value to the table.  ASSUMES THE SYMBOL IS NOT YET IN THE TABLE!
    ; ARGS: symbol = address of the symbol (0-terminated string),
    ;       value = byte or word value for this symbol,
    ;       datatype = one of the datatype constants for the value.
    ; RETURNS: success boolean.
    sub setvalue_new(uword symbol, uword value, ubyte datatype) -> bool {
        if strings.length(symbol) > max_name_len {
            err.print("hash error name too long")
            return false
        }
        return ht_add_entry(strings.hash(symbol) & 127, symbol, value, datatype)
    }

    ; SUBROUTINE: setvalue2
    ; PURPOSE: adds a symbol + value to the table, or updates existing (only if it's still a placeholder value)
    ; ARGS: symbol = address of the symbol,
    ;       length = length of the symbol,
    ;       value = byte or word value for this symbol,
    ;       datatype = one of the datatype constants for the value.
    ; RETURNS: success boolean.
    sub setvalue2(uword symbol, ubyte length, uword value, ubyte datatype) -> bool {
        ubyte tc = @(symbol+length)
        @(symbol+length) = 0
        bool result = setvalue(symbol, value, datatype)
        @(symbol+length) = tc
        return result
    }

    ; SUBROUTINE: setvalue2_new
    ; PURPOSE: adds a new symbol + value to the table. ASSUMES THE SYMBOL IS NOT YET IN THE TABLE!
    ; ARGS: symbol = address of the symbol,
    ;       length = length of the symbol,
    ;       value = byte or word value for this symbol,
    ;       datatype = one of the datatype constants for the value.
    ; RETURNS: success boolean.
    sub setvalue2_new(uword symbol, ubyte length, uword value, ubyte datatype) -> bool {
        ubyte tc = @(symbol+length)
        @(symbol+length) = 0
        bool result = setvalue_new(symbol, value, datatype)
        @(symbol+length) = tc
        return result
    }

    ; SUBROUTINE: getvalue
    ; PURPOSE: retrieve the value of a symbol. Name limited by terminating 0.
    ; ARGS: symbol = address of the symbol name (0-terminated string)
    ; RETURNS: success boolean. If successful,
    ;          the symbol's value is returned in cx16.r0, and its datatype in cx16.r1.
    sub getvalue(uword symbol) -> bool {
        uword entry_ptr = ht_find_entry_in_bucket(strings.hash(symbol) & 127, symbol)
        if entry_ptr!=0 {
            cx16.r1 = @(entry_ptr)
            if cx16.r1 != symbols_dt.dt_ubyte and cx16.r1 != symbols_dt.dt_uword {
                ; must be a placeholder that is not defined yet
                return false
            }
            cx16.r0 = peekw(entry_ptr+1)
            return true
        }
        return false
    }

    ; SUBROUTINE: getvalue2
    ; PURPOSE: retrieve the value of a symbol. Name limited by given length instead of 0-byte
    ; ARGS: symbol = address of the symbol name, length = length of the symbol name
    ; RETURNS: success boolean. If successful,
    ;          the symbol's value is returned in cx16.r0, and its datatype in cx16.r1.
    sub getvalue2(uword symbol, ubyte length) -> bool {
        ubyte tc = @(symbol+length)
        @(symbol+length) = 0
        bool result = getvalue(symbol)
        @(symbol+length) = tc
        return result
    }


    ; SUBROUTINE: dump
    ; PURPOSE: prints the known symbols and their values
    ; ARGS / RETURNS: -
    sub dump(uword num_lines) {
        txt.print("\nsymboltable contains ")
        txt.print_uw(num_entries)
        txt.print(" entries:\n")
        if num_entries!=0 {
            if num_lines >= num_entries
                num_lines = num_entries
            if num_lines != num_entries {
                txt.print("(first ")
                txt.print_uw(num_lines)
                txt.print(" shown)\n")
            }

            ubyte bk
            for bk in 0 to num_buckets-1 {
                ubyte bucketcount = bucket_entry_counts[bk]
;                txt.print("bucket ")
;                txt.print_ub(bk)
;                txt.print("=")
;                txt.print_ub(bucketcount)
;                txt.nl()

                if bucketcount!=0 {
                    ubyte ix
                    for ix in 0 to bucketcount-1 {
                        uword entryptr = peekw(bucket_entry_pointers + (bk as uword)*max_entries_per_bucket*2 + ix*2)

                        ; to dump the bucket number and entry addr as well for debug:
;                        txt.print("  #")
;                        txt.print_ub(bk)
;                        txt.column(7)
;                        txt.print_uwhex(entryptr, true)

                        txt.print("  ")
                        if @(entryptr)==symbols_dt.dt_ubyte {
                            txt.print("  ")
                            txt.print_ubhex(@(entryptr+1), true)
                        } else if @(entryptr)==symbols_dt.dt_uword {
                            txt.print_uwhex(peekw(entryptr+1), true)
                        } else {
                            ; undefined symbol
                            txt.print("?????")
                        }
                        txt.print(" = ")
                        txt.print(entryptr+3)
                        txt.nl()
                        num_lines--
                        if num_lines==0
                            return
                    }
                }
            }
        }
    }

    sub ht_add_entry(ubyte hash, uword symbol, uword value, ubyte datatype) -> bool {
        ; NOTE: this routine assumes the symbol DOES NOT EXIST in the table yet!
        ubyte bucketcount = bucket_entry_counts[hash]
        if bucketcount >= max_entries_per_bucket {
            err.print("hash bucket full, choose another symbol name")
            return false
        }
        if (entrybufferptr - entrybuffer + 256) >= entrybuffer_size {
            err.print("symbol table full, use less symbols")
            return false
        }

        ; actually add it to the bucket list
        pokew(bucket_entry_pointers + bucketcount*2 + (hash as uword)*max_entries_per_bucket*2, entrybufferptr)
        @(entrybufferptr) = datatype
        entrybufferptr++
        pokew(entrybufferptr, value)
        entrybufferptr += 2
        entrybufferptr += strings.copy(symbol, entrybufferptr) + 1

        bucket_entry_counts[hash]++
        num_entries++
        return true
    }

    sub ht_find_entry_in_bucket(ubyte hash, uword symbol) -> uword {
        ubyte bucketcount = bucket_entry_counts[hash]
        if bucketcount==0
            return $0000

        ; search the symbol in the bucket list
        uword bucketptrs = bucket_entry_pointers + (hash as uword)*max_entries_per_bucket*2
        ubyte ix
        for ix in 0 to bucketcount-1 {
            uword entryptr = peekw(bucketptrs + ix*2)
            if strings.compare(symbol, entryptr+3)==0
                return entryptr
        }
        return $0000
    }
}
