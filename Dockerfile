ARG NODE_VERSION=8
### Base
FROM node:${NODE_VERSION} AS base

RUN apt-get update \
    && apt-get install -y \
        git \
        # Next 2 needed for yarn
        apt-transport-https \
        ca-certificates \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y \
        yarn \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /code
WORKDIR /code

### Test Base
FROM base AS test-base

RUN curl -sS https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y \
        google-chrome-stable \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

### Dev Base
FROM test-base AS dev-base

ENV WATCHMAN_VERSION=4.9.0
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        automake \
        autoconf \
        python-dev \
    && cd /tmp \
    && git clone https://github.com/facebook/watchman.git --branch v${WATCHMAN_VERSION} --single-branch \
    && cd watchman \
    && ./autogen.sh \
    && ./configure --enable-statedir=/tmp \
    && make \
    && make install \
    && mv watchman /usr/local/bin/watchman \
    && rm -Rf /tmp/watchman \
    && apt-get remove -y \
        build-essential \
        automake \
        autoconf \
        python-dev \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

### App code
FROM base AS app

COPY ./package.json ./yarn.lock /code/
RUN yarn --pure-lockfile --ignore-engines

COPY ./.bowerrc ./bower.json /code/
RUN ./node_modules/.bin/bower install --allow-root --config.interactive=false

COPY ./ /code/

ENV GIT_COMMIT \
    APP_ENV=production

RUN ./node_modules/.bin/ember build --env ${APP_ENV}

### Dist
FROM node:${NODE_VERSION}-alpine AS dist

RUN mkdir -p /code
WORKDIR /code

COPY --from=app /code/dist /code/dist

### Test
FROM test-base AS test

COPY --from=app /code /code

CMD ["yarn", "test"]

### Dev
FROM dev-base AS dev

COPY --from=app /code /code

EXPOSE 4200

CMD ["ember", "serve"]
