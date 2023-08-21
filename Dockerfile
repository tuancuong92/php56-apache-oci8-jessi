FROM porchn/php5.6-apache:latest

COPY ./sources.list /etc/apt/sources.list

RUN apt-get install debian-archive-keyring
RUN apt-get update
RUN apt-get install unzip

WORKDIR /setup
COPY ./instantclient-basic-linux.x64-12.2.0.1.0.zip .
COPY ./instantclient-sdk-linux.x64-12.2.0.1.0.zip .

RUN unzip ./instantclient-basic-linux.x64-12.2.0.1.0.zip
RUN cp -R ./instantclient_12_2/ /usr/lib/

RUN unzip ./instantclient-sdk-linux.x64-12.2.0.1.0.zip
RUN cp -R ./instantclient_12_2/sdk/ /usr/lib/instantclient_12_2/

WORKDIR /usr/lib/instantclient_12_2
RUN ln -s libocci.so.12.1 libocci.so && ln -s libclntsh.so.12.1 libclntsh.so

ENV LD_LIBRARY_PATH="/usr/lib/instantclient_12_2"

WORKDIR /setup
COPY ./oci8-2.0.12.tgz .

RUN tar -zxf oci8-2.0.12.tgz
WORKDIR /setup/oci8-2.0.12
RUN phpize && ./configure -with-oci8=shared,instantclient,/usr/lib/instantclient_12_2/ && make install
WORKDIR /app
RUN rm -fr /setup