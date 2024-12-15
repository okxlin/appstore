FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_PREFER_BINARY=1
ENV ROOT=/apt

RUN mkdir ${ROOT}
WORKDIR ${ROOT}

# Install Essential Packages (APT)
RUN apt-get update && apt-get install -y git python3 python3-pip && apt-get clean

# Get Comfy
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Install Essential Packages (PIP)
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118 && \
  pip install -r requirements.txt && \
  pip install --pre xformers && \
  pip install triton

# Setting up
COPY entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/entrypoint.sh
ENTRYPOINT ["/docker/entrypoint.sh"]

ENV PYTHONPATH="${PYTHONPATH}:${PWD}"

CMD test -z "${APT_ARGS}" || apt-get -y install ${APT_ARGS} \
    && test -z "${PIP_ARGS}" || pip install ${PIP_ARGS} \
    && python3 -u main.py ${CLI_ARGS}