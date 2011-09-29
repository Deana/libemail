#!/bin/bash
#
# We need to have some files available before processing
#
# abuse@abuse:/abuse/AUP/bin$ ./read_index.pl | perl -lane 'print $1 if /filename=\[(\S+?)\]/' > ~/total.complaints
# abuse@abuse:/abuse/AUP/bin$ ./read_index_trimmed.pl | perl -lane 'print $1 if /filename=\[(\S+?)\]/' > ~/outstanding.complaints 

cd ..
export CGROOT=$(pwd)
cd -
mkdir -p $CGROOT/var/
mkdir -p $CGROOT/var/normalized/

if [ ! -f $CGROOT/var/total.complaints ]; then
	echo "You must have total.complaints before processing"
	exit 1
fi

# Step 1: Normalize ALL of the complaint messages
echo "Populating database"
${CGROOT}/bin/populate_db.sh ${CGROOT}/var/total.complaints

# Step 2: blast all of the files
echo "Executing blast script"
$CGROOT/bin/blast.pl ${CGROOT}/var/normalized/* > $CGROOT/var/blast.all

# Generate a mini blast all
echo "Generating blast delta file"
cat $CGROOT/var/total.complaints | xargs $CGROOT/bin/convert_filename_to_index.pl | awk '{print $NF}' | xargs -n1 printf "%s/%d\n" $CGROOT/var/normalized > $CGROOT/var/blast.mini.files
fgrep -f $CGROOT/var/blast.mini.files < $CGROOT/var/blast.all > $CGROOT/var/blast.all_ 
mv $CGROOT/var/blast.all_ $CGROOT/var/blast.all || rm -f $CGROOT/var/blast.all_

## Step 3: Import blast.all into redis
echo "Executing import blast script"
$CGROOT/bin/import_blast.pl $CGROOT/var/blast.all
