FROM docker.io/ollama/ollama:latest AS ollama

# Drop GPU backends (each lives in its own subdir) in a separate stage so the
# deleted bytes never end up in the final image's layers.
FROM ollama AS ollama-cpu-only
RUN rm -rf /usr/lib/ollama/cuda_v* /usr/lib/ollama/rocm_v* /usr/lib/ollama/vulkan /usr/lib/ollama/cuda_jetpack*

FROM cgr.dev/chainguard/wolfi-base

# ARG TARGETARCH

RUN apk add --no-cache libstdc++

COPY --from=ollama-cpu-only /usr/bin/ollama /usr/bin/ollama
COPY --from=ollama-cpu-only /usr/lib/ollama /usr/lib/ollama

# In arm64 ollama/ollama image, there is no avx libraries and seems they are not must-have (#2903, #3891)
# COPY --from=ollama /usr/lib/ollama/runners/cpu_avx /usr/lib/ollama/runners/cpu_avx
# COPY --from=ollama /usr/lib/ollama/runners/cpu_avx2 /usr/lib/ollama/runners/cpu_avx2

# Environment variable setup
ENV OLLAMA_HOST=0.0.0.0

# Expose port for the service
EXPOSE 11434

ENTRYPOINT ["/usr/bin/ollama"]
CMD ["serve"]
