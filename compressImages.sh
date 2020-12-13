#!/bin/bash

if [[ -z $1 ]]; then
	echo "Please enter image file extension as first parameter."
	echo "Example: compressImages jpg|jpeg"
	exit 1
fi

if [[ "$1" == "-h" ]]; then
	echo "Bash script using gnu parallel and imagemagick to compress imagess to max specified size."
	echo "Maximum size limit is not always guranteed but it works in general."
	echo "Use: bash compressImages jpg|jpeg <max output size in kb>"
	exit 0
fi

if [[ "$1" != "jpg" && "$1" != "jpeg" && "$1" != "JPG" && "$1" != "JPEG" ]]; then
       echo "Only jpg images are supported!"
       exit 2
fi       

if [[ -z $2 ]]; then
	echo "Second parameter is size in KB"
	echo "Example: compressImages jpg 200"
	exit 1
fi

re='^[0-9]+$'
if ! [[ $2 =~ $re ]] ; then
   echo "Number is required for size in kb."
   exit 2
fi


echo "Creating directory KB$2/ to store resized images.."
mkdir "KB$2"
echo "Starting compression..."
parallel -j 8 convert {} -define jpeg:extent="$2kb" "KB$2"/{} ::: *.$1
echo "Done!"
