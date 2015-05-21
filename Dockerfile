FROM nifty/erlang

# locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

# elixir
RUN apt-get update && apt-get -qqy install git && rm -r /var/lib/apt/lists/*
RUN git clone https://github.com/elixir-lang/elixir.git /elixir
WORKDIR /elixir
RUN git checkout v1.0.4
RUN make
ENV PATH /elixir/bin:$PATH

# node
RUN apt-get update && apt-get -qqy install curl && rm -r /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN apt-get update && apt-get -qqy install nodejs && rm -r /var/lib/apt/lists/*

# postgres
RUN apt-get update && apt-get -qqy install postgres-xc-client && rm -r /var/lib/apt/lists/*

# app
ADD . /app
WORKDIR /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --force

CMD ["mix", "phoenix.server"]