FROM ubuntu:14.04

ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

# Install required packages for building Tinker Board 2 Android
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y make gcc python bc liblz4-tool git m4 zip python-crypto \
    xz-utils gcc-multilib g++-multilib kmod bison flex python3-dev fontconfig \
    libssl-dev parted gawk

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo $username >/root/username

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -c "cd /source; /bin/bash -i"
