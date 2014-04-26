#!/bin/bash

#================================================================#
# Copyright (c) 2010-2011 Zipline Games, Inc.
# All Rights Reserved.
# http://getmoai.com
#================================================================#



set -e

# Give more useful feedback rather than aborting silently.
report_error() {
    status=$?
    case $status in
    0)    ;;
    *)    echo >&2 "Aborting due to exit status $status from: $BASH_COMMAND";;
    esac
    exit $status
}

trap 'report_error' 0

APP_NAME='Moai App'
APP_ID='com.getmoai.moaiapp'
APP_VERSION='1.0'

usage() {
    cat >&2 <<EOF
usage: $0
    [--use-untz true | false] [--disable-adcolony] [--disable-billing]
    [--disable-chartboost] [--disable-crittercism] [--disable-facebook]
    [--disable-mobileapptracker] [--disable-push] [--disable-tapjoy]
    [--disable-twitter] [--release]
EOF
    exit 1
}

# check for command line switches
use_untz="true"

adcolony_flags=
billing_flags=
chartboost_flags=
crittercism_flags=
facebook_flags=
push_flags=
tapjoy_flags=
twitter_flags=
buildtype_flags="Debug"
windows_flags=
simulator="false"

while [ $# -gt 0 ];	do
    case "$1" in
        --use-untz)  use_untz="$2"; shift;;
        --disable-adcolony)  adcolony_flags="-DDISABLE_ADCOLONY";;
        --disable-billing)  billing_flags="-DDISABLE_BILLING";;
        --disable-chartboost)  chartboost_flags="-DDISABLE_CHARTBOOST";;
        --disable-crittercism)  crittercism_flags="-DDISABLE_CRITTERCISM";;
        --disable-facebook)  facebook_flags="-DDISABLE_FACEBOOK";;
        --disable-mobileapptracker)  mobileapptracker_flags="-DDISABLE_MOBILEAPPTRACKER";;
        --disable-push)  push_flags="-DDISABLE_NOTIFICATIONS";;
        --disable-tapjoy)  tapjoy_flags="-DDISABLE_TAPJOY";;
        --disable-twitter)  twitter_flags="-DDISABLE_TWITTER";;
        --release) buildtype_flags="Release";;
        --simulator) simulator="true";;
        -*) usage;;
        *)  break;;	# terminate while loop
    esac
    shift
done



#get some required variables
XCODEPATH=$(xcode-select --print-path)

if [ x"$simulator" == xtrue ]; then
echo "RUNNING SIMULATOR $simulator"
PLATFORM_PATH=${XCODEPATH}/Platforms/iPhoneSimulator.platform/Developer
PLATFORM=SIMULATOR
SDK=iphonesimulator
ARCH=i386
else
PLATFORM_PATH=${XCODEPATH}/Platforms/iPhone.platform/Developer
PLATFORM=OS
SDK=iphoneos
ARCH=armv7
fi

# echo message about what we are doing
echo "Building moai.app via CMAKE"

disabled_ext=
    
if [ x"$use_untz" != xtrue ]; then
    echo "UNTZ will be disabled"
    untz_param='-DMOAI_UNTZ=0'
else
    untz_param='-DMOAI_UNTZ=1'
fi 

if [ x"$adcolony_flags" != x ]; then
    echo "AdColony will be disabled"
    disabled_ext="${disabled_ext}ADCOLONY;"
fi 

if [ x"$billing_flags" != x ]; then
    echo "Billing will be disabled"
    disabled_ext="${disabled_ext}BILLING;"
fi 

if [ x"$chartboost_flags" != x ]; then
    echo "ChartBoost will be disabled"
    disabled_ext="${disabled_ext}CHARTBOOST;"
fi 

if [ x"$crittercism_flags" != x ]; then
    echo "Crittercism will be disabled"
    disabled_ext="${disabled_ext}CRITTERCISM;"
fi 

if [ x"$facebook_flags" != x ]; then
    echo "Facebook will be disabled"
    disabled_ext="${disabled_ext}FACEBOOK;"
fi 

if [ x"$mobileapptracker_flags" != x ]; then
    echo "Mobile App Tracker will be disabled"
    disabled_ext="${disabled_ext}MOBILEAPPTRACKER;"
fi 

if [ x"$push_flags" != x ]; then
    echo "Push Notifications will be disabled"
    disabled_ext="${disabled_ext}NOTIFICATIONS;"
fi 

if [ x"$tapjoy_flags" != x ]; then
    echo "Tapjoy will be disabled"
    disabled_ext="${disabled_ext}TAPJOY;"
fi 

if [ x"$twitter_flags" != x ]; then
    echo "Twitter will be disabled"
    disabled_ext="${disabled_ext}TWITTER;"
fi 

build_dir=${PWD}
lib_dir=${build_dir}/lib/ios

cd `dirname $0`/..
cd cmake
rm -rf build
mkdir build
cd build


echo "Creating xcode project"

set +e
#create our makefiles
cmake -DDISABLED_EXT="$disabled_ext" -DMOAI_BOX2D=0 \
-DMOAI_CHIPMUNK=0 -DMOAI_CURL=0 -DMOAI_CRYPTO=0 -DMOAI_EXPAT=0 -DMOAI_FREETYPE=1 \
-DMOAI_HTTP_CLIENT=0 -DMOAI_JSON=0 -DMOAI_JPG=1 -DMOAI_LUAEXT=0 \
-DMOAI_MONGOOSE=0 -DMOAI_OGG=0 -DMOAI_OPENSSL=0 -DMOAI_SQLITE3=1 \
-DMOAI_TINYXML=0 -DMOAI_PNG=1 -DMOAI_SFMT=0 -DMOAI_VORBIS=0 $untz_param \
-DMOAI_LUAJIT=1 \
-DBUILD_IOS=true \
-DSIGN_IDENTITY="${SIGN_IDENTITY}" \
-DAPP_NAME="${APP_NAME}" \
-DAPP_ID="${APP_ID}" \
-DAPP_VERSION="${APP_VERSION}" \
-DCMAKE_BUILD_TYPE=$buildtype_flags \
-DCMAKE_INSTALL_PREFIX=${lib_dir} \
-DLIB_ONLY=TRUE \
-G "Xcode" \
../

rm -f ${lib_dir}/lib/*.a

xcodebuild ONLY_ACTIVE_ARCH=NO -project moai.xcodeproj -target install -configuration $buildtype_flags -target install -sdk iphonesimulator
#work around cmake install bug with ios projects
find . -iregex ".*/.*-iphonesimulator/[^/]*.a" | xargs -J % cp -npv % ${lib_dir}/lib
find . -iregex ".*/Export/cmake/[^/]*.cmake" | xargs -J % cp -npv % {lib_dir}/cmake

mkdir -p ${lib_dir}/lib-iphonesimulator
mv -v ${lib_dir}/lib/*.a ${lib_dir}/lib-iphonesimulator

rm -f ${lib_dir}/lib/*.a

xcodebuild ONLY_ACTIVE_ARCH=NO ARCHS="armv7 armv7s" -project moai.xcodeproj -target install -configuration $buildtype_flags -target install -sdk iphoneos
#work around cmake install bug with ios projects
find . -iregex ".*/.*-iphoneos/[^/]*.a" | xargs -J % cp -npv % ${lib_dir}/lib

mkdir -p ${lib_dir}/lib-iphoneos
cp -npv ${lib_dir}/lib/*.a ${lib_dir}/lib-iphoneos

echo "Build Directory : ${build_dir}"
echo "Lib Output: ${lib_dir}"

#todo create lipo and dump in release folder.
for LIBNAME in ${lib_dir}/lib-iphoneos/*.a
do
    echo lip $LIBNAME
    BASELIBNAME=`basename $LIBNAME`
    lipo ${lib_dir}/lib-iphoneos/$BASELIBNAME -arch i386 ${lib_dir}/lib-iphonesimulator/$BASELIBNAME -create -output ${lib_dir}/lib/$BASELIBNAME
done
rm -rf ${lib_dir}/lib-iphoneos
rm -rf ${lib_dir}/lib-iphonesimulator

