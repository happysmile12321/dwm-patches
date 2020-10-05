#####################################
#!/usr/bin/env bash
current_dir=$(pwd)

# @param:
# $1 = current_dir
# $2 = pudding_fullPath_dir
function print_location(){
		echo "#################PATH################"
		echo "Now your path:$1"
		echo "Now your patch path:$2"
		echo "#####################################"
}
addToGitIgnore(){
		file=.gitignore
        if [[ `cat .gitignore|grep .gitignore` = "" ]]; then
				echo ".gitignore" >> .gitignore
        fi
		echo "$1" >> .gitignore
}
#################Menu###################
printMenu(){
    cmd_menu="
    #####################################
    \n1.Copy patch to   Current dir 
    \n2.Move patch to   Current dir 
    \n3.Move       to   Patch dir 
    \n#####################################
    "
    #Print Menu
    echo -e ${cmd_menu}
}
##################Start Mainly Stuff##################
read -p  $'Who are you want to patch(dwm,st,...)?\n' who
read -p  $'Where to find your patches(patch dir)?\n' location
  # make sure right work dir
  echo -e "List some files in current dir \n" 
  ls  $location
  echo -e "These files are you just modified:"
  # find all files ,modify time less than one day,and list it,then grep the .git directory.
  find ${location}  -type f   -mtime -1 -exec ls -alh {} \; | grep -v ".git"

  # control
  read -p  $'Is the location you want to patch ?[(Enter)/n]\n' a 
  if [[ $a = n || $a = N ]];then
  		echo "return"
  fi
#####################################
cd $location
read -p  $'Please be clear:(What funcionlity of your patch?(commit to suckless.org))\n' commits 
read -p $'The name of your patch(Be clear it_s usage(The name of patch file))\n' patchname
toolname=git
patchname=$patchname
longhash=`git log|grep -m 1 'commit' |awk '{print $2}'`
shorthash=${longhash:0:7}
year=`git log|grep -m 1 'Date'|awk '{print $6}'`
month=`git log|grep -m 1 'Date'|awk '{print $3}'`
for i in "Jan" "Feb" "Mar" "Apr" "May" "June" "July" "Aug" "Sep" "Oct" "Nov" "Dec";do
		let j+=1;
		if [[ $month = $i ]];then
				jj=$j
				if [[ $month != "Oct" ]] && [[  $month != "Nov" ]]  &&  [[ $month != "Dec" ]];then
						jj=0${j}
				fi
				month=$jj
        else
            continue
        fi
done
day=`git log|grep -m 1 'Date'|awk '{print $4}'`
if [[ $day = "1" ]]           \
 || [[ $day = "2" ]]          \
 || [[ $day = "3" ]]          \
 || [[ $day = "4" ]]          \
 || [[ $day = "5" ]]          \
 || [[ $day = "6" ]]          \
 || [[ $day = "7" ]]          \
 || [[ $day = "8" ]]          \
 || [[ $day = "9" ]]  
then
		day=0${day}
fi
date="${year}${month}${day}"
diffname="${who}-${patchname}-${date}-${shorthash}.diff"

# do some things
 git add .
 git commit -am"$commits"
 git format-patch --stdout HEAD^ > ${diffname}
echo "Patch ${diffname} is done"
echo "The name of made patch is:${diffname}"


#where you run this script
current_dir=$current_dir
#pudding_parent_path + pudding_name
pudding_full_location="${location}/${diffname}"
# User chose to do what ?
printMenu
read -p  $'Please input your choice:\n' chose

	#	#################PATH################"
	#	Now your path:$1"
	#	Now your patch path:$2"
	#	#####################################"

case $chose in
		1)
				cp ${pudding_full_location} ${current_dir}
				location_current=${current_dir}
			    location_puddings="${location},${current_dir}"	
                #addToGitIgnore ${pudding_full_location}
				;;
		2)
				mv ${pudding_full_location} ${current_dir}
				location_current=${current_dir}
			    location_puddings="${current_dir}"	
				;;
		3)
				cd ${location}
				location_current=${location}
				location_puddings=${location}
                #addToGitIgnore ${pudding_full_location}
				;;

		*)
				echo "No find your option"
				location_current=${current_dir}
				location_puddings=${location}
                #addToGitIgnore ${pudding_full_location}
				;;
esac
print_location ${location_current} ${location_puddings}
