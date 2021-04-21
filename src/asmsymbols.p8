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
    ; PURPOSE: adds a new symbol and its value to the table.
    ;          You can't overwrite an existing symbol (unless it's a placeholder).
    ; ARGS: symbol = address of the symbol name (0-terminated string),
    ;       value = byte or word value for this symbol,
    ;       datatype = symbols_dt.dt_ubyte or symbols_dt.dt_uword to specify the datatype of the value.
    ; RETURNS: success boolean.
    sub setvalue(uword symbol, uword value, ubyte datatype) -> ubyte {
        if hashtable.num_entries>=hashtable.old_max_entries {
            txt.print("\n?symbol table full\n")
            return false
        }

        ubyte hash = hashtable.calc_hash(symbol)
        if_cs {
            txt.print("\n?hash error name too long\n")
            return false
        }

        if hashtable.existing_entry(hash, symbol) {
            if lsb(cx16.r1) != symbols_dt.dt_uword_placeholder and lsb(cx16.r1) != symbols_dt.dt_ubyte_placeholder {
                txt.print("\n?symbol already defined\n")
                return false
            }

            ; TODO update the entry!!
            ; hashtable.update_entry(hash, symbol, value, datatype)
            ; return true
        }

        hashtable.add_entry(hash, symbol, value, datatype)
        return true
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
        if hashtable.num_entries==0
            return false

        ubyte hash = hashtable.calc_hash(symbol)
        if_cs {
            txt.print("\n?hash error name too long\n")
            return false
        }

        ; TODO make use of an actual hashtable
        ubyte ix
        ; note: must search last-to-first to use the latest registration before earlier ones.
        for ix in hashtable.num_entries-1 downto 0 {
            if string.compare(symbol, peekw(hashtable.bucket_entry_pointers+ix*2)+3) == 0 {
                cx16.r0 = hashtable.old_values[ix]
                cx16.r1 = hashtable.old_datatypes[ix]
                return true
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
        ; TODO rewrite this for actual hashtable dump once that works
        txt.print("\nsymboltable contains ")
        txt.print_ub(hashtable.num_entries)
        txt.print(" entries:\n")
        if hashtable.num_entries {
            if num_lines >= hashtable.num_entries
                num_lines = hashtable.num_entries
            if num_lines != hashtable.num_entries {
                txt.print("(displaying only the last ")
                txt.print_uw(num_lines)
                txt.print(")\n")
            }
            ubyte limit = (hashtable.num_entries - num_lines) as ubyte
            ubyte ix
            for ix in hashtable.num_entries-1 downto limit {
                txt.print("  ")
                if hashtable.old_datatypes[ix]==symbols_dt.dt_ubyte {
                    txt.print("  ")
                    txt.print_ubhex(lsb(hashtable.old_values[ix]), true)
                }
                else
                    txt.print_uwhex(hashtable.old_values[ix], true)
                txt.print(" = ")
                txt.print(peekw(hashtable.bucket_entry_pointers+ix*2)+3)
                txt.nl()
            }
        }
    }
}


hashtable {

    ; TODO when this all works nicely, reintegrate into symboltable block to get rid of extra subroutine calls?

    const ubyte max_name_len = 31       ; excluding the terminating 0
    const ubyte num_buckets = 128
    const ubyte max_entries_per_bucket = 8      ; TODO adjust if too low?
    const uword entrybuffer_size = $4000        ; TODO adjust later, to not overwrite IO beginning at $9f00!
    ubyte[num_buckets] bucket_entry_counts
    uword bucket_entry_pointers = memory("entrypointers", num_buckets*max_entries_per_bucket*2)
    ubyte num_entries
    uword entrybuffer   ; the entry buffer is a large block of memory in which the entries are stored.
                        ; an entry consists of:
                        ;  *    2 BYTES: value
                        ;  *     1 BYTE: datatype
                        ;  * 2-32 BYTES: symbolname (terminated with 0)

    ; TODO old stuff:
    const ubyte old_max_entries = 128
    uword[old_max_entries] old_values
    ubyte[old_max_entries] old_datatypes


    sub init() {
        entrybuffer = memory("entrybuffer", entrybuffer_size)   ; reset entrybuffer
        sys.memset(&bucket_entry_counts, num_buckets, 0)
        num_entries = 0

        txt.print("memtop=")
        txt.print_uwhex(sys.progend(), true)
        txt.nl()
    }

    sub add_entry(ubyte hash, uword symbol, uword value, ubyte datatype) -> ubyte {
        ; NOTE: this routine assumes the symbol DOES NOT EXIST in the table yet!
        ; TODO actually store the symbol in the table as well
        ; TODO give error message and return false, if entrybuffer is full
        bucket_entry_counts[hash] ++
        if bucket_entry_counts[hash] > max_entries_per_bucket {
            txt.print("\n?hash bucket full, choose another symbol name\n")
            return false
        }


        ; TODO make use of an actual hashtable
        pokew(bucket_entry_pointers+num_entries*2, entrybuffer)
        entrybuffer += 3 ; TODO for now skip the value and datatype bytes
        entrybuffer += string.copy(symbol, entrybuffer) + 1
        old_values[num_entries] = value
        old_datatypes[num_entries] = datatype

        num_entries++
        return true
    }

    sub existing_entry(ubyte hash, uword symbol) -> ubyte {
        if bucket_entry_counts[hash]
            return symbols.getvalue(symbol)  ; TODO use hashtable
        return false
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
