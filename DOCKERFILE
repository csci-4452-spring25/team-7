# official Scala image base
FROM sbtscala/scala-sbt:eclipse-temurin-23.0.2_7_1.10.11_3.6.4

WORKDIR /app

COPY . .

RUN sbt compile

# may change
EXPOSE 9000

# sbt command to run 
CMD ["sbt", "run"]
