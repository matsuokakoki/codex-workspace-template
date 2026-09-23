FROM node:22-bookworm-slim
WORKDIR /workspace
COPY package.json ./
COPY src/ ./src/
COPY tests/ ./tests/
CMD ["node", "src/index.js"]
