#!/bin/bash

# customize.sh

# 替换 App 显示在系统中名字
sed -i "" -e "s/easyVideo/好应用/g"  ../easyVideo/easyVideo/zh-Hans.lproj/InfoPlist.strings
sed -i "" -e "s/easyVideo/GreatAPP/g"  ../easyVideo/easyVideo/en.lproj/InfoPlist.strings

# 替换版权信息显示的公司名字，根据需要您还可以替换更多文字
sed -i "" -e "s/北京中创视讯科技有限公司/伟大的公司/g"  ../easyVideo/easyVideo/zh-Hans.lproj/localization.strings
sed -i "" -e "s/Beijing Zhong Chuang Shi Xun Technology Co., Ltd./Great Company/g"  ../easyVideo/easyVideo/en.lproj/localization.strings

# 替换应用 Logo，根据具体需要您还可以替换 easyVideo/easyVideo/Assets.xcassets/ 下的更多其它图片文件
cp -a ./AppIcon.appiconset ../easyVideo/easyVideo/Assets.xcassets/

# 替换 版本号\Bundle ID\Bundle Name 等信息
export BUNDLE_IDENTIFIER="com.yourcompany.greatapp"
export PRODUCT_NAME="GreatApp"
 
BUILD_NUMBER=1 
RELEASE_NUM=1.0
export VERSION=${RELEASE_NUM}.${BUILD_NUMBER}

cd ../easyVideo/
xcrun agvtool new-version ${VERSION}
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${VERSION}" ./easyVideo/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${BUNDLE_IDENTIFIER}" ./easyVideo/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleName ${PRODUCT_NAME}" ./easyVideo/Info.plist


