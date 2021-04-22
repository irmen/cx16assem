%import textio

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
    ; old_datatypes of the old_values in the symboltable
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
    ; SUBROUTINE: init
    ; PURPOSE: call to clear the symbol table for initial or subsequent use.
    ; ARGS: -
    ; RETURNS: -
    sub init() {
        hashtable.init()
    }

    ; SUBROUTINE: numsymbols
    ; PURPOSE: returns the number of symbols in the symboltable
    ; ARGS: -
    ; RETURNS: uword, the number of symbols.
    inline sub numsymbols() -> uword {
        return hashtable.num_entries
    }

    ; SUBROUTINE: setvalue
    ; PURPOSE: adds a symbol + value to the table, or updates existing (only if it's still a placeholder value)
    ; ARGS: symbol = address of the symbol (0-terminated string),
    ;       value = byte or word value for this symbol,
    ;       datatype = one of the datatype constants for this value.
    ; RETURNS: success boolean.
    sub setvalue(uword symbol, uword value, ubyte datatype) -> ubyte {
        ubyte hash = hashtable.calc_hash(symbol)
        if_cs {
            txt.print("\n?hash error name too long\n")
            return false
        }

        uword existing_entry_ptr = hashtable.find_entry_in_bucket(hash, symbol)
        if existing_entry_ptr {
            when @(existing_entry_ptr) {
                symbols_dt.dt_uword_placeholder, symbols_dt.dt_ubyte_placeholder -> {
                    ; update the existing entry
                    @(existing_entry_ptr) = datatype
                    pokew(existing_entry_ptr+1, value)
                    return true
                }
                else -> {
                    txt.print("\n?symbol already defined\n")
                    return false
                }
            }
        }

        ; add new entry
        return hashtable.add_entry(hash, symbol, value, datatype)
    }

    ; SUBROUTINE: setvalue_newsymbol
    ; PURPOSE: adds a new symbol + value to the table.  ASSUMES THE SYMBOL IS NOT YET IN THE TABLE!
    ; ARGS: symbol = address of the symbol (0-terminated string),
    ;       value = byte or word value for this symbol,
    ;       datatype = one of the datatype constants for the value.
    ; RETURNS: success boolean.
    sub setvalue_newsymbol(uword symbol, uword value, ubyte datatype) -> ubyte {
        ubyte hash = hashtable.calc_hash(symbol)
        if_cs {
            txt.print("\n?hash error name too long\n")
            return false
        }
        return hashtable.add_entry(hash, symbol, value, datatype)
    }

    ; SUBROUTINE: setvalue2
    ; PURPOSE: adds a symbol + value to the table, or updates existing (only if it's still a placeholder value)
    ; ARGS: symbol = address of the symbol,
    ;       length = length of the symbol,
    ;       value = byte or word value for this symbol,
    ;       datatype = one of the datatype constants for the value.
    ; RETURNS: success boolean.
    sub setvalue2(uword symbol, ubyte length, uword value, ubyte datatype) -> ubyte {
        ubyte tc = @(symbol+length)
        @(symbol+length) = 0
        ubyte result = setvalue(symbol, value, datatype)
        @(symbol+length) = tc
        return result
    }

    ; SUBROUTINE: setvalue2_newsymbol
    ; PURPOSE: adds a new symbol + value to the table. ASSUMES THE SYMBOL IS NOT YET IN THE TABLE!
    ; ARGS: symbol = address of the symbol,
    ;       length = length of the symbol,
    ;       value = byte or word value for this symbol,
    ;       datatype = one of the datatype constants for the value.
    ; RETURNS: success boolean.
    sub setvalue2_newsymbol(uword symbol, ubyte length, uword value, ubyte datatype) -> ubyte {
        ubyte tc = @(symbol+length)
        @(symbol+length) = 0
        ubyte result = setvalue_newsymbol(symbol, value, datatype)
        @(symbol+length) = tc
        return result
    }

    ; SUBROUTINE: getvalue
    ; PURPOSE: retrieve the value of a symbol. Name limited by terminating 0.
    ; ARGS: symbol = address of the symbol name (0-terminated string)
    ; RETURNS: success boolean. If successful,
    ;          the symbol's value is returned in cx16.r0, and its datatype in cx16.r1.
    sub getvalue(uword symbol) -> ubyte {
        ubyte hash = hashtable.calc_hash(symbol)
        if_cs {
            txt.print("\n?hash error name too long\n")
            return false
        }

        uword entry_ptr = hashtable.find_entry_in_bucket(hash, symbol)
        if entry_ptr {
            cx16.r1 = @(entry_ptr)
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
    sub getvalue2(uword symbol, ubyte length) -> ubyte {
        ubyte tc = @(symbol+length)
        @(symbol+length) = 0
        ubyte result = getvalue(symbol)
        @(symbol+length) = tc
        return result
    }


    ; SUBROUTINE: dump
    ; PURPOSE: prints the known symbols and their old_values
    ; ARGS / RETURNS: -
    sub dump(uword num_lines) {
        txt.print("\nsymboltable contains ")
        txt.print_uw(hashtable.num_entries)
        txt.print(" entries:\n")
        if hashtable.num_entries {
            if num_lines >= hashtable.num_entries
                num_lines = hashtable.num_entries
            if num_lines != hashtable.num_entries {
                txt.print("(listing limited to ")
                txt.print_uw(num_lines)
                txt.print(")\n")
            }

            ubyte bk
            for bk in 0 to hashtable.num_buckets-1 {
                ubyte bucketcount = hashtable.bucket_entry_counts[bk]
                if bucketcount {
                    ubyte ix
                    for ix in 0 to bucketcount-1 {
                        uword entryptr = peekw(hashtable.bucket_entry_pointers + (bk as uword)*hashtable.max_entries_per_bucket*2 + ix*2)

                        ; to dump the bucket number and entry addr as well for debug:
;                        txt.print("  #")
;                        txt.print_ub(bk)
;                        txt.column(7)
;                        txt.print_uwhex(entryptr, true)

                        txt.print("  ")
                        if @(entryptr)==symbols_dt.dt_ubyte {
                            txt.print("  ")
                            txt.print_ubhex(@(entryptr+1), true)
                        } else {
                            txt.print_uwhex(peekw(entryptr+1), true)
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
}


hashtable {

    ; TODO when this all works nicely, reintegrate into symboltable block to get rid of extra subroutine calls?

    const ubyte max_name_len = 31       ; excluding the terminating 0
    const ubyte num_buckets = 128
    const ubyte max_entries_per_bucket = 12     ; TODO adjust if too low?
    const uword entrybuffer_size = $5000        ; TODO adjust later, to not overwrite IO beginning at $9f00!
    ubyte[num_buckets] bucket_entry_counts
    uword bucket_entry_pointers = memory("entrypointers", num_buckets*max_entries_per_bucket*2)
    uword num_entries
    uword entrybuffer = memory("entrybuffer", entrybuffer_size)
        ; the entry buffer is a large block of memory in which the entries are stored.
        ; an entry consists of:
        ;  *     1 BYTE: datatype
        ;  *    2 BYTES: value
        ;  * 2-32 BYTES: symbolname (terminated with 0)
    uword entrybufferptr

    sub init() {
        entrybufferptr = entrybuffer
        sys.memset(&bucket_entry_counts, num_buckets, 0)
        num_entries = 0

;      To see what the maximum memory address is used by the assembler:
;        txt.print("memtop=")
;        txt.print_uwhex(sys.progend(), true)
;        txt.nl()
    }

    sub add_entry(ubyte hash, uword symbol, uword value, ubyte datatype) -> ubyte {
        ; NOTE: this routine assumes the symbol DOES NOT EXIST in the table yet!
        ubyte bucketcount = bucket_entry_counts[hash]
        if bucketcount >= max_entries_per_bucket {
            txt.print("\n?hash bucket full, choose another symbol name\n")
            return false
        }
        if (entrybufferptr - entrybuffer) >= entrybuffer_size {
            txt.print("\n?symbol table full, use less symbols...\n")
            return false
        }

        ; actually add it to the bucket list
        pokew(bucket_entry_pointers + bucketcount*2 + (hash as uword)*max_entries_per_bucket*2, entrybufferptr)
        @(entrybufferptr) = datatype
        entrybufferptr++
        pokew(entrybufferptr, value)
        entrybufferptr += 2
        entrybufferptr += string.copy(symbol, entrybufferptr) + 1

        bucket_entry_counts[hash]++
        num_entries++
        return true
    }

    sub find_entry_in_bucket(ubyte hash, uword symbol) -> uword {
        ubyte bucketcount = bucket_entry_counts[hash]
        if bucketcount==0
            return $0000

        ; search the symbol in the bucket list
        uword bucketptrs = hashtable.bucket_entry_pointers + (hash as uword)*hashtable.max_entries_per_bucket*2
        ubyte ix
        for ix in 0 to bucketcount-1 {
            uword entryptr = peekw(bucketptrs + ix*2)
            if string.compare(symbol, entryptr+3)==0
                return entryptr
        }
        return $0000
    }

    ; calculate a reasonable byte hash code 0..127 (by adding all the characters and eoring with the length)
    ; returns ok status in Carry (carry clear=all OK carry set = symbol name too long)
    asmsub calc_hash(uword symbol @R7) -> ubyte @A, ubyte @Pc {
        %asm {{
            stz  P8ZP_SCRATCH_B1        ; the hash
            ldy  #0
            clc
_loop       lda  (cx16.r7),y
            beq  _end
            adc  P8ZP_SCRATCH_B1
            sta  P8ZP_SCRATCH_B1
            iny
            bra  _loop
_end        cpy  #max_name_len+1
            bcs  _toolong
            tya
            asl  a
            eor  P8ZP_SCRATCH_B1
            and  #127
            clc
_toolong
            rts
        }}
    }
}
