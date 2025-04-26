FROM node:18

WORKDIR /app

COPY ./app/package*.json ./
RUN ls -la
RUN npm install

COPY ./app .

EXPOSE 8080
CMD ["node", "index.js"]
