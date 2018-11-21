FROM docker.elastic.co/logstash/logstash:6.4.1

# This command takes 2-5 minutes due to Maven downloading and building.
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-prune
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-kinesis

RUN sed -i 's|^\(-Xm.1g\)$|#\ \1|' config/jvm.options

RUN { \
      echo '-XX:+UnlockExperimentalVMOptions' ; \
      echo '-XX:+UseCGroupMemoryLimitForHeap' ; \
      echo '-XX:MaxRAMFraction=1' ; \
      echo '-XshowSettings:vm' ; \
    } >> config/jvm.options
