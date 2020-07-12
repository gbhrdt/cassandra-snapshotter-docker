FROM python:2.7

ENV CASSANDRA_VERSION=3.11.0

RUN apk add --no-cache wget openjdk8-jre

RUN mkdir /opt && cd /opt \
 && wget -q http://archive.apache.org/dist/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz \
 && tar zxf apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz \
 && mv -v apache-cassandra-${CASSANDRA_VERSION} cassandra \
 && rm -fv apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz

ENV PATH="/opt/cassandra/bin:${PATH}"

RUN apt-get update
RUN apt-get -y install lzop
RUN apt-get -y install awscli
RUN pip install scyllabackup
RUN pip install cqlsh

CMD scyllabackup take --path $CASSANDRA_PATH \
                    --db $CASSANDRA_DB \
                    --provider s3 \
                    --nodetool-path /opt/cassandra/bin/nodetool \
                    --cqlsh-path $(which cqlsh) \
                    --cqlsh-host $CASSANDRA_HOST \
                    --cqlsh-port $CASSANDRA_PORT \
                    --s3-bucket-name $AWS_S3_BUCKET \
                    --s3-aws-key $AWS_ACCESS_KEY_ID \
                    --s3-aws-secret $AWS_SECRET_ACCESS_KEY
