FROM jruby:9.1-alpine as logstash-filter-de_dot

ENV LOGSTASH_BRANCH=v6.5.1

RUN java -Xmx32m -version

RUN gem install bundler -v '< 2'

RUN apk add --no-cache \
      openjdk8 \
      git

RUN git clone https://github.com/mikelorant/logstash-filter-de_dot.git

WORKDIR logstash-filter-de_dot

RUN git checkout recursive

RUN source ./ci/setup.sh && \
    bundle install && \
    truncate -s 0 /logstash/logstash-core/lib/logstash/patches/resolv.rb && \
    bundle exec rake vendor && \
    bundle exec rspec spec && \
    bundle exec gem build logstash-filter-de_dot.gemspec

FROM docker.elastic.co/logstash/logstash:6.5.1

# This command takes 2-5 minutes due to Maven downloading and building.
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-prune
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-json_encode
RUN /usr/share/logstash/bin/logstash-plugin install logstash-input-kinesis

COPY --from=logstash-filter-de_dot --chown=logstash /logstash-filter-de_dot/*.gem /tmp/

RUN /usr/share/logstash/bin/logstash-plugin install /tmp/logstash-filter-de_dot-*.gem

RUN rm /tmp/logstash-filter-de_dot-*.gem

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
