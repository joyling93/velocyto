import os
import json
import pysam
import click

def addtag(bam, outdir, **kwargs):
    os.makedirs(outdir, exist_ok=True)
    samfile = pysam.AlignmentFile(bam, "rb")
    header=samfile.header
    bam_out=os.path.splitext(os.path.basename(bam))[0]
    bam_out=os.path.join(outdir, bam_out)
    out = pysam.AlignmentFile(bam_out + ".addtag.bam",'wb',header=header)

    for line in samfile :
        tag = line.query_name.split("_")
        cb = tag[0]
        ub = tag[1]
        line.tags += ([('CB',cb,"Z"),('XC',cb,"Z"),('UB',ub,"Z"),('XM',ub,"Z")]) 
        out.write(line)
    out.close()
    pysam.index(bam_out+ ".addtag.bam")
    #add_tag_bam = bam_out + ".atag.sorted.bam"
    #pysam.sort("-o", add_tag_bam, bam_out + ".addtag.bam")
    #pysam.index(bam_out + ".atag.sorted.bam")


@click.command()
@click.option('--bam', help='bam', required=True)
@click.option('--outdir', help='outdir', required=True)
def main(bam, outdir):
    addtag(bam, outdir)



if __name__ == "__main__":
	main()
    
