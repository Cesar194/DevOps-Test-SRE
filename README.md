# DevOpsTest
Repository to provide the solution of the DevOps technical test

# Prueba Técnica SRE / DevOps

Este repositorio contiene la solución completa para la prueba técnica de SRE / DevOps. El proyecto consiste en la creación de una infraestructura Cloud-Native en AWS y un pipeline de CI/CD completamente automatizado para compilar, analizar, probar, empaquetar y desplegar una aplicación Java.

## Diagrama de la Solución

https://drive.google.com/file/d/1LV0NmSey8lRKoiWfxzHNIea1lf6V1vji/view?usp=sharing

---

## Principios DevOps y Mejores Prácticas Implementadas

Esta solución fue diseñada aplicando principios DevOps modernos y mejores prácticas de la industria para garantizar la seguridad, eficiencia y repetibilidad.

### 🔹 Infraestructura como Código (IaC)
**Repetibilidad y Consistencia:** Toda la infraestructura, incluyendo la VPC, subnets, gateways y los dos clústeres de EKS, se provisiona utilizando **Terraform**. Esto garantiza que los entornos de `deployment` y `development` puedan ser creados y destruidos de forma idéntica y predecible, eliminando la deriva de configuración.
* **Control de Versiones:** La infraestructura está versionada en Git, permitiendo revisiones, auditorías y un historial completo de cambios.

### 🔹 Automatización CI/CD
**Pipeline como Código:** Se utiliza un **`Jenkinsfile`** para definir el pipeline de CI/CD de forma declarativa. Esto permite que el propio pipeline sea versionado, revisado y reutilizado.
* **Flujo End-to-End:** El pipeline automatiza cada paso del ciclo de vida del software: compilación, análisis de código, construcción de imagen Docker, publicación en un registro privado y despliegue en Kubernetes.

### 🔹 Calidad Continua y "Shift-Left Security"
**Análisis Estático de Código:** Se integra **SonarQube** en el pipeline para analizar el código en busca de bugs, vulnerabilidades y "code smells" en una fase temprana del desarrollo.
**Quality Gates:** El pipeline se detiene si el código no cumple con los umbrales de calidad mínimos definidos en el Quality Gate de SonarQube, previniendo que código de baja calidad llegue a producción.

### 🔹 Contenedores y Orquestación
**Inmutabilidad:** La aplicación se empaqueta en una imagen de **Docker**, creando un artefacto inmutable que se comporta de la misma manera en cualquier entorno.
**Alta Disponibilidad:** La aplicación se despliega en **Kubernetes** con **2 réplicas**, garantizando la disponibilidad y el balanceo de carga. El servicio se expone de forma segura a través de un **Load **Balancer** gestionado por Kubernetes.
**Agentes de Build Efímeros:** Jenkins utiliza el plugin de Kubernetes para crear agentes de build dinámicos y efímeros. Cada pipeline se ejecuta en su propio pod, garantizando un entorno limpio y aislado para cada ejecución y optimizando el uso de recursos.

---

## Consideraciones de Seguridad Implementadas

La seguridad fue un pilar fundamental en el diseño de esta solución.

**Gestión Segura de Credenciales:** No se almacena ninguna credencial sensible (tokens, contraseñas, claves de AWS) en el `Jenkinsfile` o en el código fuente. Se utiliza el **Gestor de Credenciales de Jenkins** para almacenar de forma segura todos los secretos.
**IAM Roles para Service Accounts (IRSA):** Se implementó el método más seguro y moderno para otorgar permisos de AWS a las cargas de trabajo en EKS. Los pods de Jenkins asumen un **Rol de IAM** en tiempo de ejecución para obtener credenciales temporales y de corta duración, eliminando la necesidad de claves de acceso estáticas y de larga duración.
**Principio de Menor Privilegio:** Se crearon políticas de IAM personalizadas que otorgan únicamente los permisos necesarios para cada tarea (ej. permisos para ECR, `iam:PassRole`, etc.), en lugar de usar permisos de administrador genéricos.
* **Aislamiento de Red:** Cada clúster opera en su propia VPC, garantizando el aislamiento de la red entre el entorno de herramientas de CI/CD y el entorno de la aplicación.

---
