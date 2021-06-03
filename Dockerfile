FROM openshift/jenkins-slave-maven-centos7:v3.11

USER root

RUN yum groupinstall -y 'Development Tools' &&\
    yum install -y epel-release &&\
    yum install -y python3-devel python3-setuptools python3-pip && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install bzt virtualenv

COPY google-chrome.repo /etc/yum.repos.d/google-chrome.repo

RUN INSTALL_PKGS="google-chrome-stable chromedriver" && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V  $INSTALL_PKGS && \
    yum clean all  && \
    localedef -f UTF-8 -i en_US en_US.UTF-8

ADD requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

RUN mkdir /home/jenkins

VOLUME /home/jenkins

USER 1001
