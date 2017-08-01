git 学习笔记 -- 程潇

//安装git
$ sudo apt-get install git
$ git config --global user.email "email@example.com"

//创建版本库
$ mkdir learngit
$ cd learngit
$ pwd
/Users/michael/learngit
$ git init

//将文件添加到版本库
$ git add readme.txt 可添加多个文件
$ git commit -m "wrote a readme file" 后面为说明文字

//查看git状态
$ git status

//比较某个文件的不同、
$ git diff readme.txt
$ cat readme.txt 查看文件具体

//查看git的日志信息，修改信息
$ git log
$ git log --pretty=oneline

//回退到版本
$ git reset --hard HEAD^ 回退到上一个版本
$ git reset --hard 3628164 回退到指定版本，后面为commit id

//查看过去提交的版本commit id
$ git reflog
ea34578 HEAD@{0}: reset: moving to HEAD^
3628164 HEAD@{1}: commit: append GPL
ea34578 HEAD@{2}: commit: add distributed
cb926e7 HEAD@{3}: commit (initial): wrote a readme file

//git add命令实际上就是把要提交的所有修改放到暂存区（Stage），然后，执行git commit就可以一次性把暂存区的所有修改提交到分支。

//丢弃工作区指定文件的更改
$ git checkout -- readme.txt
//丢弃暂存区指定文件的更改（工作区->add->暂存区->commit->版本库）
$ git reset HEAD readme.txt

//删除文件
    删除工作区的文件
$ rm test.txt
    删除版本库的文件
$ git rm test.txt
rm 'test.txt'
$ git commit -m "remove test.txt"

//恢复在工作区误删的文件（版本库中要有）
$ git checkout -- test.txt 注意空格

// 关联到远程仓库
$ git remote rm origin
$ git remote add origin https://github.com/chengxiao19961022/oc-learn.git
$ git push -u origin master
Counting objects: 19, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (19/19), done.
Writing objects: 100% (19/19), 13.73 KiB, done.
Total 23 (delta 6), reused 0 (delta 0)
To git@github.com:michaelliao/learngit.git
* [new branch]      master -> master
Branch master set up to track remote branch master from origin.

// 从远程库克隆
$ git clone git@github.com:michaelliao/gitskills.git
Cloning into 'gitskills'...
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (3/3), done.

$ cd gitskills
$ ls
README.md

// 分支相关操作（增删改查）
查看分支：git branch
创建分支：git branch <name>
切换分支：git checkout <name>
创建+切换分支：git checkout -b <name>
合并某分支到当前分支：git merge <name>
删除分支：git branch -d <name>

// 多人协作
查看远程库信息，使用git remote -v；

本地新建的分支如果不推送到远程，对其他人就是不可见的；

从本地推送分支，使用git push origin branch-name，如果推送失败，先用git pull抓取远程的新提交；

在本地创建和远程分支对应的分支，使用git checkout -b branch-name origin/branch-name，本地和远程分支的名称最好一致；

建立本地分支和远程分支的关联，使用git branch --set-upstream branch-name origin/branch-name；

从远程抓取分支，使用git pull，如果有冲突，要先处理冲突。













