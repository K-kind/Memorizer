FROM ruby:2.6.5

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
  && apt-get install -y nodejs \
                        yarn \
                        cron \
  # aptキャッシュをクリーンにして、イメージを軽くする
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir /myapp
ENV APP_ROOT /myapp
ENV TZ Asia/Tokyo
WORKDIR $APP_ROOT
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
COPY yarn.lock $APP_ROOT/yarn.lock
COPY package.json $APP_ROOT/package.json
RUN bundle install && yarn install
COPY . $APP_ROOT

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
