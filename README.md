# Polyxia 🚀

- [Polyxia 🚀](#polyxia-)
  - [Project Features](#project-features)
  - [Projects overview](#projects-overview)
  - [Documentation](#documentation)
  - [Contributing](#contributing)
  - [License](#license)

**Polyxia** is a voice assistant project created by DevOps students at Polytech Montpellier that includes a FaaS architecture based on [Rik](https://github.com/rik-org/rik) and [Firecracker](https://firecracker-microvm.github.io/). [Rik](https://github.com/rik-org/rik) is an experimental workload orchestrator that enables deployment of cloud applications written in Rust, providing a way to manage and schedule application instances. [Firecracker](https://firecracker-microvm.github.io/), on the other hand, is an open-source project by AWS that allows for lightweight, microVM-based isolation of workloads, designed to be used with containers or serverless functions for an additional layer of security and isolation.

In addition, Polyxia features an NLU algorithm for detecting user intent from text generated through a speech-to-text algorithm that translates the user's voice command into text. This intent is then sent to the FaaS to schedule a function associated with the intent.

## Project Features

- FaaS architecture based on [Rik](https://github.com/rik-org/rik) and [Firecracker](https://firecracker-microvm.github.io/)
- NLU algorithm for intent detection from user text input
- Speech-to-text algorithm for converting user voice commands into text
- Scheduled function execution based on user intent

## Projects overview

|📒 Projects | 🔭 Status| ✏️ Description|
|---|---|---|
|[Polyxia](https://github.com/polyxia-org/polyxia)|[![Super Linter](https://img.shields.io/github/actions/workflow/status/polyxia-org/polyxia/ci.yml?branch=main)](https://github.com/polyxia-org/polyxia/tree/main)|Main repository for the Polyxia project, entry point for the documentation and the project management|
|[Rik](https://github.com/rik-org/rik)|[![Super Linter](https://img.shields.io/github/actions/workflow/status/rik-org/rik/rust.yml?branch=main)](https://github.com/rik-org/rik/tree/main)|Fork of the Rik project|
|[Infrastructure](https://github.com/polyxia-org/infrastructure)|[![Super Linter](https://img.shields.io/github/actions/workflow/status/polyxia-org/infrastructure/ci.yml?branch=main)](https://github.com/polyxia-org/infrastructure/tree/main)|This repository contains files for deployment of PolyXia|
|[Morty](https://github.com/polyxia-org/morty)|[![Super Linter](https://img.shields.io/github/actions/workflow/status/polyxia-org/morty/ci.yml?branch=main)](https://github.com/polyxia-org/morty/tree/main)| Morty is the official CLI to manage / invoke functions over Polyxia.
|[Alpha](https://github.com/polyxia-org/alpha)|[![Super Linter](https://img.shields.io/github/actions/workflow/status/polyxia-org/alpha/ci.yml?branch=main)](https://github.com/polyxia-org/alpha/tree/main)|Alpha is a lightweight agent responsible for running process and monitor them inside the microVMs.|
|[Runtimes](https://github.com/polyxia-org/runtimes)|[![Super Linter](https://img.shields.io/github/actions/workflow/status/polyxia-org/runtimes/ci.yml?branch=main)](https://github.com/polyxia-org/runtimes/tree/main)|Runtimes to run functions inside the microVMs.|
[Gateway](https://github.com/polyxia-org/gateway)|[![Super Linter](https://img.shields.io/github/actions/workflow/status/polyxia-org/gateway/ci.yml?branch=main)](https://github.com/polyxia-org/gateway/tree/main)|Gateway is the entry point of the PolyXia platform. It is responsible for the communication with the user and the orchestration of the different components.|
|[Firepilot](https://github.com/polyxia-org/firepilot)|[![Super Linter](https://img.shields.io/github/actions/workflow/status/polyxia-org/firepilot/ci.yml?branch=main)](https://github.com/polyxia-org/firepilot/tree/main)|Rust API to pilot Firecracker.|

## Documentation

The documentation is available at : https://polyxia-org.github.io/

## Contributing

Contributions to Polyxia are welcome! Please see the [CONTRIBUTING.md](https://github.com/polyxia-org/.github/blob/main/.github/CONTRIBUTING.md) file for more information.

## License

The Polyxia project belongs to Polytech Montpellier and is released under the MIT license. Please see the [LICENSE](LICENSE) file for more information.
