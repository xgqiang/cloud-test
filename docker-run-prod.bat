::docker运行服务URL
::操作/项目路径(Dockerfile存放的路劲)
::BASE_PATH=/var/lib/jenkins/workspace
BASE_PATH=/Users/xuguangqiang/IdeaProjects
:: 源项目工作空间
::SOURCE_PATH=/var/lib/jenkins/workspace
::docker 镜像路径，也是父项目路径
::PARENT_PATH=Booking-Center
PARENT_PATH=cloud-test
::docker 镜像/容器/项目名字或者jar名字数组 这里都使用项目名命名
PROJECT_NAMES=("node1" "node2" "node3")
::项目版本号/docker 容器tag,使用项目版本号来做tag，版本号要与项目数组PROJECT_NAMES一一对应
PROJECT_VERSIONS=("0.0.1-SNAPSHOT" "0.0.1-SNAPSHOT" "0.0.1-SNAPSHOT")
::docker容器暴露的端口，端口号要与项目数组PROJECT_NAMES一一对应，这里为了简化，docker容器端口与宿主机端口配置成一样的。
EXPOSE_PORTS=("7710" "7720" "7730")

::::::::::::::::::::::::::::以下内容不用修改

DATE=`date +%Y%m%d%H%M`

::创建项目环境目录
function projectDir(){
    for (( i = 0 ; i < ${::PROJECT_NAMES[@]} ; i++ ))
    do
      if [ ! -e $BASE_PATH/$PARENT_PATH/${PROJECT_NAMES[$i]} ] && [ ! -d $BASE_PATH/$PARENT_PATH/${PROJECT_NAMES[$i]} ];
        then
            mkdir -p $BASE_PATH/$PARENT_PATH/${PROJECT_NAMES[$i]}
            echo "Create Dir: $BASE_PATH/$PARENT_PATH/${PROJECT_NAMES[$i]}"
        fi
    done

}

:: 构建docker镜像
function build(){

    for (( i = 0 ; i < ${::PROJECT_NAMES[@]} ; i++ ))
    do
        ::镜像id
        IID=$(docker images | grep "${PROJECT_NAMES[$i]}" | awk '{print $3}')
        if [ -n "$IID" ]; then
            echo "存在${PROJECT_NAMES[$i]}镜像，IID=$IID"
            echo "删除${PROJECT_NAMES[$i]}镜像..."
            docker rmi $IID
            echo "重新构建镜像"
            cd $BASE_PATH/$PARENT_PATH/${PROJECT_NAMES[$i]}
            docker build -t ${PROJECT_NAMES[$i]} .
        else
            echo "不存在${PROJECT_NAMES[$i]}镜像，开始构建镜像"
            cd $BASE_PATH/$PARENT_PATH/${PROJECT_NAMES[$i]}
            docker build -t ${PROJECT_NAMES[$i]} .
        fi
    done


}

function delContainer(){

    for (( i = 0 ; i < ${::PROJECT_NAMES[@]} ; i++ ))
    do
        ::容器id
        CID=$(docker ps -a | grep "${PROJECT_NAMES[$i]}" | awk '{print $1}')
        if [ -n "$CID" ]; then
            echo "存在${PROJECT_NAMES[$i]}容器，CID=$CID,停止并删除docker容器 ..."
            docker rm -f $CID
            echo "${PROJECT_NAMES[$i]}容器停止删除完成"
        else
            echo "不存在${PROJECT_NAMES [$i]}容器"
        fi
    done

}

:: 运行docker容器
function run(){
    projectDir
    delContainer
    build

    ::启动容器，我们采用docker compose来编排docker容器,解决docker容器之间网络访问的问题
    ::先编写docker-compose.yml文件后，放入项目路径下
    cd  $BASE_PATH/$PARENT_PATH
    docker-compose up -f docker-compose-prod.yml
}

::入口
run