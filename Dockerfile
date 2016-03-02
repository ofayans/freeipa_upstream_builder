FROM fedora:23
RUN dnf install -y openssh-server tar git findutils dnf-plugins-core createrepo yum vim
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ir 's/.*ssh_host_ecdsa_key//' /etc/ssh/sshd_config
ADD .ssh /root/.ssh
RUN chmod 600 /root/.ssh/authorized_keys
WORKDIR /root
RUN dnf copr enable -y mkosek/freeipa-master
RUN dnf copr enable -y pviktori/pytest-plugins
RUN dnf copr enable -y simo/jwcrypto
RUN dnf copr enable -y simo/custodia
RUN git config --global user.email "freeipa-robot@redhat.com"
RUN git config --global user.name "Freeipa Bot"
RUN git clone git://git.fedorahosted.org/git/freeipa.git
ADD step1.sh /root/step1.sh
ADD step2.sh /root/step2.sh
ADD build.sh /root/freeipa/build.sh
RUN chmod a+x /root/freeipa/build.sh
RUN chmod a+x /root/step1.sh
RUN chmod a+x /root/step2.sh
# Now let's install Freeipa build dependencies
WORKDIR /root/freeipa
RUN /root/step1.sh
VOLUME /data
ENTRYPOINT ["/root/step2.sh"]
EXPOSE 22
