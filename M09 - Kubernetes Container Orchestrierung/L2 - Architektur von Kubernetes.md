# Kubernetes: Architektur von Kubernetes: Master- und Worker-Nodes

Kubernetes ist eine Open-Source-Plattform zur Automatisierung der Bereitstellung, Skalierung und Verwaltung containerisierter Anwendungen. Die Architektur von Kubernetes besteht aus verschiedenen Komponenten, darunter Master- und Worker-Nodes. Im Folgenden wird die Rolle und Funktion jeder dieser Komponenten erläutert:

## Master-Node

Der Master-Node ist das Steuerungselement von Kubernetes und verwaltet den Cluster-Zustand. Er ist für die Koordination aller Aktivitäten im Cluster verantwortlich. Ein Kubernetes-Cluster hat typischerweise einen Master-Node, kann aber auch Hochverfügbarkeit durch mehrere Master-Knoten erreichen. Die wichtigsten Komponenten des Master-Nodes sind:

### 1. API-Server

Der API-Server ist das Frontend für den Kubernetes-Cluster. Alle Operationen im Cluster werden über die Kubernetes-API an den API-Server gesendet und von diesem verarbeitet.

### 2. Controller-Manager

Der Controller-Manager ist für die Verwaltung von Controller-Prozessen im Cluster zuständig. Diese Controller überwachen den Zustand des Clusters und reagieren entsprechend, um sicherzustellen, dass der tatsächliche Zustand dem gewünschten Zustand entspricht.

### 3. Scheduler

Der Scheduler ist verantwortlich für die Zuweisung von Pods zu den Nodes im Cluster. Er berücksichtigt Ressourcenanforderungen, Hardware-/Software-Anforderungen, Policies usw., um eine optimale Verteilung zu erreichen.

### 4. etcd

etcd ist ein verteilter Schlüssel-Wert-Speicher, der als zentraler Speicher für alle Clusterdaten dient. Der Master-Node verwendet etcd, um den Cluster-Zustand zu speichern.

## Worker-Nodes

Worker-Nodes sind die Arbeitspferde des Kubernetes-Clusters. Sie führen die Pods aus, die die Anwendungsworkloads enthalten. Ein Kubernetes-Cluster kann eine beliebige Anzahl von Worker-Nodes haben, je nach Bedarf und Kapazität. Jeder Worker-Node enthält die folgenden Komponenten:

### 1. Kubelet

Kubelet ist ein Agent, der auf jedem Worker-Node läuft und die Kommunikation zwischen dem Master-Node und den Containern auf dem Node ermöglicht. Es ist für das Starten, Stoppen und Überwachen von Containern auf dem Node verantwortlich.

### 2. kube-proxy

kube-proxy ist ein Netzwerkproxy, der auf jedem Worker-Node läuft und den Netzwerkverkehr zwischen den Services im Cluster verteilt. Es ermöglicht auch die Umsetzung von Services vom Cluster auf die zugrunde liegenden Nodes.

### 3. Container Runtime

Die Container Laufzeit (z. B. Docker oder containerd) ist die Software, die zum Ausführen von Containern auf einem Worker-Node verwendet wird. Sie ist für das Laden, Starten und Verwalten von Containern verantwortlich.

### 4. Pods

Ein Pod ist die kleinste bereitstellbare Einheit in Kubernetes, die einen oder mehrere Container enthält. Die Container innerhalb desselben Pods teilen sich dieselbe Netzwerk- und Speicherumgebung und kommunizieren über den localhost.

Die Master- und Worker-Nodes arbeiten zusammen, um die Anwendungsworkloads in einem Kubernetes-Cluster auszuführen und zu verwalten. Durch die Aufteilung der Verantwortlichkeiten auf Master- und Worker-Nodes wird eine effiziente und skalierbare Architektur erreicht.
