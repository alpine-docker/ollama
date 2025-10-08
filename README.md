# Minimal CPU-only Ollama Docker Image

This repository provides a **minimal CPU-only Ollama Docker image**, specifically designed to run on systems without GPU support. At just **70MB**, this image is significantly smaller than the official Ollama image, which is around **4GB**.

```
ollama latest b99944c07117   3 hours ago    69.3MB
```
## Notes

* **This image is not based on alpine**, but [wolfi.dev](https://wolfi.dev/), I will work it out with alpine later
* Got big help from @kth8 ( https://github.com/ollama/ollama/issues/7184#issuecomment-2414823298 )

## Why Use This Image?

1. **Lightweight**: The official Ollama image is over 4GB in size, which can be overkill for systems that only need CPU-based processing. This image is only **70MB**, making it much faster to download and deploy.
   
2. **CPU-only Support**: This image is tailored for systems without GPUs. It ensures you can run Ollama efficiently, even on basic or resource-constrained environments, without needing specialized hardware.

3. **Run Anywhere**: Whether you're working on local servers, edge devices, or cloud environments that don’t offer GPU resources, this image allows you to **run Ollama anywhere**, focusing purely on CPU-based operations.

## How to Use

* Pull the image
```bash
docker pull alpine/ollama
```

* Run the service with API supported

```
docker rm -f ollama
docker run -d -p 11434:11434 -v ~/ollama:/root/.ollama --name ollama alpine/ollama
```

* Download the models, for example, `llama3.2`, only run once. It will save the model locally, you can re-use it later.

```
docker exec -ti ollama ollama pull llama3.2
```

* Test its API service with curl 
```
$ curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt":"Why is the sky blue?"
}'

{"model":"llama3.2","created_at":"2024-10-16T00:25:58.59931201Z","response":"The","done":false}
{"model":"llama3.2","created_at":"2024-10-16T00:25:58.695826838Z","response":" sky","done":false}
{"model":"llama3.2","created_at":"2024-10-16T00:25:58.780917761Z","response":" appears","done":false}
{"model":"llama3.2","created_at":"2024-10-16T00:25:58.992556209Z","response":" blue","done":false}
{"model":"llama3.2","created_at":"2024-10-16T00:25:59.085970606Z","response":" because","done":false}
{"model":"llama3.2","created_at":"2024-10-16T00:25:59.30869749Z","response":" of","done":false}
...
```

If you monitor the CPU usage, for example, with [htop](https://htop.dev/), you would see the high CPU usage

You can deploy the Ollama web UI to chat with it directly. There are many tools available, but I won't recommend any specific one.

## Use case

this image could be deployed to any enviornment, for example, in kubernetes cluster, you can use it to analyze logs, streamlining logs with local LLMs, etc.
