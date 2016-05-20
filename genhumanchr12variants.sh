#!/bin/bash
#
# Generates simulated variants
#
. common.sh

FULL_JAR=~/bin/gridss-*-jar-with-dependencies.jar
#CX_REFERENCE=~/refdata/genomes/chr12.fa
CX_REFERENCE=~/reference_genomes/human/hg19.fa
CX_CHROMOSOME=chr12
CX_REFERENCE_VCF_PADDING=2500
			
# $1: name
# $2: sim
# $3: additional args
function sim() {
	CX_REFERENCE_VCF_VARIANTS="$1"
	cx_save
	XC_OUTPUT=$CX.reference.fa
	XC_SCRIPT="rm -rf $CX; mkdir $CX 2>/dev/null; cd $CX
	java -Xmx7g -cp $FULL_JAR \
			$2 \
			CHR=$CX_CHROMOSOME \
			PADDING=$CX_REFERENCE_VCF_PADDING \
			REFERENCE=$CX_REFERENCE \
			VCF=reference.vcf \
			FASTA=reference.fa \
			$3 &&
	mv reference.vcf $CX.reference.vcf &&
	mv reference.fa $CX.reference.fa
	"
	xc_exec
}

for VARIANT_TYPE in INS DEL DUP INV ; do
	sim "het${VARIANT_TYPE}" au.edu.wehi.idsv.sim.GenerateSimpleVariants "\
		INCLUDE_REFERENCE=true \
		COPIES=500 \
		TYPE=null TYPE=$VARIANT_TYPE \
		"
done

sim "hetBP" au.edu.wehi.idsv.sim.GenerateChromothripsis "\
	INCLUDE_REFERENCE=true \
	FRAGMENT_SIZE=2000 \
	FRAGMENTS=10000 \
	"
	
sim "hetBP_SINE" au.edu.wehi.idsv.sim.GenerateChromothripsis "\
	INCLUDE_REFERENCE=true \
	FRAGMENT_SIZE=2000 \
	FRAGMENTS=10000 \
	RM=~/Papenfuss_lab/projects/reference_genomes/human/hg19/UCSC/repeatmasker/12/chr12.fa.out \
	CLASS_FAMILY=SINE/Alu \
	"

# sim "homBP" au.edu.wehi.idsv.sim.GenerateChromothripsis "\
	# INCLUDE_REFERENCE=false \
	# FRAGMENT_SIZE=2000 \
	# FRAGMENTS=10000 \
	# "
	
# sim "homBP_SINE" au.edu.wehi.idsv.sim.GenerateChromothripsis "\
	# INCLUDE_REFERENCE=false \
	# FRAGMENT_SIZE=2000 \
	# FRAGMENTS=10000 \
	# RM=~/Papenfuss_lab/projects/reference_genomes/human/hg19/UCSC/chromOut/12/chr12.fa.out \
	# CLASS_FAMILY=SINE/Alu \
	# "

