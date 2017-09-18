#!/bin/bash

#Creates backup of the collection passed and zips it to .tar format.
#ARGUMENTS:
#$1==Database
#$2==Collection to backup


HOSTNAME="localhost"
PORT="27017"
USERNAME=""
PASSWORD=""


BACKUP_PATH='/home/'$USER'/backups/'
BACKUP_FILE=$2_`date +%Y_%m_%d_%H_%M_%S`
TMP_BACKUP_FOLDER="tmp_$BACKUP_FILE"

# Auto detect unix bin paths, enter these manually if script fails to auto detect
MONGO_DUMP_BIN_PATH="$(which mongodump)"
TAR_BIN_PATH="$(which tar)"

# Create BACKUP_PATH directory if it does not exist
[ ! -d $BACKUP_PATH ] && mkdir -p $BACKUP_PATH || :


# Ensure directory exists before dumping to it
if [ -d "$BACKUP_PATH" ];then


		cd "$BACKUP_PATH"

		echo; echo "=> Backing up Mongo Server: $HOST:$PORT"; echo -n '   ';

		# run dump on mongoDB
		if [ "$USERNAME" != "" -a "$PASSWORD" != "" ]; then
			$MONGO_DUMP_BIN_PATH --host $HOST:$PORT -u $USERNAME -p $PASSWORD --db $1 --collection $2 --out "$TMP_BACKUP_FOLDER" >> /dev/null
		else
			$MONGO_DUMP_BIN_PATH --host $HOST:$PORT --db $1 --collection $2 --out "$TMP_BACKUP_FOLDER" >> /dev/null
		fi



		# check to see if mongoDb was dumped correctly
		if [ -d "$TMP_BACKUP_FOLDER" ]; then


				# zip dumped files into a tar file
				$TAR_BIN_PATH -czf $BACKUP_FILE.tar.gz $TMP_BACKUP_FOLDER


				# verify that the file was created
				if [ -f "$BACKUP_FILE.tar.gz" ]; then
					echo "=> Success: `du -sh $BACKUP_FILE.tar.gz`"; echo;


					# forcely remove if files still exist and tar was made successfully
					# this is done because the --remove-files flag on tar does not always work
					if [ -d "$BACKUP_PATH/$TMP_BACKUP_FOLDER" ]; then
						rm -rf "$BACKUP_PATH/$TMP_BACKUP_FOLDER"
					fi
				else
					 echo "!!!=> Failed to create backup file: $BACKUP_PATH/$FILE_NAME.tar.gz"; echo;
				fi


		else
			echo; echo "!!!=> Failed to backup mongoDB"; echo;
		fi

else
	echo "!!!=> Could not create backup path $BACKUP_PATH";
fi
