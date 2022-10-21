FROM ubuntu:latest


ENV CONDA_ENV_NAME=diffuse
ENV PYTHON_VERSION=3.10


# Basic setup
RUN apt update && apt install -y bash \
                   build-essential \
                   git \
                   curl \
                   ca-certificates \
                   wget \
                   libaio-dev \
                   && rm -rf /var/lib/apt/lists

# Install Miniconda and create main env
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh miniconda3.sh
RUN /bin/bash miniconda3.sh -b -p /conda \
    && echo export PATH=/conda/bin:$PATH >> .bashrc \
    && rm miniconda3.sh
ENV PATH="/conda/bin:${PATH}"

RUN git clone https://github.com/openclimatefix/diffusion_weather.git && mv diffusion_weather/ dw/ && cd dw/ && mv * .. && rm -rf dw/

RUN conda update -n base -c defaults conda && conda env create -f environment.yml

# Switch to bash shell
SHELL ["/bin/bash", "-c"]

# Set ${CONDA_ENV_NAME} to default virutal environment
RUN echo "source activate ${CONDA_ENV_NAME}" >> ~/.bashrc

# Cp in the development directory and install
RUN source activate ${CONDA_ENV_NAME} && pip install -e .

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "diffuse", "/bin/bash", "-c"]

# Example commnad that can be used, need to set API_KEY, API_SECRET and SAVE_DIR
CMD ["conda", "run", "-n", "diffuse", "python", "-u", "train/pl_graph_weather.py", "--gpus", "16", "--hidden", "64", "--num-blocks", "3", "--batch", "16"]
