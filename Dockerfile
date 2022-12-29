FROM bitwalker/alpine-elixir-phoenix:latest

# RUN apt-get update

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager.
RUN mix local.hex --force && \
  mix local.rebar --force

RUN mix deps.get

# Deps get
RUN mix deps.get

# Compile the project.
RUN mix do compile

CMD mix phx.server