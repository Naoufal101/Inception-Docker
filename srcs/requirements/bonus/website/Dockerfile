FROM debian:bookworm-slim AS builder

# Install Go
RUN apt-get update && apt-get install -y golang && rm -rf /var/lib/apt/lists/*

# Copy and compile
WORKDIR /app
COPY conf/web_server.go .
# Build a standalone binary named 'server'
RUN go build -o server web_server.go


FROM debian:bookworm-slim

WORKDIR /app

# Copy ONLY the binary and the HTML files from the builder
COPY --from=builder /app/server /app/server
COPY public/ /app/public/

EXPOSE 1313

# Run the binary directly (no "go run" needed)
CMD ["/app/server"]