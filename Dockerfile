FROM dart:2.19.6-sdk AS build
ARG APP_VERSION=unknown

WORKDIR /app

COPY pubspec.* ./
COPY third_party third_party
RUN dart pub get

COPY . .
RUN dart pub get --offline
RUN dart compile exe -DAPP_VERSION=${APP_VERSION} src/leaf_2_mqtt.dart -o src/leaf_2_mqtt

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/src/leaf_2_mqtt /app/bin/

CMD ["/app/bin/leaf_2_mqtt"]
