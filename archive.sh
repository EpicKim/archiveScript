#缓存目录
cachePath="/资源库/archiveCache"
#需要打包的target
target=$1
#项目目录
projectPath=""
#拉取的git branch名字
gitBranchName=""
#蒲公英userKey
uKey=""
#蒲公英apiKey
apiKey=""


#ipa导出路径
ipaExportPath="${cachePath}${target}"
#xcarchive缓存路径(随便填一个,可以保存下来打不同的证书)
xcarchivePath="${cachePath}lottery.xcarchive"
#exportOptionsPlist地址
exportOptionsPlist="${cachePath}${target}.plist"

#清理缓存
rm -rf dir $xcarchivePath
rm -rf dir $ipaExportPath

cd $projectPath
#清除本地未提交代码
git reset --hard
#拉取最新代码
git pull origin $gitBranchName

pod install

# carthage update --platform iOS
xcodebuild archive -workspace lottery.xcworkspace -list
xcodebuild archive -workspace lottery.xcworkspace -scheme $target -configuration "Release" -archivePath $xcarchivePath

xcodebuild -exportArchive -archivePath $xcarchivePath -exportPath $ipaExportPath -exportOptionsPlist $exportOptionsPlist

# 上传到蒲公英
curl -F "file=@${ipaExportPath}/${target}.ipa" \
-F "uKey=${uKey}" \
-F "_api_key=${apiKey}" \
https://www.pgyer.com/apiv1/app/upload

# send email 邮件通知同事让他们之间去下载
echo "蒲公英网站上的APP已更新，欢迎更新.下载地址：https://www.pgyer.com/my" | mail -s "ipa更新" xx@163.com

say "打包完毕"

logout