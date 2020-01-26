FROM centos:7.6.1810

MAINTAINER Wenrui Ma <macomfan@163.com>

# Install devtoolset-7, python
RUN yum install -y centos-release-scl && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum install -y devtoolset-7 && \
	scl enable devtoolset-7 bash && \
    yum install -y python-devel && \
    yum clean all -y

# Install openssl ssh
RUN yum install -y openssl openssl-devel && \
    yum install -y openssh-server net-tools && \
    yum clean all -y

# Install wget git
RUN yum install -y wget git && \
    yum clean all -y

# Config ssh
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key &&\
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key && \
    echo "password" | passwd --stdin root

COPY run.sh /usr/local/bin/run.sh
RUN scl enable devtoolset-7 bash && echo "source /opt/rh/devtoolset-7/enable" >> /root/.bashrc && source /root/.bashrc && gcc --version

# Install CMake v3.14.7
RUN source /root/.bashrc &&\
    cd /usr &&\
    wget https://cmake.org/files/v3.14/cmake-3.14.7-Linux-x86_64.sh && \
    sh /usr/cmake-3.14.7-Linux-x86_64.sh --skip-license &&\
    rm -f /usr/cmake-3.14.7-Linux-x86_64.sh
ENV PATH=$PATH:/bin/:/usr/bin/

# Install Boost v1.72.0
RUN cd /root && \
    wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz && \
    tar -xzvf boost_1_72_0.tar.gz && rm -f boost_1_72_0.tar.gz && \
    source /root/.bashrc && \
	gcc --version && \
    cd boost_1_72_0 && \
	pwd && \
    sh bootstrap.sh && \
    ./b2 install --build-dir=/tmp/build-boost && \
    rm -rf /tmp/build-boost

# Install gtest
RUN source /root/.bashrc && \
    git clone --branch release-1.10.0 https://github.com/google/googletest.git /root/googletest-1.10.0 && \
    cd /root/googletest-1.10.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && make install && \
    cd .. && rm -rf build

WORKDIR /root
EXPOSE 22
ENTRYPOINT ["sh", "run.sh"]
    
