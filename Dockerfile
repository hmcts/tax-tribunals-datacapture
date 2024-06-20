FROM ruby:3.3.0-alpine3.18


# Adding argument support for ping.json
ARG APP_VERSION=unknown
ARG APP_BUILD_DATE=unknown
ARG APP_GIT_COMMIT=unknown
ARG APP_BUILD_TAG=unknown
ARG DEBIAN_FRONTEND=noninteractive

# Setting up ping.json variables
ENV APP_VERSION ${APP_VERSION}
ENV APP_BUILD_DATE ${APP_BUILD_DATE}
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

# Application specific variables

ENV GLIMR_API_URL                                             replace_this_at_build_time
ENV GLIMR_DIRECT_API_URL                                      replace_this_at_build_time
ENV GLIMR_DIRECT_ENABLED                                      replace_this_at_build_time
ENV EXTERNAL_URL                                              replace_this_at_build_time
ENV PAYMENT_ENDPOINT                                          replace_this_at_build_time
ENV TAX_TRIBUNALS_DOWNLOADER_URL                              replace_this_at_build_time
ENV SENTRY_DSN                                                replace_this_at_build_time
ENV GOVUK_NOTIFY_API_KEY                                      replace_this_at_build_time
ENV GTM_TRACKING_ID                                           replace_this_at_build_time
ENV TAX_TRIBUNAL_EMAIL                                        replace_this_at_build_time
ENV ZENDESK_USERNAME                                          replace_this_at_build_time
ENV ZENDESK_TOKEN                                             replace_this_at_build_time
ENV UPLOAD_PROBLEMS_REPORT_AUTH_USER                          replace_this_at_build_time
ENV UPLOAD_PROBLEMS_REPORT_AUTH_DIGEST                        replace_this_at_build_time
ENV ADMIN_USERNAME                                            replace_this_at_build_time
ENV ADMIN_PASSWORD                                            replace_this_at_build_time
ENV NOTIFY_CASE_CONFIRMATION_TEMPLATE_ID                      replace_this_at_build_time
ENV NOTIFY_FTT_CASE_NOTIFICATION_TEMPLATE_ID                  replace_this_at_build_time
ENV NOTIFY_NEW_CASE_SAVED_TEMPLATE_ID                         replace_this_at_build_time
ENV NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID                        replace_this_at_build_time
ENV NOTIFY_RESET_PASSWORD_TEMPLATE_ID                         replace_this_at_build_time
ENV NOTIFY_CASE_FIRST_REMINDER_TEMPLATE_ID                    replace_this_at_build_time
ENV NOTIFY_CASE_LAST_REMINDER_TEMPLATE_ID                     replace_this_at_build_time
ENV NOTIFY_REPORT_PROBLEM_TEMPLATE_ID                         replace_this_at_build_time
ENV REPORT_PROBLEM_EMAIL_ADDRESS                              replace_this_at_build_time
ENV NOTIFY_SEND_APPLICATION_DETAIL_TEMPLATE_ID                replace_this_at_build_time
ENV NOTIFY_SEND_APPLICATION_DETAIL_TEXT_TEMPLATE_ID           replace_this_at_build_time
ENV NOTIFY_CASE_CONFIRMATION_CY_TEMPLATE_ID                   replace_this_at_build_time
ENV NOTIFY_FTT_CASE_NOTIFICATION_CY_TEMPLATE_ID               replace_this_at_build_time
ENV NOTIFY_NEW_CASE_SAVED_CY_TEMPLATE_ID                      replace_this_at_build_time
ENV NOTIFY_CHANGE_PASSWORD_CY_TEMPLATE_ID                     replace_this_at_build_time
ENV NOTIFY_RESET_PASSWORD_CY_TEMPLATE_ID                      replace_this_at_build_time
ENV NOTIFY_CASE_FIRST_REMINDER_CY_TEMPLATE_ID                 replace_this_at_build_time
ENV NOTIFY_CASE_LAST_REMINDER_CY_TEMPLATE_ID                  replace_this_at_build_time
ENV NOTIFY_REPORT_PROBLEM_CY_TEMPLATE_ID                      replace_this_at_build_time
ENV NOTIFY_SEND_APPLICATION_DETAIL_CY_TEMPLATE_ID             replace_this_at_build_time
ENV NOTIFY_SEND_APPLICATION_DETAIL_CY_TEXT_TEMPLATE_ID        replace_this_at_build_time
ENV AZURE_STORAGE_ACCOUNT                                     replace_this_at_build_time
ENV AZURE_STORAGE_CONTAINER                                   replace_this_at_build_time


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


ENV PUMA_PORT 8000
EXPOSE $PUMA_PORT

RUN mkdir -p /home/app
WORKDIR /home/app

COPY Gemfile /home/app
COPY Gemfile.lock /home/app
RUN gem install bundler -v 2.4.20

RUN bundle config set --local without 'test development'
RUN bundle config set force_ruby_platform true
RUN bundle install

# running app as a servive
ENV PHUSION true

COPY . /home/app
RUN yarn install --check-files

CMD ["sh", "-c", "bundle exec rake assets:precompile RAILS_ENV=production SECRET_TOKEN=blah && \
     sh ./run.sh"]
