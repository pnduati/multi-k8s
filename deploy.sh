#!/bin/bash
docker build -t pnduati/multi-client:latest -t pnduati/multi-client:$GIT_SHA -f  ./client/Dockerfile ./client
docker build -t pnduati/multi-server:latest -t pnduati/multi-server:$GIT_SHA -f  ./server/Dockerfile ./server
docker build -t pnduati/multi-worker:latest -t pnduati/multi-worker:$GIT_SHA -f  ./worker/Dockerfile ./worker

docker push pnduati/multi-client:latest
docker push pnduati/multi-server:latest
docker push pnduati/multi-worker:latest

docker push pnduati/multi-client:$GIT_SHA
docker push pnduati/multi-server:$GIT_SHA
docker push pnduati/multi-worker:$GIT_SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=pnduati/multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=pnduati/multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=pnduati/multi-worker:$GIT_SHA