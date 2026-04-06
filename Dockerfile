FROM quay.io/keycloak/keycloak:26.5.6 AS builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build --features=quick-theme

FROM quay.io/keycloak/keycloak:26.5.6
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENV KC_BOOTSTRAP_ADMIN_USERNAME=admin
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=admin
ENV KC_PROXY_HEADERS=xforwarded
ENV KC_HTTP_ENABLED=true
ENV KC_HOSTNAME_STRICT=false

ENV KC_DB_URL_HOST=postgres
ENV KC_DB_URL_DATABASE=keycloak
ENV KC_DB_USERNAME=keycloak
ENV KC_DB_PASSWORD=keycloak

EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]