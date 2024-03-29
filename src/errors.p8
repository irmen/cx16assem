%import textio
%import diskio

err {
    sub print(str message) {
        txt.print("\n?")
        txt.print(message)
        txt.nl()
    }

    sub print2(str message, str extra) {
        txt.print("\n?")
        txt.print(message)
        txt.spc()
        txt.print(extra)
        txt.nl()
    }

    sub print_disk_status() {
        print(diskio.status())
    }
}
