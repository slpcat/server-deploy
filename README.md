ansible 安装初始化

pip3 install -r requirements.txt

#安装mitogen插件
ansible-playbook -v mitogen.yml

# 脚本运行示例
系统仅用于centos7

deploy_env 环境列表：
debug
dev
alpha
stress
qa_function
qa_stress

demo 运维演示

变量作用范围与优先级

特定主机host_vars/<IP地址>.yml
特定环境group_vars/<环境>.yml
特定程序/服务inventory/<invent>.yml
全局范围group_vars/all.yml

初始化各个环境下的主机节点


ansible-playbook -v -i inventory/example.yml init-node-centos7.yml --extra-vars "deploy_env=debug"

init-node节点初始化完成后，需要重启生效。

todo
初始化windows服务器,目标ssh统一管理windows和linux服务器
安装python，zabbix-agent，ghostscript，git，office，
调整注册表
安装wsl-centos7，配置sshd 启动脚本,zabbix-agent,salt-minion
WSLsshAutoStart.cmd
c:\Users\<user>\AppData\Local\Microsoft\WindowsApps\ubuntu18.04.exe "sudo service ssh start"
winuser staff
linuxuser staff


ansible-playbook -v -i inventory/server.yml init-win-node.yml --extra-vars "deploy_env=debug"

程序运行环境初始化
依赖包
下载安装包/二进制文件
supervisord启动文件
zk初始化
配置文件
filebeat

ansible-playbook -i inventory/app.yml init-app.yml --extra-vars "deploy_env=debug app_version=20200606-v1.0.0"

注意:
app_version 对应文件GIT_VERSION里面的版本/jenkins编译输出版本/文件仓库存储版本

todo

初始化windows程序运行环境
ghostscript

ansible-playbook -i inventory/server.yml init-win-app.yml --extra-vars "deploy_env=debug app_version=20200606-v1.0.0"

默认就是滚动升级

必须指定版本
app_version

ansible-playbook -i inventory/app.yml upgrade-app.yml --extra-vars "deploy_env=debug app_version=20200606-v1.0.0"

* 部署失败后的回滚

部署新版本 升级
部署旧版本 回滚

回滚操作等同升级，只是版本区别

* 灰度发布 指定灰度节点
ansible-playbook -i inventory/app.yml upgrade-app.yml --extra-vars "deploy_env=debug app_version=20200606-v1.0.0" --limit 172.17.0.1

* 水平扩容(scale out)

水平扩容操作等同升级，只是保持当前版本不变，节点数增加。

* 水平缩容

摘除流量，停止服务



https://mirrors.aliyun.com/alinux/image/
