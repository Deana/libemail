#!/bin/bash

BASE=$HOME/normalized/

mkdir -p var
for file in `cat outstanding.complaints`
do
        # convert file to the
        IDX=$(./convert_filename_to_index.pl $file | awk '{print $NF}')
	if [ "$IDX" != "=>" ]; then
		echo "Processing $file"
		./blast.pl ${BASE}/$IDX > var/blast.sig.$IDX
	fi
done
