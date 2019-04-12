FROM openjdk:8-jre-alpine
ENV APP_FILE com.doj.discovery-0.0.1-SNAPSHOT.jar
ENV APP_HOME /app
EXPOSE 1414
COPY target/$APP_FILE $APP_HOME/
WORKDIR $APP_HOME
ENTRYPOINT ["sh", "-c"]
CMD ["exec java -jar $APP_FILE"]
