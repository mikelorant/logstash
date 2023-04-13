FROM opensearchproject/logstash-oss-with-opensearch-output-plugin:7.16.3

RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-kinesis
RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-kinesis
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-json_encode

RUN sed -i 's|^\(-Xm.1g\)$|#\ \1|' config/jvm.options

RUN { \
      echo '-XX:+UnlockExperimentalVMOptions' ; \
      echo '-XX:MaxRAMFraction=1' ; \
      echo '-Djruby.compile.invokedynamic=false' ; \
      echo '-Djruby.compile.mode=OFF'; \
      echo '-XX:+TieredCompilation'; \
      echo '-XX:TieredStopAtLevel=1'; \
      echo '-Xverify:none'; \
      echo '-XshowSettings:vm' ; \
    } >> config/jvm.options
