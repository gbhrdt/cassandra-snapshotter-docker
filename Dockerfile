FROM python:2.7

RUN apt-get update
RUN apt-get -y install lzop
RUN apt-get -y install awscli
RUN pip install fabric==1.13.1
RUN pip install cassandra_snapshotter

CMD cassandra-snapshotter --s3-bucket-name=$AWS_S3_BUCKET \
                      --s3-bucket-region=$AWS_S3_REGION \
                      --s3-base-path=$AWS_S3_PATH \
                      --aws-access-key-id=$AWS_ACCESS_KEY_ID \
                      --aws-secret-access-key=$AWS_SECRET_ACCESS_KEY \
                      backup \
                      --hosts=$CASSANDRA_HOSTS \
                      --user=$CASSANDRA_USER
