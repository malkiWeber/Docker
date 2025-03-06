
script_folder='scripts'

OPTIONS="init delete exec deploy prune info"



if [ $# -eq 0 ]; then

echo "./automation.sh <-i|-d|-e|-de|-p|-in> <arguments>"

echo "Options:"

echo "  -i, --init   <Version> Build chat-app image with the version provided and run the chat-app container with mounted volumes"

echo "  -d, --delete <Version> Delete chat-app container and the specified chat-app image"

echo "  -e, --exec             Open a bash shell as root inside the chat-app container"

echo "  -de,--deploy <version> <commit-hash>"

echo "                         Build, tag, and push the chat-app image with the specified tag to GCR and [OPTIONAL]tag and push the commit hash"

echo "  -p, --prune            Prune all Docker resources"

echo "  -in, --info            Show all Docker resources"

exit 1

fi





#!/bin/bash

<<<<<<< HEAD
# Initialize an associative array to map flags to script names
declare -A flag_to_script
flag_to_script["-d"]="delete.sh"
flag_to_script["--delete"]="delete.sh"
flag_to_script["-i"]="init.sh"
flag_to_script["--init"]="init.sh"
flag_to_script["-p"]="prune.sh"
flag_to_script["--prune"]="prune.sh"
flag_to_script["-in"]="info.sh"
flag_to_script["--info"]="info.sh"
flag_to_script["-dep"]="deploy.sh"
flag_to_script["--deploy"]="deploy.sh"
=======
>>>>>>> 34170bc6d504e66ac222195c38321fe1ba83586e


# Function to display usage information

display_usage() {

echo "./auto.sh <-i|-d|-e|-de|-p|-in> <arguments>"

echo "Options:"

echo "  -i, --init   <Version> Build chat-app image with the version provided and run the chat-app container with mounted volumes"

echo "  -d, --delete <Version> Delete chat-app container and the specified chat-app image"

echo "  -e, --exec             Open a bash shell as root inside the chat-app container"

echo "  -de,--deploy <version> <commit-hash>"

echo "                         Build, tag, and push the chat-app image with the specified tag to GCR and [OPTIONAL]tag and push the commit hash"

echo "  -p, --prune            Prune all Docker resources"

echo "  -in, --info            Show all Docker resources"

exit 1

}



# Check if at least one argument is provided

if [ $# -eq 0 ]; then
<<<<<<< HEAD
  echo "Usage: $0 [-d|--delete|-i|--init|-p|--prune|-in|--info|-dep|--deploy]"
  # exit 1
fi

# Check if the provided flag is in the associative array
if [ "${flag_to_script[$1]}" ]; then
  script_to_run="${flag_to_script[$1]}"
  ./scripts/"$script_to_run"
else
  echo "Invalid flag: $1"
  echo "Usage: $0 [-d|--delete|-i|--init|-p|--prune|-in|--info]"
  # exit 1
fi
=======

    display_usage

fi

>>>>>>> 34170bc6d504e66ac222195c38321fe1ba83586e


# Parse command-line options

while [ $# -gt 0 ]; do

    case "$1" in (-i|--init)

            if [ -n "$2" ]; then

                echo "Running init.sh with version $2"

                ./${script_folder}/init.sh "$2"

                shift 2

            else

                echo "Error: Version argument is missing for -i option."

                display_usage

            fi

            ;;

        -d|--delete)

            if [ -n "$2" ]; then

                echo "Running delete.sh with version $2"

                ./${script_folder}/delete.sh "$2"

                shift 2

            else

                echo "Error: Version argument is missing for -d option."

                display_usage

            fi

            ;;

        -e|--exec)

            echo "Opening a bash shell as root inside the chat-app container"

            # Add your command to open a bash shell here

            docker exec -it chat-app-run bash

            shift

            ;;

        -de|--deploy)

            if [ -n "$2" ] && [ -n "$3" ]; then

                echo "Building, tagging, and pushing chat-app image with tag $2 to GCR."

                echo "Optional: Tag and push commit hash $3"

                ./${script_folder}/deploy.sh $2 $3

                shift 3

            else

                echo "Error: Missing arguments for -de option."

                display_usage

            fi

            ;;

        -p|--prune)

            echo "Running prune.sh"

            ./${script_folder}/prune.sh

            shift

            ;;

        -in|--info)

            echo "Running info.sh"

            ./${script_folder}/info.sh

            shift

            ;;

        *)

            echo "Error: Unknown option $1"

            display_usage

            ;;

    esac

done

