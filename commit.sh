#!/bin/bash

page_name=$1

echo "目前选择发布的页面名称为:${page_name}";
git_tag="tag__"
branch="master"

version=`less ./package.json |awk -F "[:]" '/version/{print$2}' | sed $'s/\"//g'|sed $'s/\ //g'|sed $'s/\,//g'`
package_name=`less ./package.json |awk -F "[:]" '/name/{print$2}' | sed $'s/\"//g'|sed $'s/\ //g'|sed $'s/\,//g'`
echo "当前的项目版本为:${version}"


if [ -z "$page_name" ]; then
  echo "没有输入要上线的页面名称"
  exit 8;
else
  git_tag=$git_tag"${page_name}__${version}"
fi

npm run build ${page_name}

currentTimeStamp=`date '+%s'`
git_tag=$git_tag"_${currentTimeStamp}"


git add .

git cz

git_tag_message1=`git show -2 --pretty=format:提交人：%cN   | awk 'NR<2 {print $0}' `
git_tag_message2=`git show -2 --pretty=format:提交信息说明:%s   | awk 'NR<2 {print $0}' `
message=`echo -e "${git_tag_message1}\n${git_tag_message2}"`

echo "git tag ${git_tag}  -m '${message}'"
git tag ${git_tag}  -m "${message}"

echo "git push origin ${branch}"
git push origin ${branch}

echo "git push origin ${git_tag}"
git push origin ${git_tag}

git push
