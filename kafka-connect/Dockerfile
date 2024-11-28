FROM confluentinc/cp-kafka-connect-base:7.7.1
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest
COPY ccloud-connect-distributed.properties /etc/kafka-connect/kafka-connect.properties
CMD /bin/connect-distributed /etc/kafka-connect/kafka-connect.properties