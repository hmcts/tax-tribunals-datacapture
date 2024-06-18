FROM ruby:3.3.0-alpine3.18


# Chromium onwards is latest Chromium (100) package
# for Puppeteer for Grover
RUN apk --no-cache add --virtual build-deps \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  git \
  curl \
&& apk --no-cache add \
  postgresql-client \
  shared-mime-info \
  linux-headers \
  xz-libs \
  tzdata \
  nodejs \
  yarn \
  less \
  chromium \
  nss \
  freetype \
  harfbuzz \
  ca-certificates \
  ttf-freefont

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# ensure everything is executable
RUN chmod +x /usr/local/bin/*

# add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

ENV PUMA_PORT 8000
EXPOSE $PUMA_PORT

## adding cron jobs
ADD daily-export /etc/periodic/daily

RUN chmod +x /etc/periodic/daily/*

RUN mkdir -p /home/app
RUN chown appuser:appgroup /home/app

USER appuser

WORKDIR /home/app
COPY Gemfile* .ruby-version ./

RUN gem install bundler -v 2.3.15 && \
    bundle config set frozen 'true' && \
    bundle config without test:development && \
    bundle install

COPY --chown=appuser:appgroup . .

RUN yarn install --check-files

RUN bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=required_but_does_not_matter_for_assets

# Copy fonts and images (without digest) along with the digested ones,
# as there are some hardcoded references in the `govuk-frontend` files
# that will not be able to use the rails digest mechanism.
RUN cp node_modules/govuk-frontend/govuk/assets/fonts/*  public/assets/govuk-frontend/govuk/assets/fonts
RUN cp node_modules/govuk-frontend/govuk/assets/images/* public/assets/govuk-frontend/govuk/assets/images

## Set up sidekiq
COPY --chown=appuser:appgroup sidekiq.sh /home/app/sidekiq.sh
RUN chmod +x /home/app/sidekiq.sh

# running app as a service
ENV PHUSION true
COPY --chown=appuser:appgroup run.sh /home/app/run
RUN chmod +x /home/app/run
CMD ["./run"]