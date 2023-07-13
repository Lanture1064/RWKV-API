# Base
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

COPY . /FastchatRWKV

WORKDIR /FastchatRWKV

# Install dependencies
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone \
    && apt-get update -y && apt-get install python3 python3-pip curl libgl1 libglib2.0-0 -y \
    && apt-get clean && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py \
    && pip3 install langchain -i https://pypi.mirrors.ustc.edu.cn/simple/ \
    && pip3 install fschat -i https://pypi.mirrors.ustc.edu.cn/simple/ && rm -rf `pip3 cache dir`

# Run
RUN python3 -m fastchat.serve.controller && python3 -m fastchat.serve.cli --model-path ~/model/RWKV-4-World-7B-v1-20230626-ctx4096.pth
RUN python3 -m fastchat.serve.openai_api_server --host localhost --port 4550
