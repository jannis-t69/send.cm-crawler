#!/bin/bash

# Check if required utils (curl, wget)are installed
if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v wget)" ]; then
  echo 'Error: wget is not installed.' >&2
  exit 1
fi

### Set IFS to new line 
IFS=$'\n'

### Read user input 
read -p "Copy and paste the send.cm URL: "  pagelink

# comment the above read line and uncomment the below line for a test link
#pagelink="https://send.cm/s/163T/"

### Main export

# Write html open tags to file
echo '<!DOCTYPE html><html><body>'>links.html
### Get the subdirectories 
subDirs=$(curl -s $pagelink |  grep -E "class=\"link-02\"")

# Convert the variable to an array
read -d '' -a subDirsarray <<< $subDirs

for link in ${subDirsarray[@]}
    do 
        # extract the subdirectorie name
        temp=$(echo ${link} |cut -d '>' -f3)
        subDirName=${temp::-3}
        
        #extract the subdirectories URL        
        subDirLink=$(echo ${link} |cut -d '"' -f2)

        # get the last page number of the subdirectory
        lastPageNumber=$(curl -s $subDirLink |  grep -oP "(?<=page=).*?(?=')" | sort -nr | head -n1)

        # get the folder id
        folderID=$(curl -s $subDirLink |  grep -oP "(?<=id=).*?(?=&)" | head -n1)
        
        echo "Exporting: ( subDirName: $subDirName - subDirLink: $subDirLink - lastPageNumber: ${lastPageNumber} - folderID: $folderID )"
        # Loop through page 1 to last page
        for i in $(seq 1 $lastPageNumber)
            do
                # Extract the current page links into a variable
                wgetline=$(wget -erobots=off -q -O - "https://send.cm/?sort_order=down&sort_field=file_created&id="$folderID"&op=user_public&page="$i| grep -E "<a href=\"https://send.cm/[[:alnum:]]{12}\" class=\"tx-dark\">"| cut  -d'>' -f2-3)
                # Convert the variable to an array
                read -d '' -a wgetarray <<< $wgetline
                # Loop though array, add the missing html tags to each link and write it to file
                for link in ${wgetarray[@]}
                    do
                        echo ${link}'><br>'>> links.html
                        #echo ${link}
                done
        done
done
### Write html closing tags
echo '</body></html>'>>links.html
### Prompt and exit
echo -e "\nFinished export to $PWD/links.html file"
exit

