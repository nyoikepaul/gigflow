# ==========================================
# STAGE 1: The Build Environment (Heavyweight)
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# Install system essentials for native builds
RUN apk add --no-cache python3 make g++

# Cache dependency trees
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Pull in source code and compile production assets
COPY . .
RUN npm run build

# Remove development footprints
RUN npm prune --production

# ==========================================
# STAGE 2: The Production Runtime (Ultra-Light)
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

# Establish a non-privileged system user for process isolation
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Selectively pull ONLY the compiled Next.js artifacts and static files
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next

# Enforce secure file ownership permissions
RUN chown -R nextjs:nodejs /app
USER nextjs

EXPOSE 3000
ENV PORT=3000

# The correct runtime entrypoint for a Next.js application
CMD ["npx", "next", "start"]
