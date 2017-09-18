#Create backup collection in backup database


mongorestore  --host "localhost:27017" --db "pimms_dev"  --collection $backupcollection	 --dir=/home/$USER/backups/$1/$2.bson

