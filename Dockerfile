FROM ubuntu:precise

# locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

# erlang and elixir
RUN apt-get update && apt-get -qqy install wget && rm -r /var/lib/apt/lists/*
RUN cd /tmp &&\
    wget http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc &&\
    apt-key add erlang_solutions.asc &&\
    rm erlang_solutions.asc
RUN echo "deb http://packages.erlang-solutions.com/ubuntu precise contrib" >> /etc/apt/sources.list.d/erlang.list
RUN apt-get update && apt-get -qqy install erlang elixir && rm -r /var/lib/apt/lists/*

# node
RUN apt-get update && apt-get -qqy install curl && rm -r /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update && apt-get -qqy install nodejs && rm -r /var/lib/apt/lists/*

# postgres
RUN apt-get update && apt-get -qqy install postgresql postgresql-contrib && rm -r /var/lib/apt/lists/*

# app
WORKDIR /app
RUN mix local.hex --force
RUN mix local.rebar --force
ADD mix.* /app/
RUN mix deps.get
ONBUILD mix ecto.create

CMD ["mix", "phoenix.server"]