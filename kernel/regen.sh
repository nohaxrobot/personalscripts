#!/bin/bash
#
# Copyright (C) 2020 Fox kernel project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Setuping colours for the script
white='\033[0m'
green='\e[0;32m'

# With that setup , the script will set dirs , the only thinks to modify is the DEFCONFIG value
# The rest will do the script it self
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

echo -e "$green write here the defconfig do you want to regen \n $white"

read def
DEFCONFIG=$def

# Now let's clone aarch64_aarch64-linux-android-4.9 toolchain from lineage on HOME value
# It will be used to setup the .confing only
# And after that , the script start the regen of the defconfig
# For compiling the kernel . use the build.sh script

if [ ! -d "$HOME/toolchain_64-regen" ]
then
	echo -e "$green << cloning toolchain >> \n $white"
	git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 -b lineage-17.1 "$HOME"/toolchain_64-regen --depth=1
fi

echo -e "$green << regen defconfig >> \n $white"

export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
export CROSS_COMPILE="$HOME"/toolchain_64-regen/bin/aarch64-linux-android-

rm -rf out
mkdir -p out

make O=out clean && make O=out mrproper
make "$DEFCONFIG" O=out

cp out/.config arch/arm64/configs/"$DEFCONFIG"
git add arch/arm64/configs/"$DEFCONFIG"
git commit -m "arch/arm64: $DEFCONFIG: regen"

rm -rf out
echo -e "$green << done >> \n $white"
exit
