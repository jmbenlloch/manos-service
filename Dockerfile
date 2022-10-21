FROM ubuntu:16.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive TZ=Europe/Madrid apt install -y wget libssl-dev libreadline-dev libgdbm-dev build-essential gcc bzip2 libsqlite3-dev libpq-dev tzdata phantomjs imagemagick libtiff-tools libtiff5 libtiff5-dev nodejs vim curl libmagic1 file libmagic-dev && \
	apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.4.tar.bz2
RUN tar xjvf ruby-2.1.4.tar.bz2
RUN cd /ruby-2.1.4 && ./configure && make -j 18 && make install

RUN gem install bundler:1.7.6
WORKDIR /manos
COPY Gemfile Gemfile.lock /manos/
RUN bundle
