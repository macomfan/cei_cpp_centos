FROM centos:7.6.1810

MAINTAINER Wenrui Ma <macomfan@163.com>

# Install devtoolset-7, python
RUN yum install -y centos-release-scl && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum install -y devtoolset-7 && \
	scl enable devtoolset-7 bash && \
    yum install -y python-devel && \
    yum clean all -y && \
	gcc --version

# Install openssl ssh
RUN yum install -y openssl openssl-devel && \
    yum install -y openssh-server net-tools && \
    yum clean all -y && \
	gcc --version
	

RUN yum install -y wget git && \
    yum clean all -y && \
	gcc --version

# Config ssh
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key &&\
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key && \
    echo "password" | passwd --stdin root

COPY run.sh /usr/local/bin/run.sh
RUN echo "scl enable devtoolset-7 bash" >> /root/.bashrc
    
