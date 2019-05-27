#!/usr/bin/env bash
# Convert MyISAM tables to InnoDB with WP-CLI

# Check if any of your tables are using MyISAM instead of InnoDB
echo "Checking if any of your tables are using MyISAM instead of InnoDB..."
wp db query "SHOW TABLE STATUS WHERE Engine = 'MyISAM'" --allow-root

# If any of your tables are using MyISAM instead of InnoDB
if [[ $(wp db query "SHOW TABLE STATUS WHERE Engine = 'MyISAM'" --allow-root) ]] ; then
	while true; do
    	read -p "Would you like to convert all WordPress MyISAM database tables to InnoDB? " yn
		case $yn in
			[Yy]* )
			# Create array of MyISAM tables
			TABLES=($(wp db query "SHOW TABLE STATUS WHERE Engine = 'MyISAM'" --allow-root --silent --skip-column-names | awk '{ print $1 }'))

			# Loop through tables and alter tables
			for TABLE in ${TABLES[@]}
			do
				echo "Converting ${TABLE} to InnoDB..."
				wp db query "ALTER TABLE ${TABLE} ENGINE=InnoDB" --allow-root
				echo "Converted ${TABLE} to InnoDB!"
			done;

			echo "Checking if there are any MyISAM tables left..."
			wp db query "SHOW TABLE STATUS WHERE Engine = 'MyISAM'" --allow-root
			wp db query "SHOW TABLE STATUS WHERE Engine = 'InnoDB'" --allow-root
			echo "All of your tables are now InnoDB."
			break;;

			[Nn]* ) exit;;
			* ) echo "Please answer Y/y (yes) or N/n (no).";;
		esac
	done
else
	echo "All of your tables are InnoDB."
fi