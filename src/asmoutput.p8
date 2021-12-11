; This handles the actual output of the machine code bytes.
; This is mostly ran in phase 2 of the assembler.
; (phase 1 just tracks the program counter)

%import textio
%import errors

output {
    uword program_counter
    uword pc_min
    uword pc_max
    ubyte start_output_bank
    ubyte next_output_bank
    uword bank_output_addr

    sub init(ubyte phase) {
        when phase {
            1 -> {
                program_counter = $ffff
                pc_min = $ffff
                pc_max = $0000
                ubyte numbanks = cx16.numbanks()
                if numbanks<10 {
                    err.print("too few ram banks (needs 10 or more)")
                    sys.exit(1)
                }
                start_output_bank = numbanks-8        ; 8 top banks = 64 kilobyte output size
            }
            2 -> {
                ; during phase 1, pc_min and pc_max have been set indicating the block of memory
                ; that is going to be filled with the output, this info is used when the output file is written.
                ; so don't reset those values in this phase here!
                next_output_bank = start_output_bank
                bank_output_addr = $a000
            }
        }
    }

    sub set_pc(uword addr) {
        program_counter = addr
        if program_counter<pc_min
            pc_min = program_counter
        if program_counter>pc_max
            pc_max = program_counter
    }

    sub inc_pc(ubyte num_operand_bytes) {
        program_counter++
        program_counter += num_operand_bytes
    }

    sub add_pc(uword amount) {
        program_counter += amount
    }

    sub emit(ubyte value) {
        cx16.rambank(next_output_bank)      ; always select ram bank because other code changes this
        @(bank_output_addr) = value
        program_counter++
        bank_output_addr++
        if msb(bank_output_addr) == $c0 {
            ; address has reached $c000, switch to next output ram bank
            bank_output_addr = $a000
            next_output_bank++
        }
    }

    sub done() {
        if program_counter>pc_max
            pc_max = program_counter
    }
}
