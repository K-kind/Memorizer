FROM ruby:2.6.5

ENV RAILS_ENV production

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
  && apt-get install -y nodejs \
                        yarn \
  # aptキャッシュをクリーンにして、イメージを軽くする
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir /myapp
ENV APP_ROOT /myapp
WORKDIR $APP_ROOT
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install
COPY . $APP_ROOT

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids

# nginx用のボリューム
VOLUME /myapp/public
VOLUME /myapp/tmp

