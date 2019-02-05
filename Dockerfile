FROM docker.elastic.co/logstash/logstash:6.5.1

RUN sed -i '/source/a source "https://repo.fury.io/fairfaxblue/"' Gemfile

# This command takes 2-5 minutes due to Maven downloading and building.
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-prune
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-json_encode
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-kinesis
RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-kinesis
# RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-de_dot
# Above command does not work due to gem not being considered a valid logstash plugin.
# The specification metadata is empty when installing from a remote source however when install locally works correctly.
RUN curl -L -o /tmp/logstash-filter-de_dot.gem https://gemfury.com/fairfaxblue/ruby:logstash-filter-de_dot/-/download && \
    /usr/share/logstash/bin/logstash-plugin install /tmp/logstash-filter-de_dot.gem && \
    rm /tmp/logstash-filter-de_dot.gem

RUN sed -i 's|^\(-Xm.1g\)$|#\ \1|' config/jvm.options

RUN { \
      echo '-XX:+UnlockExperimentalVMOptions' ; \
      echo '-XX:+UseCGroupMemoryLimitForHeap' ; \
      echo '-XX:MaxRAMFraction=1' ; \
      echo '-Djruby.compile.invokedynamic=false' ; \
      echo '-Djruby.compile.mode=OFF'; \
      echo '-XX:+TieredCompilation'; \
      echo '-XX:TieredStopAtLevel=1'; \
      echo '-Xverify:none'; \
      echo '-XshowSettings:vm' ; \
    } >> config/jvm.options
