#!/bin/bash
# Start the API in the background
cd /snailycad/apps/api
pnpm start &

# Start the client in the foreground
cd /snailycad/apps/client
pnpm start
