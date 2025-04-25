FROM node:18

WORKDIR /app

COPY package*.json ./
RUN ls -la
RUN npm install

COPY . .

EXPOSE 8080
CMD ["node", "index.js"]
