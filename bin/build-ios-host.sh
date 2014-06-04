#!/bin/bash

cd `dirname $0`/..

APP_NAME='Moai App'
APP_ID='com.getmoai.moaiapp'
APP_VERSION='1.0'


# check for command line switches
usage="usage: $0  \
    [--disable-adcolony] [--disable-billing] \
    [--disable-chartboost] [--disable-crittercism] [--disable-facebook] [--disable-push] [--disable-tapjoy] \
    [--disable-twitter]  <lib_directory> <host_directory> <lua_src_directory>"

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


while [ $# -gt 3 ];	do
    case "$1" in
        --disable-adcolony)  adcolony_flags="-DDISABLE_ADCOLONY";;
        --disable-billing)  billing_flags="-DDISABLE_BILLING";;
        --disable-chartboost)  chartboost_flags="-DDISABLE_CHARTBOOST";;
        --disable-crittercism)  crittercism_flags="-DDISABLE_CRITTERCISM";;
        --disable-facebook)  facebook_flags="-DDISABLE_FACEBOOK";;
        --disable-push)  push_flags="-DDISABLE_NOTIFICATIONS";;
        --disable-tapjoy)  tapjoy_flags="-DDISABLE_TAPJOY";;
        --disable-twitter)  twitter_flags="-DDISABLE_TWITTER";;
        -*)
            echo >&2 \
                $usage
            exit 1;;
        *)  break;;	# terminate while loop
    esac
    shift
done

LIB_DIR=$1
HOST_DIR=$2

SRCPARAM='./samples/hello-moai'
if [ x != x"$3" ]; then
   SRCPARAM=$3 
fi

LUASRC=$(ruby -e 'puts File.expand_path(ARGV.first)' "$SRCPARAM")

if [ ! -f "${LUASRC}/main.lua" ]; then
  echo "Could not find main.lua in specified lua source directory [${LUASRC}]"
  exit 1
fi

#get some required variables
XCODEPATH=$(xcode-select --print-path)

SIGN_IDENTITY='iPhone Developer'

# echo message about what we are doing
echo "Building moai.app via CMAKE"

disabled_ext=
    
if [ x"$adcolony_flags" != x ]; then
    echo "AdColony will be disabled"
    disabled_ext="$disabled_extADCOLONY;"
fi 

if [ x"$billing_flags" != x ]; then
    echo "Billing will be disabled"
    disabled_ext="$disabled_extBILLING;"
fi 

if [ x"$chartboost_flags" != x ]; then
    echo "ChartBoost will be disabled"
    disabled_ext="$disabled_extCHARTBOOST;"
fi 

if [ x"$crittercism_flags" != x ]; then
    echo "Crittercism will be disabled"
    disabled_ext="$disabled_extCRITTERCISM;"
fi 

if [ x"$facebook_flags" != x ]; then
    echo "Facebook will be disabled"
    disabled_ext="$disabled_extFACEBOOK;"
fi 

if [ x"$push_flags" != x ]; then
    echo "Push Notifications will be disabled"
    disabled_ext="$disabled_extNOTIFICATIONS;"
fi 

if [ x"$tapjoy_flags" != x ]; then
    echo "Tapjoy will be disabled"
    disabled_ext="$disabled_extTAPJOY;"
fi 

if [ x"$twitter_flags" != x ]; then
    echo "Twitter will be disabled"
    disabled_ext="$disabled_extTWITTER;"
fi 

build_dir=${PWD}

 mkdir -p $HOST_DIR/src

 cd $HOST_DIR

 cp -R ${build_dir}/src/host-ios .
 cp -R ${build_dir}/src/moai-iphone .
 
 echo "Building resource list from ${LUASRC}"
 ruby ${build_dir}/cmake/host-ios/build_resources.rb "${LUASRC}"

 echo "Creating xcode project"

#create our makefiles
cmake -DDISABLED_EXT="$disabled_ext" 
-DBUILD_IOS=true \
-DSIGN_IDENTITY="${SIGN_IDENTITY}" \
-DAPP_NAME="${APP_NAME}" \
-DAPP_ID="${APP_ID}" \
-DAPP_VERSION="${APP_VERSION}" \
-DCMAKE_BUILD_TYPE=$buildtype_flags \
-DHOST_ONLY=True \
-DCMAKE_SUPPRESS_REGENERATION=True \
-DLIB_PATH=${LIB_DIR} \
-DHOST_PATH=${HOST_DIR}/src
-G "Xcode" \
${build_dir}/cmake/host-ios