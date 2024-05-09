# Kubernetes: Service Discovery und Load Balancing mit Kubernetes Services

In Kubernetes ermöglichen Services die Bereitstellung von Service Discovery und Load Balancing für Anwendungen in einem Cluster. Sie dienen dazu, stabile Endpunkte für Anwendungen bereitzustellen, unabhängig von Änderungen in der Infrastruktur. Im Folgenden werden grundlegende Konzepte und Beispiele zur Verwendung von Kubernetes Services für Service Discovery und Load Balancing erläutert:

## 1. Service Discovery

Service Discovery in Kubernetes bezieht sich auf die Fähigkeit, Netzwerkendpunkte von Services automatisch zu finden und auf sie zuzugreifen, ohne ihre IP-Adressen oder Ports zu kennen. Dies ermöglicht es Anwendungen, miteinander zu kommunizieren, unabhängig von ihrer aktuellen Position im Cluster.

### Beispiel: Verwendung von DNS für Service Discovery

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

## In diesem Beispiel wird ein Kubernetes-Service mit dem Namen my-service definiert. Durch Angabe des Labels app: MyApp im Selector wird der Service automatisch mit Pods verknüpft, die dieses Label haben. Andere Anwendungen im Cluster können nun auf my-service über den DNS-Namen my-service.default.svc.cluster.local zugreifen.

2. Load Balancing
Load Balancing in Kubernetes verteilt den eingehenden Datenverkehr auf mehrere Instanzen eines Dienstes, um die Last gleichmäßig zu verteilen und die Verfügbarkeit zu verbessern. Kubernetes Services bieten integriertes Load Balancing für Pods, die denselben Service bereitstellen.

### Beispiel: Load-Balanced Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-loadbalanced-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
  type: LoadBalancer
```

Hier wird ein Kubernetes-Service mit dem Typ LoadBalancer definiert. Kubernetes provisioniert automatisch einen Load Balancer (z. B. einen Cloud Load Balancer), um den eingehenden Traffic auf die Pods des Dienstes my-loadbalanced-service zu verteilen.