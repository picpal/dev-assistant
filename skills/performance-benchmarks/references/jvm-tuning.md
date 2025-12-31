# JVM Tuning Guide

## Heap Size Configuration

```bash
# Set initial and maximum heap size
java -Xms512m -Xmx2g -jar app.jar

# Rule of thumb:
# - Xms = Xmx (avoid resizing overhead)
# - Total heap = 25-75% of available RAM
# - Leave room for OS and non-heap memory
```

## Garbage Collector Selection

```bash
# G1GC (default in Java 9+, good for most cases)
java -XX:+UseG1GC \
     -XX:MaxGCPauseMillis=200 \
     -jar app.jar

# ZGC (low latency, Java 15+)
java -XX:+UseZGC \
     -Xmx4g \
     -jar app.jar

# Shenandoah (low pause times)
java -XX:+UseShenandoahGC \
     -jar app.jar
```

## GC Logging

```bash
# Enable GC logging (Java 9+)
java -Xlog:gc*:file=gc.log:time,uptime:filecount=5,filesize=100m \
     -jar app.jar

# Analyze with GCViewer or GCeasy.io
```

## Common Issues

### N+1 Query Problem
```java
// Problem
List<User> users = userRepository.findAll();  // 1 query
for (User user : users) {
    List<Order> orders = user.getOrders();  // N queries
}

// Solution
@EntityGraph(attributePaths = {"orders"})
List<User> findAllWithOrders();
```

### Connection Pool Tuning
```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20  # Adjust based on load
      minimum-idle: 10
      connection-timeout: 30000
      idle-timeout: 600000
```

## Monitoring

```bash
# JVM metrics via actuator
curl http://localhost:8080/actuator/metrics/jvm.memory.used
curl http://localhost:8080/actuator/metrics/jvm.gc.pause
```
