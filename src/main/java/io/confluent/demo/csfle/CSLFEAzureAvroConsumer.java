package io.confluent.demo.csfle;

import io.confluent.csfle.model.Customer;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileInputStream;
import java.io.IOException;
import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

public class CSLFEAzureAvroConsumer {

    private static Logger log = LoggerFactory.getLogger(CSLFEAzureAvroConsumer.class);

    public static void main(String[] args) throws IOException {
        Properties consumerProps = loadProperties("src/main/resources/consumer-client.properties");
        consumerProps.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        consumerProps.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class.getName());
        consumerProps.setProperty(ConsumerConfig.GROUP_ID_CONFIG, "test-csfle");
        String topic = consumerProps.getProperty("topic");

        try (KafkaConsumer<String, Customer> consumer = new KafkaConsumer<>(consumerProps)) {
            consumer.subscribe(Collections.singleton(topic));

            while (true) {
                ConsumerRecords<String, Customer> records = consumer.poll(Duration.ofMillis(1000));
                records.forEach(r -> log.info("Consumed: {}", r.value()));
            }
        }
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
