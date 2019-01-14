# Logstash

An opinionated Docker implementation for Logstash based on the upstream official image.

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Features](#features)
- [Getting Started](#getting-started)
	- [Prerequisites](#prerequisites)
	- [Installing](#installing)
	- [Environmental Variables](#environmental-variables)
- [Deployment](#deployment)
- [Components](#components)
- [Contributing](#contributing)
- [Versioning](#versioning)
- [Authors](#authors)
- [License](#license)
- [Acknowledgments](#acknowledgments)

<!-- /TOC -->

## Features

There are a number of features that differentiate this implementation from the official or other solutions.

* Improved startup time at the expense of runtime performance.
* Heap sized based on container memory and percentages.
* Enables AWS Kinesis input plugin.
* Enabled Prune filter plugin.

## Getting Started

This implementation is designed to be used with a Helm chart. However, there is a docker compose file included for testing this implementation locally. Bringing up a test cluster and discovering the Logstash endpoint is easily done with just 2 commands.

```
docker-compose up
```

It will likely take a few minutes for the containers to start and you can verify when it is available using `curl`.

```
curl $(docker-compose port logstash 8080)
```

### Prerequisites

The only requirements for bringing up this implementation locally is Docker.

```
Docker 17.12.0+
```

### Installing

It is expected that the Helm chart will be used to install this container. For local development, there are a number of ways to interact with Elasticsearch.

The http endpoint is the main way applications can send data to Logstash.

```
docker-compose port logstash 8080
```

Logstash data is send to Elasticsearch and can be viewed using Kibana.

```
docker-compose port kibana 5601
```

### Environmental Variables

See the [official documentation](https://www.elastic.co/guide/en/logstash/current/docker.html) for Logstash running in Docker.

## Deployment

For use on live systems, see the documentation for the Helm chart.

## Components

* [Logstash](https://github.com/elastic/logstash) - Logstash - transport and process your logs, events, or other data
* [Logstash-Docker](https://github.com/elastic/logstash-docker/tree/6.5) - Official Logstash Docker image

* [Elasticsearch](https://github.com/elastic/elasticsearch) - Open Source, Distributed, RESTful Search Engine
* [Kibana](https://github.com/elastic/kibana) - Kibana analytics and search dashboard for Elasticsearch
* [Prometheus Logstash Exporter](https://github.com/alxrem/prometheus-logstash-exporter) - Prometheus exporter for Logstash metrics

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/fairfaxmedia/logstash/tags).

## Authors

* **Michael Lorant** - *Initial work* - [Nine](https://github.com/mikelorant)

See also the list of [contributors](https://github.com/mikelorant/logstash/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Elastic
* Nine
