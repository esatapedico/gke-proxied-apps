FROM python:3.7.6

RUN pip install --no-cache-dir --trusted-host pypi.python.org pipenv

RUN apt-get update && apt-get install -y \
    wget build-essential libssl-dev xz-utils zlib1g-dev curl \
    libbz2-dev libreadline-dev libsqlite3-dev \
    python3-dev python3-venv python3-wheel \
    llvm libncurses5-dev libncursesw5-dev \
    libsnappy-dev
