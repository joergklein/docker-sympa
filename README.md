# Docker base image for Sympa

Sympa is an electronic mailing list manager. It is used to automate list
management functions such as subscription, moderation and management of
archives. Sympa also manages sending of messages to the lists, and makes it
possible to reduce the load on the system. Provided that you have enough memory
on your system, Sympa is especially well adapted for big lists. For a list with
20 000 subscribers, it takes 5 minutes to send a message to 90% of subscribers,
of course considering that the network is available.

Documentation: https://sympa-community.github.io/

## Build the image

The Sympa mailing list server is automatically generated during this build.

```sh
docker build -t sympa .
```


## Download the image and run the container

```sh
docker run -p 80:80 -d --name sympa joergklein/sympa sympa
```

- `-p` is used to map your `local port 80` to the `container port 80`.
- `-d` is used to run the container in background. Sympa will just write logs so no need to output them in your terminal unless you want to troubleshoot a server error.
- `--name sympa` names your container sympa.
- `joergklein/sympa` the image on https://hub.docker.com/r/joergklein/sympa.
- `sympa` starts the sympa server.

Your `Sympa mailing list server` is now available on: `http://localhost:80`.

## Start / Stop Sympa

Start or stop the sympa conatiner:

```sh
docker start / stop sympa
```

## Configure Sympa
