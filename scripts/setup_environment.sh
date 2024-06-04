# setup root path variable
ROOT_PATH=/snpe-v2.14

# setup ${SNPE_ROOT}
source $ROOT_PATH/snpe-2.14.2.230905/bin/envsetup.sh

# setup android environemnt
export ANDROID_NDK_ROOT=$ROOT_PATH/android-ndk-r19c
export PATH=${ANDROID_NDK_ROOT}:${PATH}

# setup onnx environment
export ONNX_HOME=/usr/local/lib/python3.8/dist-packages
export PYTORCH_HOME=/usr/local/lib/python3.8/dist-packages