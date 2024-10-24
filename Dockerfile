FROM ollama/ollama AS ollama

FROM cgr.dev/chainguard/wolfi-base

ARG TARGETARCH

RUN apk add --no-cache libstdc++

COPY --from=ollama /usr/bin/ollama /usr/bin/ollama

# COPY --from=ollama /usr/lib/ollama/runners/cpu /usr/lib/ollama/runners/cpu
# In arm64 ollama/ollama image, there is no avx libraries and seems they are not must-have (#2903, #3891)
# COPY --from=ollama /usr/lib/ollama/runners/cpu_avx /usr/lib/ollama/runners/cpu_avx
# COPY --from=ollama /usr/lib/ollama/runners/cpu_avx2 /usr/lib/ollama/runners/cpu_avx2

COPY ./${TARGETARCH}/ /usr/lib/ollama/runners/

# Environment variable setup
ENV OLLAMA_HOST=0.0.0.0

# Expose port for the service
EXPOSE 11434

ENTRYPOINT ["/usr/bin/ollama"]
CMD ["serve"]
