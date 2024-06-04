# docker-snpe-v2.14
Docker for SNPE v2.14 Development

## SNPE v2.14 Prerequisites
+ Linux: Ubuntu 20.04
+ Python: python 3.8
+ Types of input data: float32 with *.raw type
+ Android NDK: r19c (You could search [here](https://github.com/android/ndk/wiki/Unsupported-Downloads) to find the right NDK)
+ SNPE v2.14 files: You have to get this from Qualcomm page

## Setup Docker Container
1. Create docker image: `tasks: Create snpe:v2.14 docker image`
2. Extract thirdparty archives: `unzip android-ndk-r19c-linux-x86_64.zip` and `tar zxvf snpe-2.14.2.230905.tar.gz`
3. Get execute permission of SNPE tool binaries: `chmod -R +x snpe-2.14.2.230905/bin/x86_64-linux-clang`
4. Run docker image as a container: `tasks: Run snpe:v2.14 as a container`

## Prerequisites (In Docker Container)
+ Setup environment: `source scripts/setup_environment.sh`
+ Use `create_raw_list.py` to create `raw_list.txt` for model quantization:
```
// create raw_list.txt with absolute path written in file
$ python3 scripts/create_raw_list.py -i <path/to/data/folder> -o <path/to/raw_list.txt> -e *.raw

// create target_raw_list.txt with relative path written in file
$ python3 scripts/create_raw_list.py -i <path/to/data/folder> -o <path/to/target_raw_list.txt> -e *.raw -r
```

## Convert Model (In Docker Container)
+ Convert to dlc-typed model (This image only support onnx and torch conversion):
```
// --- onnx ---
$ snpe-onnx-to-dlc -i <path/to/model.onnx> -o <path/to/model.dlc>

// --- pytorch ---
$ snpe-pytorch-to-dlc -d <input/layer/name> <input/layer/dimension ex. 1,3,224,224> --input_network <path/to/torch/model> -o <path/to/model.dlc>
```
+ If we need to run model on DSP or AIP (ex. NPU) runtime, we need to quantize dlc model:
```
$ snpe-dlc-quant --input_dlc <path/to/model.dlc> --input_list <path/to/raw_list.txt> --output_dlc <path/to/model_quantize.dlc>
$ snpe-dlc-graph-prepare --input_dlc <path/to/model_quantize.dlc> --input_list <path/to/raw_list.txt> --output_dlc <path/to/model_quantize.dlc>
```
+ NOTE: `snpe-dlc-quant` would create `output` directory during quantization, and currently I don't know how to remove this execution. Therefore, we need to change to the directory that we have the permission to create `output` folder or this command would fail.

## Model Analysis (In Docker Container)
+ `snpe-dlc-viewer`: This command could create a visualized html file to find out which runtime is used in each layer
```
$ snpe-dlc-viewer -i <path/to/model.dlc> -s <path/to/model.html>
```
+ `snpe_bench.py`: This python script could create an analysis about performance metrics of model (NOTE: but you need to pass `--device` or `--privileged` to make docker have the permission to access android device)
```
$ python3 snpe_bench.py -c <path/to/config.json> -a
```
