FROM node:12-alpine
MAINTAINER Ryan Petschek <petschekr@gmail.com>

# Deis wants bash
RUN apk update && apk add bash
RUN apk add git

# Bundle app source
WORKDIR /usr/src/registration
COPY package.json /usr/src/registration/package.json
COPY package-lock.json /usr/src/registration/package-lock.json
RUN npm install

COPY . /usr/src/registration
RUN npm run build

# Set Timezone to EST
RUN apk add tzdata
ENV TZ="/usr/share/zoneinfo/America/Denver"
ENV NODE_ENV="production"

# Deis wants EXPOSE and CMD
EXPOSE 3000
CMD ["npm", "start"]
