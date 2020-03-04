#the genome smaples
SAMPLES=[ "1",
        "2",
        "3",
        "4",
        "5"]

#all the outputs
rule all:
    input:
       # expand("{number}.fa.gz", number=SAMPLES),
        #expand("{number}-genome.sig", number=SAMPLES),
        "all.cmp",
        "all.cmp.hist.png",
        "all.cmp.dendro.png",
        "all.cmp.matrix.png"

#download the genomes
rule get_all_that_data:
    output:
        "1.fa.gz",
        "2.fa.gz",
        "3.fa.gz",
        "4.fa.gz",
        "5.fa.gz"
    shell: """wget https://osf.io/t5bu6/download -O 1.fa.gz 
           wget https://osf.io/ztqx3/download -O 2.fa.gz 
           wget https://osf.io/w4ber/download -O 3.fa.gz 
           wget https://osf.io/dnyzp/download -O 4.fa.gz 
           wget https://osf.io/ajvqk/download -O 5.fa.gz"""

#use sourmash on genomes to compute
rule compute_the_sourmash_stuff:
    input:
        "{sample}.fa.gz"
    output:
        "{sample}-genome.sig"
    shell:
       "sourmash compute --scaled 1000 -k 31 {input} -o {output}"

#compare all genomes
rule compare_the_compute_stuff:
    input:
        "1.fa.gz",
        "2.fa.gz",
        "3.fa.gz",
        "4.fa.gz",
        "5.fa.gz"
    output:
        "all.cmp"
    shell:
        "sourmash compare *.sig -o all.cmp"

#plot the information from the comparison files
rule plot_the_comparison:
    input:
        "all.cmp",
        "all.cmp.labels.txt"
    output:
        "all.cmp.hist.png",
        "all.cmp.dendro.png",
        "all.cmp.matrix.png"
    shell: 
        "sourmash plot --labels all.cmp"

