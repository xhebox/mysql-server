FROM ubuntu:latest as builder

ADD . /mysql-server
RUN apt-get update && apt-get install -y build-essential libssl-dev libncurses5-dev cmake
RUN cmake -Bbuild -DWITHOUT_SERVER=on -DWITH_UNIT_TESTS=off -DWITH_PERFSCHEMA_STORAGE_ENGINE=on /mysql-server && \
	cmake --build build -t mysql_client_test -j && \
	cp -a build/bin/mysql_client_test /bin

FROM ubuntu:latest

RUN apt-get update && apt-get install -y mysql-client make

RUN groupadd -g 1000 -o jenkins
RUN useradd -m -u 1000 -g 1000 -o -s /bin/bash jenkins
USER jenkins

COPY --from=builder /bin/mysql_client_test /bin/mysql_client_test
