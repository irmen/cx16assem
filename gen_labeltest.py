
with open("labeltest.asm", "wt") as out:
    out.write("*=$6000\n")
    maximum = 80  # TODO increase once symbol table size allows more
    for idx in range(maximum):
        out.write(f"LABEL.NAME.{idx}\n")
        out.write(f"\tJMP  LABEL.NAME.{maximum-idx-1}\n")
        
