FROM --platform=arm64 elixir:1.18-slim 

RUN apt update \
    && apt install -y git inotify-tools

RUN mix local.hex --force \
    mix local.rebar --force \
    && mix archive.install hex phx_new

# RUN mkdir -p /home/elixir/app

# USER elixir

WORKDIR /app

CMD [ ".docker/start" ]