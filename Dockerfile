FROM docker.elastic.co/logstash/logstash:6.8.21 as base

RUN sed -i '/source/a source "https://repo.fury.io/fairfaxblue/"' Gemfile

# This command takes 2-5 minutes due to Maven downloading and building.
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-prune
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-json_encode
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-kinesis
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-s3-sns-sqs
RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-kinesis
RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-google_bigquery
# RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-de_dot
# Above command does not work due to gem not being considered a valid logstash plugin.
# The specification metadata is empty when installing from a remote source however when install locally works correctly.
RUN curl -L -o /tmp/logstash-filter-de_dot.gem https://manage.fury.io/2/indexes/ruby/fairfaxblue/download/logstash-filter-de_dot-1.1.0 && \
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

FROM base AS jndiremove

USER root
RUN yum install --assumeyes zip
RUN find /usr/share/logstash -xdev -name 'log4j-core*jar' -exec zip -q -d '{}' org/apache/logging/log4j/core/lookup/JndiLookup.class \;

FROM base

COPY --from=jndiremove /usr/share/logstash /usr/share/logstash
