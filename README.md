# Kubernetes Shared Volume POC

This proof of concept demonstrates a multi-container deployment in Kubernetes using a shared emptyDir volume. The system consists of three components that work together to showcase container communication and process management:

1. An init container that creates initial data
2. A main worker that reads and displays data
3. A watchdog container that monitors and restarts the worker


## Architecture

The system uses an emptyDir volume to facilitate communication between containers:

1. Init Container
   - Runs first
   - Creates timestamp file
   - Exits after completion

2. Worker Container
   - Reads timestamp continuously
   - Displays current value
   - Restarts when killed by watchdog

3. Watchdog Container
   - Updates timestamp periodically
   - Monitors worker process
   - Manages worker lifecycle

This architecture demonstrates how to manage ephemeral data sharing between containers in Kubernetes while maintaining container isolation and proper process management.

## Prerequisites

- Minikube
- kubectl
- Docker

## Setup and Testing

1. Start Minikube:
   ```bash
   minikube start
   ```

2. Enable the local Docker registry:
   ```bash
   eval $(minikube docker-env)
   ```

3. Build the Docker image:
   ```bash
   docker build -t core-sqs-worker:latest .
   ```

4. Deploy the application:
   ```bash
   kubectl apply -f deployment.yaml
   ```

5. Monitor the pods:
   ```bash
   kubectl get pods
   ```

6. Check the logs:
   ```bash
   # For the worker container
   kubectl logs <pod-name> core-sqs-worker

   # For the watchdog container
   kubectl logs <pod-name> watchdog
   ```

## Expected Behavior

1. The init container will create a file with the current timestamp
2. The worker container will start and continuously display this timestamp
3. Every 60 seconds, the watchdog will:
   - Write a new random timestamp (±1 year from current time)
   - Restart the worker process
4. The worker will then display the new timestamp

## Cleanup

To remove all resources:
```bash
kubectl delete -f deployment.yaml
minikube stop
```


## Technical Details

- The shared volume is mounted at `/shared/volume` in all containers
- The worker process is monitored using process IDs
- Liveness and readiness probes ensure container health
- The deployment uses a "Recreate" strategy to handle volume mounting properly

## Files Overview

- `deployment.yaml`: Kubernetes deployment configuration
- `create_volume.rb`: Init container script
- `ruby_script.rb`: Worker container script
- `watchdog_script.rb`: Watchdog container script
- `Dockerfile`: Container image definition

## Notes

This POC demonstrates several Kubernetes concepts:
- Shared volumes
- Init containers
- Multi-container pods
- Process management
- Container health monitoring
- Inter-container communication

## Troubleshooting

If you encounter issues:

1. Check pod status:
   ```bash
   kubectl describe pod <pod-name>
   ```

2. Verify volume mounting:
   ```bash
   kubectl exec -it <pod-name> -c core-sqs-worker -- ls -l /shared/volume
   ```

3. Check container logs:
   ```bash
   kubectl logs <pod-name> -c core-sqs-worker
   kubectl logs <pod-name> -c watchdog
   ```

4. Restart the deployment if needed:
   ```bash
   kubectl rollout restart deployment core-sqs-worker
   ```
