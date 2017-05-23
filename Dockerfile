FROM centos:6.8
MAINTAINER centos for cloud <https://hub.docker.com/u/ssorg/>

RUN yum -y install openssh-server sudo python-setuptools; yum clean all

RUN ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''

RUN cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN easy_install supervisor supervisor-stdout
RUN echo_supervisord_conf > /etc/supervisord.conf

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod 700 /entrypoint.sh 
ADD ./chpwd.sh /chpwd.sh
RUN chmod 700 /chpwd.sh 

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
