FROM node:23@sha256:c5bfe90b30e795ec57bcc0040065ca6f284af84a1dafd22a207bd6b48c39ce01

WORKDIR /app
COPY package*.json ./

RUN npm install

RUN npm install -g esbuild


COPY . .

EXPOSE 3000

CMD ["npm", "run","watch"]
