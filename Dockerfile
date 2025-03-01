FROM node:18 as base

RUN npm install -g pnpm

RUN pnpm config set httpTimeout 1200000

WORKDIR /snailycad

COPY . ./

FROM base as deps

RUN pnpm install

FROM deps as api

ENV NODE_ENV="production"

RUN pnpm turbo run build --filter=@snailycad/api

FROM deps as client

ENV NODE_ENV="production"

RUN rm -rf /snailycad/apps/client/.next

RUN pnpm create-images-domain

RUN pnpm turbo run build --filter=@snailycad/client

# Copy the start script into the container
COPY start.sh /snailycad/start.sh

# Make the start script executable
RUN chmod +x /snailycad/start.sh

# Set the working directory to the root of the project
WORKDIR /snailycad

# Use the start script to start both services
CMD ["/snailycad/start.sh"]
