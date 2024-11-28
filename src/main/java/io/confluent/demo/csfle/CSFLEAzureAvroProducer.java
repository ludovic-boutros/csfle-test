package io.confluent.demo.csfle;

import io.confluent.csfle.model.Customer;
import io.confluent.kafka.serializers.KafkaAvroSerializer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.UUID;

public class CSFLEAzureAvroProducer {

    private static Logger log = LoggerFactory.getLogger(CSFLEAzureAvroProducer.class);

    public static void main(String[] args) throws IOException {
        Properties producerProps = loadProperties("src/main/resources/producer-client.properties");
        producerProps.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        producerProps.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaAvroSerializer.class.getName());
        String topic = producerProps.getProperty("topic");

        KafkaProducer<String, Customer> producer = new KafkaProducer<>(producerProps);

        for (int i = 0; i < 10; i++) {
            producer.send(new ProducerRecord<>(
                    topic,
                    UUID.randomUUID().toString(),
                    Customer.newBuilder()
                            .setFirstname(String.format("Walter-%d", i))
                            .setName(String.format("Johnson-%d", i))
                            .setAge(34+i)
                            .setEmail(String.format("walter%d@johnson.com", i))
                            .build()
            ));
        }

        producer.close();

        log.info("Msg sent");

    }

    public static Properties loadProperties(String filePath) throws IOException {
        Properties properties = new Properties();

        try {
            FileInputStream input = new FileInputStream(filePath);
            properties.load(input);
            input.close();
        } catch (IOException e) {
            log.error("Configuration file not valid");
            System.exit(1);
        }
        return properties;
    }
}
