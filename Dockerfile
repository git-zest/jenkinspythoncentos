FROM openshift/jenkins-slave-maven-centos7:v3.11

USER root

COPY CertificateCA113.crt /etc/pki/ca-trust/source/anchors/CertificateCA113.crt

RUN yum groupinstall -y 'Development Tools' &&\
    yum install -y epel-release &&\
    yum install -y python3-devel python3-setuptools python3-pip && \
    yum install -y ca-certificates && \
    yum install -y git && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install bzt virtualenv

RUN update-ca-trust enable && \
    update-ca-trust extract

COPY google-chrome.repo /etc/yum.repos.d/google-chrome.repo

RUN INSTALL_PKGS="google-chrome-stable chromedriver" && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V  $INSTALL_PKGS && \
    yum clean all  && \
    localedef -f UTF-8 -i en_US en_US.UTF-8

RUN yum install -y xvfb

ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

ADD requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

RUN mkdir -p /home/jenkins


RUN mkdir -p /root/.ssh && \
	chmod 0700 /root/.ssh

COPY /.ssh/ /root/.ssh

RUN chmod 0700 /root/.ssh/id_rsa

RUN chmod 0700 /root/.ssh/id_rsa.pub

VOLUME /home/jenkins

