#!/bin/sh

# Goal:
#
# Workstation:
#                 Running Time        % Reads Mapped
#  Bowtie              YYm:ZZs                 XX.X%
#  Maq -n 1         Xh:YYm:ZZs                 XX.X%
#  Maq             XXh:YYm:ZZs                 XX.X%
#
# Server:
#                 Running Time        % Reads Mapped
#  Bowtie              YYm:ZZs                 XX.X%
#  Maq -n 1         Xh:YYm:ZZs                 XX.X%
#  Maq             XXh:YYm:ZZs                 XX.X%
#  SOAP -v 1       XXh:YYm:ZZs                 XX.X%
#  SOAP            XXh:YYm:ZZs                 XX.X%

dir=`pwd`
NAME=`basename $dir | sed 's/_.*//'`
echo Using NAME: ${NAME}
WORKSTATION=1
if [ ! -f $NAME.results.txt ] ; then
	sh summarize_all_top.sh > $NAME.results.txt
fi
if [ ! -f $NAME.maps.txt ] ; then
	sh analyze_maps.sh > $NAME.maps.txt
fi

# For a workstation:

# Bowtie
echo -n "Bowtie," > $NAME.results.bowtie.txt
tmp=`head -1 $NAME.results.txt | cut -d" " -f 2 | cut -d, -f 1`
echo -n "$tmp," >> $NAME.results.bowtie.txt 
head -2 $NAME.maps.txt | tail -1 | cut -d":" -f 3 >> $NAME.results.bowtie.txt

# Maq -n1
echo -n "Maq -n1," > $NAME.results.maq.n1.txt
tmp=`head -2 $NAME.results.txt | tail -1 | cut -d" " -f 2 | cut -d, -f 1`
echo -n "$tmp," >> $NAME.results.maq.n1.txt
head -4 $NAME.maps.txt | tail -1 | cut -d":" -f 3 >> $NAME.results.maq.n1.txt

# Maq
echo -n "Maq," > $NAME.results.maq.txt
tmp=`head -3 $NAME.results.txt | tail -1 | cut -d" " -f 2 | cut -d, -f 1`
echo -n "$tmp," >> $NAME.results.maq.txt
head -3 $NAME.maps.txt | tail -1 | cut -d":" -f 3 >> $NAME.results.maq.txt

if [ "$WORKSTATION" = "0" ] ; then
	# SOAP -v 1
	echo -n "SOAP -v 1," > $NAME.results.soap.v1.txt
	tmp=`head -4 $NAME.results.txt | tail -1 | cut -d" " -f 2 | cut -d, -f 1`
	echo -n "$tmp," >> $NAME.results.soap.v1.txt
	head -6 $NAME.maps.txt | tail -1 | cut -d":" -f 3 >> $NAME.results.soap.v1.txt

	# SOAP -v
	echo -n "SOAP," > $NAME.results.soap.txt
	tmp=`head -5 $NAME.results.txt | tail -1 | cut -d" " -f 2 | cut -d, -f 1`
	echo -n "$tmp," >> $NAME.results.soap.txt
	head -5 $NAME.maps.txt | tail -1 | cut -d":" -f 3 >> $NAME.results.soap.txt
fi

perl plot.pl
