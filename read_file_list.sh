#!/bin/bash
if [ $# != 2 ];then
	echo "Usage:$0 < <directory_name> <package_name>"
  exit 1;
fi
BOUNDARY="d295c3e6-05d5-4fbf-8d62-08828fed6979"
LINE_FEED="
"
MULTIPART="Content-Type: multipart/related; $LINE_FEED"
BOUNDARY_HEADER="boundary=\"${BOUNDARY}\"${LINE_FEED}"
START_BOUDARY="--${BOUNDARY}${LINE_FEED}"
STOP_BOUDARY="--${BOUNDARY}--${LINE_FEED}"
ENVELOPE_MIME_TYPE="Content-Type: application/mbms-envelope+xml$LINE_FEED"
ENVELOPE_FILE_LOCATION="Content-Location: envelope.xml$LINE_FEED"
CONTENT_TRANSFER_ENCODING="Content-Transfer-Encoding: binary$LINE_FEED"
CONTENT_LOCATION="Content-Location: "
CONTENT_TYPE="Content-Type: "
# Get absolute path of current directory
current_dir=$1
XML_HEADER="<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
ENVELOPE_START="<metadataEnvelope xmlns=\"urn:3gpp:metadata:2005:MBMS:envelope\">"
ENVELOPE_STOP="</metadataEnvelope>"
# List all files in the current directory and its subdirectories with absolute path
echo $MULTIPART > $2
printf "\t" >> "$2"
echo $BOUNDARY_HEADER >> $2
echo $LINE_FEED >> $2
echo $START_BOUDARY >> $2
echo $ENVELOPE_MIME_TYPE >> $2
echo $ENVELOPE_FILE_LOCATION>> $2
echo $LINE_FEED >> $2
echo $XML_HEADER >> $2
echo $ENVELOPE_START >> $2
#TMP_FILE="/tmp/filelist"
TMP_FILE="filelist"
rm -rf $TMP_FILE
find "$current_dir" -type f | while read file
do
    # Get file length
    file_length=$(stat -c %s "$file")
    # Get MIME type of file
    #mime_type=$(file --mime-type -b "$file")
    file_extension="${file##*.}"  # Extract the file extension
    case "$file_extension" in
	    "txt")
		    mime_type="text/plain"
		    ;;
	    "js")
		    mime_type="application/javascript"
		    ;;
	    "css")
		    mime_type="text/css"
		    ;;
	    "svg")
		    mime_type="image/svg+xml"
		    ;;
	    "jpeg")
		    mime_type="image/jpeg"
		    ;;
	    "jpg")
		    mime_type="image/jpeg"
		    ;;
	    "png")
		    mime_type="image/png"
		    ;;
	    "gif")
		    mime_type="image/gif"
		    ;;
	    "mp4")
		    mime_type="video/mp4"
		    ;;
	    "mov")
		    mime_type="video/quicktime"
		    ;;
	    "webm")
		    mime_type="video/webm"
		    ;;
	    "json")
		    mime_type="application/json"
		    ;;
	    "html")
		    mime_type="text/html"
		    ;;
	    *)
		    # Default case
		    echo "Unknown Extension $file"
		    mime_type=$(file --mime-type -b "$line")
		    ;;
    esac
    # Print file path, length, and MIME type
    #    echo "File: $file, Length: $file_length bytes, MIME Type: $mime_type"
    echo "  <item metadataURI=\"$file\" version=\"0\" contentType=\"$mime_type\" contentLength=\"$file_length\"/>"$LINE_FEED >> $2
   echo $file >> $TMP_FILE 
done
echo ${ENVELOPE_STOP}${LINE_FEED} >> $2
echo ${LINE_FEED} >> $2
remove_last_newline_or_carriage_return() {
    local input="$1"
    # Use parameter expansion to remove the last character if it's a newline or carriage return
    if [[ "${input: -1}" == $'\n' || "${input: -1}" == $'\r' ]]; then
        echo "${input:0:-1}"
    else
        echo "$input"
    fi
}
# Read the file line by line
while IFS= read -r line; do
	echo "$line"
	echo $START_BOUDARY >> $2
	file_extension="${line##*.}"  # Extract the file extension
	case "$file_extension" in
	    "txt")
		    mime_type="text/plain"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    #printf "%s" "$(cat "$line")" >> $2
		    cat "${line}" >> $2
		    echo "" >> $2
		    ;;
	    "js")
		    mime_type="application/javascript"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    printf "%s" "$(cat "$line")" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "css")
		    mime_type="text/css"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line}" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "svg")
		    mime_type="image/svg+xml"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line:-1}" >> $2
		    echo $LINE_FEED >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "jpeg")
		    mime_type="image/jpeg"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line:-1}" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "jpg")
		    mime_type="image/jpeg"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line:-1}" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "png")
		    mime_type="image/png"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line:-1}" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "gif")
		    mime_type="image/gif"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    cat "${line:-1}" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "mp4")
		    mime_type="video/mp4"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line:-1}" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "mov")
		    mime_type="video/quicktime"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line:-1}" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "webm")
		    mime_type="video/webm"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line:-1}" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "json")
		    mime_type="application/json"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line}" >> $2
		    echo "" >> $2
		    #printf "%s\n\n" "$(cat "$line")" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    "html")
		    mime_type="text/html"
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    printf "%s\n" "$(cat "$line")" >> $2
		    echo $LINE_FEED >> $2
		    ;;
	    *)
		    # Default case
		    echo "Unknown Extension $file"
		    mime_type=$(file --mime-type -b "$line")
		    echo ${CONTENT_TYPE}${mime_type}${LINE_FEED} >> $2
		    echo $CONTENT_TRANSFER_ENCODING >> $2
		    echo ${CONTENT_LOCATION}${line}${LINE_FEED} >> $2
		    echo $LINE_FEED >> $2
		    cat "${line:-1}" >> $2
		    echo "$LINE_FEED" >> $2
		    ;;
    esac
done < "$TMP_FILE"
echo $STOP_BOUDARY >> $2
