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



usage() {
    cat >&2 <<EOF
usage: $0
    [--use-untz true | false] [--release] <library destination>
EOF
    exit 1
}

# check for command line switches
use_untz="true"


buildtype_flags="Debug"



while [ $# -gt 1 ];	do
    case "$1" in
        --use-untz)  use_untz="$2"; shift;;
        --release) buildtype_flags="Release";;
        -*) usage;;
        *)  break;;	# terminate while loop
    esac
    shift

done
echo $1
lib_dir=$1
echo LIB_DIR = $lib_dir
if ! [ -d "$lib_dir" ]
then
mkdir -p $lib_dir

fi
#get some required variables
XCODEPATH=$(xcode-select --print-path)



# echo message about what we are doing
echo "Building lib moai via CMAKE"


    
if [ x"$use_untz" != xtrue ]; then
    echo "UNTZ will be disabled"
    untz_param='-DMOAI_UNTZ=0'
else
    untz_param='-DMOAI_UNTZ=1'
fi 

build_dir=${PWD}


cd `dirname $0`/..
cd cmake
#rm -rf build
if ! [ -d "build-ios" ]
then
mkdir build-ios
fi
cd build-ios


echo "Creating xcode project"

set +e

if ! [ -e "CMakeCache.txt" ]
then    
#create our makefiles
cmake -DDISABLED_EXT="$disabled_ext" -DMOAI_BOX2D=1 \
-DMOAI_CHIPMUNK=0 -DMOAI_CURL=1 -DMOAI_CRYPTO=1 -DMOAI_EXPAT=1 -DMOAI_FREETYPE=1 \
-DMOAI_HTTP_CLIENT=1 -DMOAI_JSON=1 -DMOAI_JPG=1 -DMOAI_LUAEXT=1 \
-DMOAI_MONGOOSE=1 -DMOAI_OGG=1 -DMOAI_OPENSSL=1 -DMOAI_SQLITE3=1 \
-DMOAI_TINYXML=1 -DMOAI_PNG=1 -DMOAI_SFMT=1 -DMOAI_VORBIS=1 $untz_param \
-DMOAI_LUAJIT=1 \
-DBUILD_IOS=true \
-DCMAKE_BUILD_TYPE=$buildtype_flags \
-DCMAKE_INSTALL_PREFIX="${lib_dir}" \
-DLIB_ONLY=TRUE \
-G "Xcode" \
../
fi

rm -f ${lib_dir}/lib/*.a

xcodebuild ONLY_ACTIVE_ARCH=NO -project moai.xcodeproj -target install -configuration $buildtype_flags -target install -sdk iphonesimulator
#work around cmake install bug with ios projects
find . -iregex ".*/.*-iphonesimulator/[^/]*.a" | xargs -J % cp -npv % ${lib_dir}/lib


mkdir -p ${lib_dir}/lib-iphonesimulator
mv -v ${lib_dir}/lib/*.a ${lib_dir}/lib-iphonesimulator

rm -f ${lib_dir}/lib/*.a

xcodebuild ONLY_ACTIVE_ARCH=NO ARCHS="armv7 armv7s" -project moai.xcodeproj -target install -configuration $buildtype_flags -target install -sdk iphoneos
#work around cmake install bug with ios projects
find . -iregex ".*/.*-iphoneos/[^/]*.a" | xargs -J % cp -npv % ${lib_dir}/lib
find . -iregex ".*/Export/cmake/[^/]*.cmake" | xargs -J % cp -npv % ${lib_dir}/cmake

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

