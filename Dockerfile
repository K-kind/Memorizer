# syntax = docker/dockerfile:experimental

FROM ruby:2.6.5 AS nodejs
WORKDIR /tmp
RUN curl -LO https://nodejs.org/dist/v12.18.0/node-v12.18.0-linux-x64.tar.xz
RUN tar xvf node-v12.18.0-linux-x64.tar.xz
RUN mv node-v12.18.0-linux-x64 node

FROM ruby:2.6.5 AS base
COPY --from=nodejs /tmp/node /opt/node
ENV PATH /opt/node/bin:$PATH

RUN useradd -m -u 1000 rails
RUN mkdir /myapp && chown rails /myapp
USER rails

RUN curl -o- -L https://yarnpkg.com/install.sh | bash
ENV PATH /home/rails/.yarn/bin:/home/rails/.config/yarn/global/node_modules/.bin:$PATH

WORKDIR /myapp
ENV TZ Asia/Tokyo
COPY --chown=rails Gemfile Gemfile.lock package.json yarn.lock /myapp/

RUN bundle config path ".cache/bundle"

FROM base as develop
RUN --mount=type=cache,uid=1000,target=/myapp/.cache/bundle \
    bundle install && \
    mkdir -p vendor && \
    cp -ar .cache/bundle vendor/bundle
RUN bundle config path "vendor/bundle"

RUN --mount=type=cache,uid=1000,target=/myapp/.cache/node_modules \
    yarn install --modules-folder .cache/node_modules && \
    cp -ar .cache/node_modules node_modules
COPY --chown=rails . /myapp

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

FROM base as production
ARG KEY
ENV RAILS_MASTER_KEY $KEY
ENV RAILS_ENV production

RUN bundle config without "development test"
RUN bundle config path "vendor/bundle"
RUN bundle install

RUN yarn install

COPY --chown=rails . /myapp

RUN bin/rails webpacker:compile

CMD ["./docker-startup.sh"]
