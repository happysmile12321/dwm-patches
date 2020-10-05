#####################################
#!/usr/bin/env bash


current_dir=$(pwd)
# @param:
# $1 = current_dir
# $2 = pudding_fullPath_dir
function print_location(){
		echo "#################PATH################"
		echo "当前你所在的路径为:$1"
		echo "当前你的补丁所在路径为:$2"
		echo "#####################################"
}
addToGitIgnore(){
		file=.gitignore
        if [[ `cat .gitignore|grep .gitignore` = "" ]]; then
				echo ".gitignore" >> .gitignore
        fi
		echo "$1" >> .gitignore
}
#################功能菜单##################
printMenu(){
    cmd_menu="
    #####################################
    \n1.复制补丁 到     当前路径
    \n2.移动补丁 到     当前路径
    \n3.移动     到     补丁所在路径
    \n#####################################
    "
    #打印菜单
    echo -e ${cmd_menu}
}
##################主逻辑开始###############
read -p  $'你要给谁打补丁?\n' who
read -p  $'你的补丁的目录在哪?\n' location
  # make sure right work dir
  echo -e "当前目录下有:\n" 
  ls  $location
  echo -e "当前目录下您刚刚修改的文件"
  # 找到补丁路径下的所有类型为文件的，修改时间小于1天的，(m是modify),然后把
  # 找到的结果作为ls的参数显示出来，然后再用过滤器过滤掉.git目录。
  find ${location}  -type f   -mtime -1 -exec ls -alh {} \; | grep -v ".git"

  # control
  read -p  $'是你想要的位置吗?[(Enter)/n]\n' a 
  if [[ $a = n || $a = N ]];then
  		echo "return"
  fi
#####################################
cd $location
read -p  $'请清楚地描述本次提交:(与主线有什么不同,增加了什么功能?(commit到suckless的内容))\n' commits 
read -p $'你的补丁的名字(尽量清晰的突出你的功能(补丁的名字))\n' patchname
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

# 搞事情
 git add .
 git commit -am"$commits"
 git format-patch --stdout HEAD^ > ${diffname}
echo "补丁${diffname}制作完成"
echo "制作的补丁的名称是:${diffname}"


#执行脚本的路径
current_dir=$current_dir
#补丁的路径+名字（补丁的全路径）
pudding_full_location="${location}/${diffname}"
# 用户来选择要做什么
printMenu
read -p  $'请输入你的选项:\n' chose

    #1.复制补丁 到     当前路径
    #2.移动补丁 到     当前路径
    #3.移动     到     补丁所在路径

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
				echo "没有你要找的操作"
				location_current=${current_dir}
				location_puddings=${location}
                #addToGitIgnore ${pudding_full_location}
				;;
esac
print_location ${location_current} ${location_puddings}
