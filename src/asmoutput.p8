; This handles the actual output of the machine code bytes.
; This is mostly ran in phase 2 of the assembler.
; (phase 1 just tracks the programcounter)

output {
    uword program_counter = $ffff
    uword pc_min = $ffff
    uword pc_max = $0000

    sub init(ubyte phase) {
        ; nothing special yet
        ; if phase==2, pc_min and pc_max have been set in phase1 to indicate the block of memory
        ; that is going to be filled with the output, this info could be useful for something
    }

    sub set_pc(uword addr) {
        program_counter = addr

        ; TODO get rid of this warning once we no longer assemble to system memory directly
        if program_counter < $9000
            txt.print("\n\n\x12warning: pc is <$9000 which is system memory used by the assembler!\nrisk of data corruption and weird errors!\x92\nthis problem will probably be fixed in a future version!\n\n")

        if program_counter<pc_min
            pc_min = program_counter
        if program_counter>pc_max
            pc_max = program_counter
    }

    sub inc_pc(ubyte num_operand_bytes) {
        program_counter++
        program_counter += num_operand_bytes
    }

    sub emit(ubyte value) {
        @(program_counter) = value
        program_counter++
    }

    sub done() {
        if program_counter>pc_max
            pc_max = program_counter
    }
}
