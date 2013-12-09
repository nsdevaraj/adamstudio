#! /bin/sh
if [ ! -f "$*" ]; then
  echo 'KO:[File not found "'$*'"]'
  exit 1
fi

cp "$*" /tmp/pdf2swf$$.pdf
basefile=$( dirname "$*" )/$( basename "$*" | sed -e 's/[éèçàêëôöîïûüâäùœæ]/_/g'  \
                                            | sed -e 's/[^a-zA-Z0-9\-\_\+\.\%\#\~\/ ]/_/g' )
# if [ "$2" == '' ]; then
  convopts="-f -T10 -t"
# else
#   convopts="$2"
# fi
# if [ "$3" == '' ]; then
  combopts=""
# else
#   combopts="$3"
# fi

echo -n "OK:[" > /tmp/pdf2swf$$.fil
pdf2swf -I /tmp/pdf2swf$$.pdf | grep '^page=' | \
       awk '{print $1}' | cut -d"=" -f2 | while read pagenum; do
  pdf2swf $convopts -p$pagenum /tmp/pdf2swf$$.pdf /tmp/pdf2swf$$.swf > /tmp/pdf2swf$$.log 2>&1
  if [ ! -e /tmp/pdf2swf$$.swf ]; then
    echo 'KO:[Error in PDF2SWF conversion. Report is /tmp/pdf2swf'$$'.log:'
    cat /tmp/pdf2swf$$.log
    echo ']'
    exit 1
  fi
  dims=$( swfbbox /tmp/pdf2swf$$.swf )
  # Returned words 7 and 9 are the dimensions given with SWFtools ver. 0.9.0
  # Returned words 4 and 6 are the dimensions given with SWFtools ver. 0.8.x
  dim_x=$( echo $dims | awk '{print $7}' )
  dim_y=$( echo $dims | awk '{print $9}' )
  outfile=$( echo $basefile | sed -e 's/\.pdf$//' )'-'$pagenum'.swf'
  swfcombine -X $dim_x -Y $dim_y $combopts /home/brennus/pdfswftools/ContentMergeTemplate.swf cont_mc=/tmp/pdf2swf$$.swf -o "$outfile"
  echo -n $outfile"," >> /tmp/pdf2swf$$.fil
done

cat /tmp/pdf2swf$$.fil | sed -e "s/,$/]/"

rm /tmp/pdf2swf$$.pdf 2>/dev/null
rm /tmp/pdf2swf$$.fil 2>/dev/null
rm /tmp/pdf2swf$$.swf 2>/dev/null
rm /tmp/pdf2swf$$.log 2>/dev/null

