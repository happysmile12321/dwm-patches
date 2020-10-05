# dwm-patches
I write some patches based on dwm6.It's so difficult to send email to suckless.org to patch software,so I created this repository.
我写了一些关于dwm6版本的补丁。给suckless发送邮件去提交补丁是如此的苦难，因此我创建了这个仓库。



## tools
- ./makepudding.sh
		* Use:source ./makepudding.sh
		* This can help you create a patch with dwm's format,(which I liked).
		* You can modify this script to apply your need through the comments.
- ./makepudding-cn.sh
		- 用法:source ./makepudding-cn.sh
		- makepudding.sh的中文版
		- 你可以通过注释来修改这个脚本以适应你的需求。


## patches

- ./dwm-autonowaitstart-20200303-61bb8b2.diff
		* This can create a thread,so if you have dwmblock or some what during starting dwm,then you needn't to wait.
		* If your dwm is really slow,then you can patch this.
		* 这个脚本创建了一个线程。当你用dwmblock或者别的什么启动脚本的时候，你就不需要等待了。
		* 如果你的dwm真的很慢，那就打上它。
