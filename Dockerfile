FROM debian:latest

MAINTAINER Lucas Vasconcelos Santana <luksvs@gmail.com>

RUN apt-get update
RUN apt-get install openssh-server vim -y
RUN mkdir /var/run/sshd
RUN echo 'root:openmpi' | chpasswd
RUN sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g' /etc/ssh/ssh_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#AuthorizedKeysFile	%h\/.ssh\/authorized_keys/AuthorizedKeysFile	%h\/.ssh\/authorized_keys/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

RUN apt-get install build-essential openmpi-bin libopenmpi-dev sudo -y

RUN useradd -m -s /bin/bash openmpi
RUN echo 'openmpi:openmpi' | chpasswd
RUN passwd -u openmpi
RUN mkdir -p /home/openmpi/.ssh; chown openmpi: /home/openmpi/.ssh; chmod 700 /home/openmpi/.ssh
RUN mkdir -p /home/openmpi/workspace; chown openmpi: /home/openmpi/workspace -R

ADD ./build/authorized_keys /home/openmpi/.ssh/authorized_keys
RUN chmod 644 /home/openmpi/.ssh/authorized_keys; chown openmpi: /home/openmpi/.ssh/authorized_keys

ADD ./build/id_rsa /home/openmpi/.ssh/id_rsa
RUN chmod 600 /home/openmpi/.ssh/id_rsa; chown openmpi: /home/openmpi/.ssh/id_rsa

RUN echo "openmpi    ALL=(ALL)       NOPASSWD:ALL" >> /etc/sudoers

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

