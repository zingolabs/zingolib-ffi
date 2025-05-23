FROM ubuntu:22.04 AS android-stage


# Install Android SDK tools and Java (required for Android SDK)
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    openjdk-17-jdk \
    curl \
    wget \
    unzip \
    git \
    protobuf-compiler \
    sudo && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d ./temp && \
    mkdir -p /usr/local/android-sdk/cmdline-tools/latest && \
    mv ./temp/cmdline-tools/* /usr/local/android-sdk/cmdline-tools/latest && \
    rm -rf ./temp && \
    rm cmdline-tools.zip


# Set environment variables for Android SDK
ENV ANDROID_HOME=/usr/local/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:/usr/local/bin:/usr/local/bin
# Accept licenses and install basic Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "build-tools;30.0.3" "platforms;android-30"

ENV UID=1000
ENV GID=1000
ENV HOME=/home/myuser
ENV CARGO_HOME=$HOME/.cargo
ENV PATH=$PATH:$CARGO_HOME/bin
RUN addgroup --gid $GID myuser
RUN adduser --home $HOME --uid $UID --gid $GID myuser
RUN echo 'myuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
   
USER myuser
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN rustup update
RUN rustup default stable
RUN cargo install cargo-make
WORKDIR /home/myuser
RUN git clone https://github.com/zingolabs/zingolib.git
WORKDIR /home/myuser/zingolib-ffi
CMD ["cargo", "make", "generate-uniffi"]
