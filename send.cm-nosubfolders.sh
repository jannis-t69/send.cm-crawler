#!/bin/bash

### Read user input
read -p "Copy and paste the last page button link: "  pagelink

### Get the last page number
lastPageNumber=$(echo ${pagelink} | cut -d '=' -f6)

### Get the main url without the = and the last page number
url=$(echo ${pagelink} | cut -d '=' -f1-5)

### Set IFS to new line 
IFS=$'\n'

### Main export
echo -n "Exporting links of page: "
# Write html open tags to file
echo '<!DOCTYPE html><html><body>'>links.html
# Loop through page 1 to last page
for i in $(seq 1 $lastPageNumber)
	do
		echo -n "$i.."
		# Extract the current page links into a variable
		wgetline=$(wget -erobots=off -q -O - "${url}="$i| grep -E "<a href=\"https://send.cm/[[:alnum:]]{12}\" class=\"tx-dark\">"| cut  -d'>' -f2-3)
		# Convert the variable to an array
		read -d '' -a wgetarray <<< $wgetline
		# Loop though array, add the missing html tags to each link and write it to file
		for link in ${wgetarray[@]}
			do
				echo ${link}'><br>'>> links.html
		done
done

### Write html closing tags
echo '</body></html>'>>links.html
### Prompt and exit
echo -e "\nFinished export to $PWD/links.html file"
exit