---
title: Online Retail Company (through Polarising)
date: 2019-03-01
end_date: 2019-04-31
tech:
- name: Java
  usage: Heavy
- name: Spring Framework
  usage: Heavy
- name: Spring Boot
  usage: Heavy
- name: Spring Integration
  usage: Heavy
- name: Kubernetes
  usage: Heavy
- name: Kafka
  usage: Light
---
The project aimed to develop a couple of production-ready services
which would also function as blueprints for other services developed in the future.

I worked mostly remotely in a 2 person team, with the exception of a few in-person meetings
with the client.

My contributions included:
* reviewing the recently created Kubernetes cluster;
* developing a pair of services to produce and consume a Kafka stream, running on Kubernetes;
these included:
  * high unit and integration test coverage;
  * CI automation
  * scripts for facilitating developer workflow (e.g. starting dockerized Kafka instances and mock databases), fully documented;
* writing a guide on Kafka topic design and error handling for messaging-based services.
